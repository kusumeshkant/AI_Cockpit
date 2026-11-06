import 'package:dartz/dartz.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';
import 'package:cockpit/features/agent_services/domain/repositories/agent_services_repository.dart';
import 'package:cockpit/features/agent_services/domain/usecases/agent_services_usecases.dart';

/// In-memory services world for controller / widget tests.
class FakeServices implements AgentServicesRepository {
  /// Creates the world.
  FakeServices({List<AgentService>? services, Map<String, ServiceAccess>? access})
      : services = services ?? [contentCreator, inboxHelper],
        access = access ?? {};

  /// A listed active service.
  static const contentCreator = AgentService(
    slug: 'content-creator',
    displayName: 'Content creator',
    description: 'Drafts social posts for your review.',
    status: ServiceStatus.active,
    ui: ServiceUi.native,
  );

  /// A second listed service.
  static const inboxHelper = AgentService(
    slug: 'inbox-helper',
    displayName: 'Inbox helper',
    description: 'Suggests replies.',
    status: ServiceStatus.active,
  );

  List<AgentService> services;
  Map<String, ServiceAccess> access;

  /// Failure the next enable / disable returns (then cleared), if set.
  Failure? nextFailure;

  /// Failure every list read returns, if set.
  Failure? listFailure;

  int listCalls = 0;
  final List<String> requestIds = [];

  @override
  Future<Either<Failure, List<AgentService>>> listServices() async {
    listCalls++;
    final f = listFailure;
    return f == null ? Right(List.of(services)) : Left(f);
  }

  @override
  Future<Either<Failure, List<ServiceAccess>>> listAccess() async => Right(List.of(access.values));

  Future<Either<Failure, ServiceAccess>> _set(String slug, AccessState state, String requestId) async {
    requestIds.add(requestId);
    final f = nextFailure;
    if (f != null) {
      nextFailure = null;
      return Left(f);
    }
    final row = ServiceAccess(serviceSlug: slug, state: state, consentVersion: currentServiceConsentVersion);
    access[slug] = row;
    return Right(row);
  }

  @override
  Future<Either<Failure, ServiceAccess>> enableService({
    required String slug,
    required String consentVersion,
    required String requestId,
  }) =>
      _set(slug, AccessState.active, requestId);

  @override
  Future<Either<Failure, ServiceAccess>> disableService({required String slug, required String requestId}) =>
      _set(slug, AccessState.disabled, requestId);

  /// The four use cases over this world.
  ListServices get list => ListServices(this);

  /// [GetServiceAccess] over this world.
  GetServiceAccess get getAccess => GetServiceAccess(this);

  /// [EnableService] over this world.
  EnableService get enable => EnableService(this);

  /// [DisableService] over this world.
  DisableService get disable => DisableService(this);
}
