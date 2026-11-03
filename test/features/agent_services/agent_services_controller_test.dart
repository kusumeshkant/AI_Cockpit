import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/config/app_version.dart';
import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';
import 'package:cockpit/features/agent_services/presentation/controllers/agent_services_controller.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';

import '../../helpers/agent_services_fakes.dart';
import '../../helpers/fakes.dart';

/// Lets the load finish. The fake auth stream causes a rebuild, which runs
/// when the provider is next read, so read between pumps (as a widget would).
Future<void> settle(WidgetTester tester, ProviderContainer c) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump();
    c.read(agentServicesControllerProvider);
  }
}

void resumeApp(WidgetTester tester) {
  for (final s in [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
}

void main() {
  late FakeServices world;
  var ids = 0;

  ProviderContainer create({bool flag = true, bool? owner = true, String version = '0.1.1'}) {
    final c = ProviderContainer(
      overrides: [
        agentServicesProvider.overrideWithValue(flag),
        workspaceOwnerRoleProvider.overrideWithValue(owner),
        appVersionProvider.overrideWithValue(version),
        authControllerProvider.overrideWith(FakeAuthController.new),
        listServicesProvider.overrideWithValue(world.list),
        getServiceAccessProvider.overrideWithValue(world.getAccess),
        enableServiceProvider.overrideWithValue(world.enable),
        disableServiceProvider.overrideWithValue(world.disable),
        requestIdFactoryProvider.overrideWithValue(() => 'id-${++ids}'),
      ],
    );
    c.listen(agentServicesControllerProvider, (_, _) {});
    return c;
  }

  setUp(() {
    world = FakeServices();
    ids = 0;
  });

  testWidgets('flag off: empty, not visible, nothing read', (tester) async {
    final c = create(flag: false);
    await settle(tester, c);
    expect(c.read(agentServicesControllerProvider).value, isEmpty);
    expect(c.read(servicesVisibleProvider), isFalse);
    expect(world.listCalls, 0);
    c.dispose();
  });

  testWidgets('approver or unknown role: not visible', (tester) async {
    for (final owner in [false, null]) {
      final c = create(owner: owner);
      await settle(tester, c);
      expect(c.read(servicesVisibleProvider), isFalse, reason: 'owner=$owner');
      c.dispose();
    }
  });

  testWidgets('owner + flag + services: visible, listings merged with access', (tester) async {
    world.access = {'content-creator': const ServiceAccess(serviceSlug: 'content-creator', state: AccessState.active)};
    final c = create();
    await settle(tester, c);
    expect(c.read(servicesVisibleProvider), isTrue);
    final list = c.read(agentServicesControllerProvider).value!;
    expect(list.map((l) => l.availability), [ServiceAvailability.enabled, ServiceAvailability.notEnabled]);
    c.dispose();
  });

  testWidgets('owner + flag but no service listed: not visible', (tester) async {
    world.services = [];
    final c = create();
    await settle(tester, c);
    expect(c.read(servicesVisibleProvider), isFalse);
    c.dispose();
  });

  testWidgets('availability: paused, blocked / unknown read as unavailable', (tester) async {
    world.services = [
      FakeServices.contentCreator.copyWith(status: ServiceStatus.paused),
      FakeServices.inboxHelper,
      const AgentService(slug: 'odd', displayName: 'Odd', status: ServiceStatus.active),
    ];
    world.access = {
      'content-creator': const ServiceAccess(serviceSlug: 'content-creator', state: AccessState.active),
      'inbox-helper': const ServiceAccess(serviceSlug: 'inbox-helper', state: AccessState.blocked),
      'odd': const ServiceAccess(serviceSlug: 'odd'),
    };
    final c = create();
    await settle(tester, c);
    expect(c.read(agentServicesControllerProvider).value!.map((l) => l.availability),
        [ServiceAvailability.paused, ServiceAvailability.unavailable, ServiceAvailability.unavailable]);
    c.dispose();
  });

  testWidgets('enable / disable succeed and update the list', (tester) async {
    final c = create();
    await settle(tester, c);
    final notifier = c.read(agentServicesControllerProvider.notifier);
    expect(await notifier.enable('inbox-helper'), isNull);
    expect(c.read(serviceListingProvider('inbox-helper'))!.availability, ServiceAvailability.enabled);
    expect(await notifier.disable('inbox-helper'), isNull);
    expect(c.read(serviceListingProvider('inbox-helper'))!.availability, ServiceAvailability.notEnabled);
    c.dispose();
  });

  testWidgets('each failure comes back typed; the list is unchanged', (tester) async {
    final c = create();
    await settle(tester, c);
    for (final failure in const <Failure>[
      AgentUnavailableFailure(),
      ServiceNotEnabledFailure(),
      AppUpdateRequiredFailure(),
      ForbiddenFailure(),
      NetworkFailure(),
    ]) {
      world.nextFailure = failure;
      expect(await c.read(agentServicesControllerProvider.notifier).enable('inbox-helper'), failure);
      expect(c.read(serviceListingProvider('inbox-helper'))!.availability, ServiceAvailability.notEnabled);
    }
    c.dispose();
  });

  testWidgets('a retried action reuses its request id; a new action gets a new one', (tester) async {
    final c = create();
    await settle(tester, c);
    final notifier = c.read(agentServicesControllerProvider.notifier);
    world.nextFailure = const AgentUnavailableFailure();
    await notifier.enable('inbox-helper');
    await notifier.enable('inbox-helper'); // retry of the same action → same id
    await notifier.disable('inbox-helper'); // new action → new id
    world.nextFailure = const ServiceNotEnabledFailure();
    await notifier.enable('inbox-helper'); // not retryable → id dropped
    await notifier.enable('inbox-helper'); // → fresh id
    expect(world.requestIds, ['id-1', 'id-1', 'id-2', 'id-3', 'id-4']);
    c.dispose();
  });

  testWidgets('refreshes when the app resumes; a failed refresh keeps the list', (tester) async {
    final c = create();
    await settle(tester, c);
    final before = world.listCalls;
    world.services = [FakeServices.contentCreator];
    resumeApp(tester);
    await settle(tester, c);
    expect(world.listCalls, before + 1);
    expect(c.read(agentServicesControllerProvider).value, hasLength(1));
    world.listFailure = const NetworkFailure();
    resumeApp(tester);
    await settle(tester, c);
    expect(c.read(agentServicesControllerProvider).value, hasLength(1), reason: 'kept');
    c.dispose();
  });

  testWidgets('update required follows min_app_version', (tester) async {
    world.services = [FakeServices.contentCreator.copyWith(minAppVersion: '0.2.0')];
    final old = create(version: '0.1.9');
    await settle(tester, old);
    expect(old.read(serviceUpdateRequiredProvider('content-creator')), isTrue);
    old.dispose();
    final fresh = create(version: '0.2.0');
    await settle(tester, fresh);
    expect(fresh.read(serviceUpdateRequiredProvider('content-creator')), isFalse);
    fresh.dispose();
  });
}
