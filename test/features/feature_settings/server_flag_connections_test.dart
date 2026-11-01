import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';
import 'package:cockpit/features/feature_settings/presentation/controllers/feature_settings_controller.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/list_agent_triggers.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';
import 'package:cockpit/features/triggers/presentation/widgets/run_agent_button.dart';

import '../../helpers/fakes.dart';
import '../../helpers/feature_settings_fakes.dart';
import '../../helpers/pump_app.dart';

class _FakeConnectionsController extends ConnectionsController {
  @override
  Future<List<Agent>> build() async => const [
        Agent(id: 'g_email', name: 'Email agent', platform: AgentPlatform.n8n, callbackUrl: 'https://x.example/1'),
      ];
}

class _MockListTriggers extends Mock implements ListAgentTriggers {}

/// The server flag (backend feature_setting) switches the Connections
/// trigger UI at runtime: no rebuild, no re-release.
void main() {
  testWidgets('flipping the server flag hides / shows the Run button live', (tester) async {
    final listTriggers = _MockListTriggers();
    when(() => listTriggers()).thenAnswer(
      (_) async => const Right([
        AgentTrigger(
          agentId: 'g_email',
          triggerUrl: 'https://n8n.example.com/start',
          secretHint: 'abcd',
          enabled: true,
          minIntervalSecs: 30,
        ),
      ]),
    );
    final get = FakeGetFeatureSettings(serverFlags(triggers: true));

    await pumpApp(
      tester,
      const ConnectionsScreen(),
      overrides: [
        agentTriggersCapabilityProvider.overrideWithValue(true),
        getFeatureSettingsProvider.overrideWithValue(get),
        authControllerProvider.overrideWith(FakeAuthController.new),
        connectionsControllerProvider.overrideWith(_FakeConnectionsController.new),
        listAgentTriggersProvider.overrideWithValue(listTriggers),
      ],
    );
    final runButton = find.byKey(const Key('run.g_email'));
    final screen = tester.element(find.byType(ConnectionsScreen));
    final container = ProviderScope.containerOf(screen);
    Future<void> serverSays({required bool triggers}) async {
      get.next = serverFlags(triggers: triggers);
      await container.read(featureSettingsControllerProvider.notifier).refresh();
      await tester.pumpAndSettle();
    }

    expect(runButton, findsOneWidget, reason: 'server on');

    await serverSays(triggers: false);
    expect(runButton, findsNothing, reason: 'server switched off');
    expect(find.byType(RunAgentButton), findsNothing);
    expect(find.text('Email agent'), findsOneWidget, reason: 'the row itself stays');
    expect(tester.element(find.byType(ConnectionsScreen)), same(screen), reason: 'same screen, no remount');

    await serverSays(triggers: true);
    expect(runButton, findsOneWidget, reason: 'server switched back on');
  });

  testWidgets('fail closed: no server value known → no trigger UI', (tester) async {
    final listTriggers = _MockListTriggers();
    when(() => listTriggers()).thenAnswer((_) async => const Right([]));
    await pumpApp(
      tester,
      const ConnectionsScreen(),
      overrides: [
        agentTriggersCapabilityProvider.overrideWithValue(true),
        getFeatureSettingsProvider.overrideWithValue(FakeGetFeatureSettings(const Left(NetworkFailure()))),
        authControllerProvider.overrideWith(FakeAuthController.new),
        connectionsControllerProvider.overrideWith(_FakeConnectionsController.new),
        listAgentTriggersProvider.overrideWithValue(listTriggers),
      ],
    );
    expect(find.text('Email agent'), findsOneWidget);
    expect(find.byType(RunAgentButton), findsNothing);
    verifyNever(() => listTriggers());
  });
}
