import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connect_agent_screen.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/configure_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/list_agent_triggers.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';
import 'package:cockpit/features/triggers/presentation/widgets/trigger_config_section.dart';

import '../../helpers/pump_app.dart';

class _FakeConnectionsController extends ConnectionsController {
  @override
  Future<List<Agent>> build() async => const [];

  @override
  Future<Either<Failure, AgentCredentials>> createAgent({
    required String name,
    required String callbackUrl,
    required AgentPlatform platform,
  }) async =>
      Right(
        AgentCredentials(
          agent: Agent(id: 'agt_new', name: name, callbackUrl: callbackUrl, platform: platform),
          inboundUrl: 'https://api.cockpit.app/v1/in/agt_new',
          inboundSecret: 'whsec_0123456789abcdef3a9f',
        ),
      );
}

class _MockConfigureTrigger extends Mock implements ConfigureTrigger {}

class _MockListTriggers extends Mock implements ListAgentTriggers {}

void main() {
  late _MockConfigureTrigger configure;
  late _MockListTriggers listTriggers;

  setUp(() {
    configure = _MockConfigureTrigger();
    listTriggers = _MockListTriggers();
    when(() => listTriggers()).thenAnswer((_) async => const Right([]));
    when(() => configure(
          agentId: any(named: 'agentId'),
          triggerUrl: any(named: 'triggerUrl'),
          minIntervalSecs: any(named: 'minIntervalSecs'),
        )).thenAnswer(
      (_) async => const Right(
        TriggerCredentials(
          trigger: AgentTrigger(
            agentId: 'agt_new',
            triggerUrl: 'https://n8n.example.com/start',
            secretHint: '9f1c',
            enabled: true,
            minIntervalSecs: 30,
          ),
          secret: 'whtrig_secretvalue_0123456789_9f1c',
        ),
      ),
    );
  });

  Future<void> createAgent(WidgetTester tester, {required bool flag}) async {
    await pumpApp(
      tester,
      const ConnectAgentScreen(),
      overrides: [
        agentTriggersOverride(enabled: flag),
        connectionsControllerProvider.overrideWith(_FakeConnectionsController.new),
        configureTriggerProvider.overrideWithValue(configure),
        listAgentTriggersProvider.overrideWithValue(listTriggers),
      ],
    );
    await tester.enterText(find.byType(TextField).at(0), 'Email agent');
    await tester.enterText(find.byType(TextField).at(1), 'https://n8n.example.com/hook');
    await tester.tap(find.text('Create connection'));
    await tester.pumpAndSettle();
  }

  testWidgets('flag OFF: no trigger section after connecting', (tester) async {
    await createAgent(tester, flag: false);
    expect(find.text('Shown once — copy it now'), findsOneWidget);
    expect(find.byType(TriggerConfigSection), findsNothing);
    expect(find.text('Run from app (optional)'), findsNothing);
  });

  testWidgets('flag ON: collapsed section → allow → https URL → secret shown once', (tester) async {
    await createAgent(tester, flag: true);

    expect(find.text('Run from app (optional)'), findsOneWidget);
    expect(find.text('Allow running this agent from the app'), findsNothing, reason: 'collapsed');

    await tester.ensureVisible(find.byKey(const Key('triggerSection.toggle')));
    await tester.tap(find.byKey(const Key('triggerSection.toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('triggerSection.allow')));
    await tester.pumpAndSettle();

    final urlField = find.widgetWithText(TextField, 'https://your-workflow.example/start');
    await tester.enterText(urlField, 'http://insecure.example');
    await tester.ensureVisible(find.text('Save trigger'));
    await tester.tap(find.text('Save trigger'));
    await tester.pump();
    expect(find.text('Enter a valid https:// URL.'), findsOneWidget);
    verifyNever(() => configure(
          agentId: any(named: 'agentId'),
          triggerUrl: any(named: 'triggerUrl'),
          minIntervalSecs: any(named: 'minIntervalSecs'),
        ));

    await tester.enterText(urlField, 'https://n8n.example.com/start');
    await tester.tap(find.text('Save trigger'));
    await tester.pumpAndSettle();

    verify(() => configure(agentId: 'agt_new', triggerUrl: 'https://n8n.example.com/start')).called(1);
    expect(find.text('Trigger secret — shown once, copy it now'), findsOneWidget);
    expect(find.text('whtrig_••••••••••••9f1c'), findsOneWidget);
    expect(find.textContaining('secretvalue'), findsNothing, reason: 'the plaintext is never displayed');
    expect(find.text('Save trigger'), findsNothing);
  });
}
