// Agent Triggers goldens (flag ON): the Connections Run states (idle with
// last run, started, rate-limited error, agent without a trigger) and the
// connect-agent trigger section after saving (secret shown once). Light and
// dark, English and Hindi.
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connect_agent_screen.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/configure_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/list_agent_triggers.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';

import '../helpers/pump_app.dart';
import '../helpers/tolerant_golden_comparator.dart';

class _MockListTriggers extends Mock implements ListAgentTriggers {}

class _MockConfigureTrigger extends Mock implements ConfigureTrigger {}

const _agents = [
  Agent(id: 'g_idle', name: 'Email agent', platform: AgentPlatform.n8n, callbackUrl: 'https://x.example/1'),
  Agent(id: 'g_started', name: 'Finance bot', platform: AgentPlatform.make, callbackUrl: 'https://x.example/2'),
  Agent(id: 'g_error', name: 'Leads bot', platform: AgentPlatform.zapier, callbackUrl: 'https://x.example/3'),
  Agent(id: 'g_none', name: 'Support triage', callbackUrl: 'https://x.example/4'),
];

AgentTrigger _trigger(String agentId, {Duration? ago}) => AgentTrigger(
      agentId: agentId,
      triggerUrl: 'https://n8n.example.com/start',
      secretHint: 'abcd',
      enabled: true,
      minIntervalSecs: 30,
      lastRunAt: ago == null ? null : DateTime.now().subtract(ago),
    );

class _Agents extends ConnectionsController {
  @override
  Future<List<Agent>> build() async => _agents;
}

class _NewAgent extends ConnectionsController {
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

const _variants = [
  ('light_en', ThemeMode.light, Locale('en')),
  ('dark_en', ThemeMode.dark, Locale('en')),
  ('light_hi', ThemeMode.light, Locale('hi')),
  ('dark_hi', ThemeMode.dark, Locale('hi')),
];

void main() {
  setUpAll(() => useTolerantGoldens('agent_triggers_golden_test.dart'));

  for (final (name, themeMode, locale) in _variants) {
    testWidgets('connections Run states ($name)', skip: skipGoldensOnCi, (tester) async {
      final listTriggers = _MockListTriggers();
      when(() => listTriggers()).thenAnswer(
        (_) async => Right([
          _trigger('g_idle', ago: const Duration(minutes: 12)),
          _trigger('g_started', ago: const Duration(seconds: 5)),
          _trigger('g_error', ago: const Duration(hours: 2)),
        ]),
      );
      final states = <String, RunAgentState>{
        'g_started': const RunAgentSuccess(TriggerRun(runId: 'r1', delivered: true, detail: 'http_200')),
        'g_error': const RunAgentError(RateLimitedFailure('rate_limited', Duration(seconds: 17))),
      };

      await pumpApp(
        tester,
        const ConnectionsScreen(),
        themeMode: themeMode,
        locale: locale,
        overrides: [
          agentTriggersOverride(enabled: true),
          connectionsControllerProvider.overrideWith(_Agents.new),
          listAgentTriggersProvider.overrideWithValue(listTriggers),
          runAgentControllerProvider.overrideWithBuild(
            (ref, notifier) => states[notifier.agentId] ?? const RunAgentIdle(),
          ),
        ],
      );
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('triggers/connections_$name.png'));
    });

    testWidgets('connect agent · trigger saved ($name)', skip: skipGoldensOnCi, (tester) async {
      final configure = _MockConfigureTrigger();
      final listTriggers = _MockListTriggers();
      when(() => listTriggers()).thenAnswer((_) async => const Right([]));
      when(() => configure(
            agentId: any(named: 'agentId'),
            triggerUrl: any(named: 'triggerUrl'),
            minIntervalSecs: any(named: 'minIntervalSecs'),
          )).thenAnswer(
        (_) async => Right(
          TriggerCredentials(trigger: _trigger('agt_new'), secret: 'whtrig_secretvalue_0123456789_9f1c'),
        ),
      );

      await pumpApp(
        tester,
        const ConnectAgentScreen(),
        themeMode: themeMode,
        locale: locale,
        size: const Size(390, 1100),
        overrides: [
          agentTriggersOverride(enabled: true),
          connectionsControllerProvider.overrideWith(_NewAgent.new),
          configureTriggerProvider.overrideWithValue(configure),
          listAgentTriggersProvider.overrideWithValue(listTriggers),
        ],
      );
      await tester.enterText(find.byType(TextField).at(0), 'Email agent');
      await tester.enterText(find.byType(TextField).at(1), 'https://n8n.example.com/hook');
      // Before creation the only AppButton is "Create connection".
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('triggerSection.toggle')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('triggerSection.allow')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'https://n8n.example.com/start');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('triggers/connect_trigger_saved_$name.png'));
    });
  }
}
