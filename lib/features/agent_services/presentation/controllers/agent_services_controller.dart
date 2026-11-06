// Feature: agent_services · Layer: presentation
// Agent services for the workspace owner (Release A, behind the server flag
// `agent_services`):
//  * agentServicesControllerProvider — listed services merged with the
//    workspace's access; empty while the flag is off (nothing is read).
//    Re-read on resume and when the signed-in user changes.
//  * enable / disable — one request id per user action, reused when the same
//    action is retried after a retryable failure (the gateway's idempotency
//    key); a new action gets a new id.
//  * servicesVisibleProvider — flag on AND known owner AND ≥ 1 service.
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/config/app_version.dart';
import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/request_id.dart';
import 'package:cockpit/core/utils/semver.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';
import 'package:cockpit/features/agent_services/domain/usecases/agent_services_usecases.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart'
    show workspaceOwnerRoleProvider;

/// Use cases (overridable in tests).
final listServicesProvider = Provider<ListServices>((ref) => getIt<ListServices>());

/// [GetServiceAccess] use case.
final getServiceAccessProvider = Provider<GetServiceAccess>((ref) => getIt<GetServiceAccess>());

/// [EnableService] use case.
final enableServiceProvider = Provider<EnableService>((ref) => getIt<EnableService>());

/// [DisableService] use case.
final disableServiceProvider = Provider<DisableService>((ref) => getIt<DisableService>());

/// Request id factory (overridable in tests).
final requestIdFactoryProvider = Provider<String Function()>((ref) => newRequestId);

/// Services with the workspace's access.
class AgentServicesController extends AsyncNotifier<List<ServiceListing>> {
  /// Ids of user actions that failed retryably, by "op:slug" (reused on retry).
  final Map<String, String> _retryIds = {};

  @override
  Future<List<ServiceListing>> build() async {
    if (!ref.watch(agentServicesProvider)) return const [];
    ref.watch(authControllerProvider.select((auth) => auth.value?.id));
    final lifecycle = AppLifecycleListener(onResume: () => unawaited(refresh()));
    ref.onDispose(lifecycle.dispose);
    return _load();
  }

  Future<List<ServiceListing>> _load() async {
    final services = await ref.read(listServicesProvider)();
    final access = await ref.read(getServiceAccessProvider)();
    final list = services.fold((failure) => throw failure, (value) => value);
    final rows = access.fold((failure) => throw failure, (value) => value);
    final bySlug = {for (final row in rows) row.serviceSlug: row};
    return [for (final service in list) ServiceListing(service: service, access: bySlug[service.slug])];
  }

  /// Re-reads services and access, keeping the current list on failure.
  Future<void> refresh() async {
    if (!ref.mounted || !ref.read(agentServicesProvider)) return;
    try {
      final next = await _load();
      if (ref.mounted) state = AsyncData(next);
    } on Object {
      // Keep what is shown; the next refresh tries again.
    }
  }

  /// Enables [slug] (consent accepted). Returns `null` on success.
  Future<Failure?> enable(String slug) => _run(
        'enable:$slug',
        (id) => ref.read(enableServiceProvider)(slug: slug, consentVersion: currentServiceConsentVersion, requestId: id),
      );

  /// Disables [slug]. Returns `null` on success.
  Future<Failure?> disable(String slug) =>
      _run('disable:$slug', (id) => ref.read(disableServiceProvider)(slug: slug, requestId: id));

  Future<Failure?> _run(
    String action,
    Future<Either<Failure, ServiceAccess>> Function(String requestId) call,
  ) async {
    final id = _retryIds[action] ?? ref.read(requestIdFactoryProvider)();
    final result = await call(id);
    final failure = result.fold<Failure?>((f) => f, (_) => null);
    if (failure != null && isRetryable(failure)) {
      _retryIds[action] = id;
    } else {
      _retryIds.remove(action);
    }
    if (!ref.mounted) return failure;
    result.fold((_) {}, (updated) {
      final current = state.value;
      if (current != null) {
        state = AsyncData([
          for (final listing in current)
            listing.service.slug == updated.serviceSlug ? listing.copyWith(access: updated) : listing,
        ]);
      }
      unawaited(refresh());
    });
    return failure;
  }
}

/// The services list.
final agentServicesControllerProvider =
    AsyncNotifierProvider<AgentServicesController, List<ServiceListing>>(AgentServicesController.new);

/// Whether the Services section exists: server flag on, the user is known to
/// own the workspace (approvers never see it; an unknown role hides it), and
/// at least one service is listed.
final servicesVisibleProvider = Provider<bool>((ref) {
  if (!ref.watch(agentServicesProvider)) return false;
  if (ref.watch(workspaceOwnerRoleProvider) != true) return false;
  return ref.watch(agentServicesControllerProvider.select((list) => (list.value ?? const []).isNotEmpty));
});

/// One listed service, or `null` (not listed / not loaded).
final serviceListingProvider = Provider.family<ServiceListing?, String>((ref, slug) {
  return ref.watch(
    agentServicesControllerProvider.select(
      (list) => (list.value ?? const <ServiceListing>[]).where((l) => l.service.slug == slug).firstOrNull,
    ),
  );
});

/// Whether this app is older than the service's `min_app_version`.
final serviceUpdateRequiredProvider = Provider.family<bool, String>((ref, slug) {
  final min = ref.watch(serviceListingProvider(slug).select((l) => l?.service.minAppVersion));
  return isVersionBelow(ref.watch(appVersionProvider), min);
});
