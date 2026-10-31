import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/domain/entities/callback_delivery.dart';
import 'package:cockpit/features/connections/domain/usecases/get_last_callback.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/agent_detail_screen.dart';

import '../../helpers/action_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockGetLastCallback extends Mock implements GetLastCallback {}

class _FakeConnectionsController extends ConnectionsController {
  _FakeConnectionsController(this.agents, this.sent, this.failure);

  final List<Agent> agents;
  final List<String> sent;
  final Failure? failure;

  @override
  Future<List<Agent>> build() async => agents;

  @override
  Future<Failure?> sendTestAction(String agentId) async {
    sent.add(agentId);
    return failure;
  }
}

final Agent _live = Agent(
  id: 'g1',
  name: 'Email agent',
  platform: AgentPlatform.n8n,
  callbackUrl: 'https://n8n.example.com/hook',
  lastActionAt: DateTime.now().subtract(const Duration(hours: 2)),
);

const Agent _paused = Agent(
  id: 'g2',
  name: 'Support triage',
  status: AgentStatus.disabled,
  callbackUrl: 'https://support.example.com/hook',
);

void main() {
  late List<String> sent;
  late _MockGetLastCallback lastCallback;

  setUp(() {
    sent = [];
    lastCallback = _MockGetLastCallback();
    when(() => lastCallback(any())).thenAnswer((_) async => const Right(null));
  });

  Future<void> pumpDetail(
    WidgetTester tester, {
    String agentId = 'g1',
    List<Agent>? agents,
    List<ActionItem> feed = const [],
    bool testActions = true,
    bool canManage = true,
    bool? triggers,
    Failure? sendFailure,
    Size size = phoneSize,
    ThemeMode themeMode = ThemeMode.light,
    Locale locale = const Locale('en'),
  }) =>
      pumpApp(
        tester,
        AgentDetailScreen(agentId: agentId),
        size: size,
        themeMode: themeMode,
        locale: locale,
        overrides: [
          connectionsControllerProvider.overrideWith(
            () => _FakeConnectionsController(agents ?? [_live, _paused], sent, sendFailure),
          ),
          feedOverride(feed),
          getLastCallbackProvider.overrideWithValue(lastCallback),
          testActionsSupportedProvider.overrideWithValue(testActions),
          canManageAgentsProvider.overrideWithValue(canManage),
          if (triggers != null) agentTriggersOverride(enabled: triggers),
        ],
      );

  Finder sendButton() => find.byKey(const Key('agentDetail.sendTest'));
  Finder inRow(String row, String text) => find.descendant(
        of: find.byKey(Key('agentDetail.$row')),
        matching: find.text(text),
      );

  testWidgets('shows status, last action, callback state and the callback URL', (tester) async {
    when(() => lastCallback('g1')).thenAnswer(
      (_) async => Right(
        CallbackDelivery(
          state: CallbackDeliveryState.delivered,
          at: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ),
    );
    await pumpDetail(tester);

    expect(find.text('Email agent'), findsOneWidget);
    expect(inRow('status', 'LIVE'), findsOneWidget);
    expect(inRow('lastAction', '2 h ago'), findsOneWidget);
    expect(inRow('callback', 'Delivered 5 min ago'), findsOneWidget);
    expect(find.text('https://n8n.example.com/hook'), findsOneWidget);
    expect(sendButton(), findsOneWidget);
  });

  for (final (state, label) in [
    (CallbackDeliveryState.retrying, 'Retrying · last attempt just now'),
    (CallbackDeliveryState.failed, 'Failed just now'),
  ]) {
    testWidgets('callback ${state.name}', (tester) async {
      when(() => lastCallback('g1'))
          .thenAnswer((_) async => Right(CallbackDelivery(state: state, at: DateTime.now())));
      await pumpDetail(tester);
      expect(inRow('callback', label), findsOneWidget);
    });
  }

  testWidgets('no callback yet is a plain line', (tester) async {
    await pumpDetail(tester);
    expect(
      inRow('callback', 'No callbacks yet. One is sent when you decide an action.'),
      findsOneWidget,
    );
  });

  testWidgets('a failed callback read does not block the screen', (tester) async {
    when(() => lastCallback('g1')).thenAnswer((_) async => const Left(NetworkFailure('offline')));
    await pumpDetail(tester);
    expect(inRow('callback', "Couldn't load the delivery state."), findsOneWidget);
    expect(inRow('status', 'LIVE'), findsOneWidget);
  });

  testWidgets('last action comes from the live feed when the list is stale', (tester) async {
    await pumpDetail(
      tester,
      agents: [_live.copyWith(lastActionAt: null)],
      feed: [pendingEmail.copyWith(agentId: 'g1', createdAt: DateTime.now())],
    );

    expect(inRow('lastAction', 'just now'), findsOneWidget);
    expect(find.text('No actions yet'), findsNothing);
  });

  testWidgets('an agent that never sent an action', (tester) async {
    await pumpDetail(tester, agents: [_live.copyWith(lastActionAt: null)]);

    expect(inRow('lastAction', 'No actions yet'), findsOneWidget);
  });

  for (final triggers in [false, true]) {
    testWidgets('Send a test action sends for this agent (Agent Triggers ${triggers ? 'on' : 'off'})',
        (tester) async {
      await pumpDetail(tester, triggers: triggers);

      await tester.tap(sendButton());
      await tester.pumpAndSettle();

      expect(sent, ['g1']);
      expect(find.text('Test action sent — check your Actions feed.'), findsOneWidget);
    });
  }

  testWidgets('a failed test action shows the failure', (tester) async {
    await pumpDetail(tester, sendFailure: const RateLimitedFailure());

    await tester.tap(sendButton());
    await tester.pumpAndSettle();

    expect(sent, ['g1']);
    expect(find.text('Test action sent — check your Actions feed.'), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('a paused agent cannot be sent a test action', (tester) async {
    await pumpDetail(tester, agentId: 'g2');

    expect(inRow('status', 'PAUSED'), findsOneWidget);
    expect(find.text("This agent is paused, so it can't receive actions."), findsOneWidget);
    await tester.tap(sendButton(), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(sent, isEmpty);
  });

  testWidgets('no test action in demo mode', (tester) async {
    await pumpDetail(tester, testActions: false);
    expect(sendButton(), findsNothing);
  });

  testWidgets('no test action for an approver, who still sees the detail', (tester) async {
    await pumpDetail(tester, canManage: false);
    expect(sendButton(), findsNothing);
    expect(inRow('status', 'LIVE'), findsOneWidget);
  });

  testWidgets('an unknown agent says so', (tester) async {
    await pumpDetail(tester, agentId: 'gone');

    expect(find.text('This agent no longer exists.'), findsOneWidget);
    expect(sendButton(), findsNothing);
  });

  for (final (label, themeMode, locale) in [
    ('light en', ThemeMode.light, const Locale('en')),
    ('dark hi', ThemeMode.dark, const Locale('hi')),
  ]) {
    for (final agentId in ['g1', 'g2']) {
      testWidgets('lays out at 320px without overflow ($label, $agentId)', (tester) async {
        when(() => lastCallback(any())).thenAnswer(
          (_) async => Right(CallbackDelivery(state: CallbackDeliveryState.retrying, at: DateTime.now())),
        );
        await pumpDetail(
          tester,
          agentId: agentId,
          size: narrowPhoneSize,
          themeMode: themeMode,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}
