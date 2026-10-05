import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/list_agent_triggers.dart';
import 'package:cockpit/features/triggers/domain/usecases/run_agent.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';
import 'package:cockpit/features/triggers/presentation/widgets/run_agent_button.dart';

import '../../helpers/pump_app.dart';

class _FakeConnectionsController extends ConnectionsController {
  @override
  Future<List<Agent>> build() async => _agents;
}

class _MockListTriggers extends Mock implements ListAgentTriggers {}

class _MockRunAgent extends Mock implements RunAgent {}

final _agents = [
  const Agent(id: 'g_email', name: 'Email agent', platform: AgentPlatform.n8n, callbackUrl: 'https://x.example/1'),
  const Agent(id: 'g_plain', name: 'Finance bot', platform: AgentPlatform.make, callbackUrl: 'https://x.example/2'),
  const Agent(id: 'g_off', name: 'Support triage', callbackUrl: 'https://x.example/3'),
];

final _triggers = [
  AgentTrigger(
    agentId: 'g_email',
    triggerUrl: 'https://n8n.example.com/start',
    secretHint: 'abcd',
    enabled: true,
    minIntervalSecs: 30,
    lastRunAt: DateTime.now().subtract(const Duration(minutes: 12)),
  ),
  const AgentTrigger(
    agentId: 'g_off',
    triggerUrl: 'https://x.example/start',
    secretHint: 'efgh',
    enabled: false,
    minIntervalSecs: 30,
  ),
];

void main() {
  late _MockListTriggers listTriggers;
  late _MockRunAgent runAgent;

  setUp(() {
    listTriggers = _MockListTriggers();
    runAgent = _MockRunAgent();
    when(() => listTriggers()).thenAnswer((_) async => Right(_triggers));
  });

  Future<void> pumpConnections(
    WidgetTester tester, {
    required bool flag,
    Locale locale = const Locale('en'),
    Size size = phoneSize,
  }) =>
      pumpApp(
        tester,
        const ConnectionsScreen(),
        locale: locale,
        size: size,
        overrides: [
          agentTriggersOverride(enabled: flag),
          connectionsControllerProvider.overrideWith(_FakeConnectionsController.new),
          listAgentTriggersProvider.overrideWithValue(listTriggers),
          runAgentUseCaseProvider.overrideWithValue(runAgent),
        ],
      );

  Finder runButton(String agentId) => find.byKey(Key('run.$agentId'));

  testWidgets('flag OFF: no Run button, no trigger reads', (tester) async {
    await pumpConnections(tester, flag: false);

    expect(find.text('Email agent'), findsOneWidget);
    expect(find.byType(RunAgentButton), findsNothing);
    expect(find.byType(TriggerStatusLine), findsNothing);
    verifyNever(() => listTriggers());
  });

  testWidgets('flag ON: Run button only for agents with an ENABLED trigger', (tester) async {
    await pumpConnections(tester, flag: true);

    expect(runButton('g_email'), findsOneWidget);
    expect(runButton('g_plain'), findsNothing, reason: 'no trigger configured');
    expect(runButton('g_off'), findsNothing, reason: 'trigger disabled');
    expect(find.byTooltip('Run agent'), findsOneWidget);
    expect(find.text('last run · 12 min ago'), findsOneWidget);
    expect(tester.getSize(find.byTooltip('Run agent')).height, greaterThanOrEqualTo(44));
  });

  testWidgets('tap runs once; taps while running are ignored; success shows STARTED then fades', (tester) async {
    final pending = Completer<Either<Failure, TriggerRun>>();
    when(() => runAgent('g_email')).thenAnswer((_) => pending.future);
    await pumpConnections(tester, flag: true);

    await tester.tap(find.byTooltip('Run agent'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Second tap while running: the button is gone (spinner) and run() is debounced.
    await tester.tap(runButton('g_email'), warnIfMissed: false);
    await tester.pump();
    verify(() => runAgent('g_email')).called(1);

    pending.complete(const Right(TriggerRun(runId: 'r1', delivered: true, detail: 'http_200')));
    await tester.pumpAndSettle();
    expect(find.text('STARTED'), findsOneWidget);

    await tester.pump(RunAgentController.successDisplay);
    await tester.pumpAndSettle();
    expect(find.text('STARTED'), findsNothing);
    expect(find.byTooltip('Run agent'), findsOneWidget);
  });

  testWidgets('rate limited: note with seconds + retry', (tester) async {
    when(() => runAgent('g_email'))
        .thenAnswer((_) async => const Left(RateLimitedFailure('rate_limited', Duration(seconds: 17))));
    await pumpConnections(tester, flag: true);

    await tester.tap(find.byTooltip('Run agent'));
    await tester.pumpAndSettle();
    expect(find.text('Try again in 17s'), findsOneWidget);
    expect(find.byTooltip('Retry'), findsOneWidget);

    when(() => runAgent('g_email'))
        .thenAnswer((_) async => const Right(TriggerRun(runId: 'r2', delivered: true, detail: 'http_200')));
    await tester.tap(find.byTooltip('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('STARTED'), findsOneWidget);
    await tester.pump(RunAgentController.successDisplay);
    await tester.pumpAndSettle();
  });

  testWidgets('undelivered run shows "Run failed"', (tester) async {
    when(() => runAgent('g_email'))
        .thenAnswer((_) async => const Right(TriggerRun(runId: 'r3', delivered: false, detail: 'http_500')));
    await pumpConnections(tester, flag: true);

    await tester.tap(find.byTooltip('Run agent'));
    await tester.pumpAndSettle();
    expect(find.text('Run failed'), findsOneWidget);
  });

  for (final (label, locale) in [('en', const Locale('en')), ('hi', const Locale('hi'))]) {
    testWidgets('flag ON lays out at 320px without overflow ($label)', (tester) async {
      await pumpConnections(tester, flag: true, locale: locale, size: narrowPhoneSize);
      expect(tester.takeException(), isNull);
    });
  }
}
