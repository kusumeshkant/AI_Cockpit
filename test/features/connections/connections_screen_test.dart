import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cockpit/core/di/providers.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/domain/usecases/get_last_callback.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/agent_detail_screen.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';
import 'package:cockpit/features/connections/presentation/widgets/agent_row.dart';
import 'package:cockpit/features/triggers/domain/usecases/get_is_workspace_owner.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';

import 'package:cockpit/l10n/app_localizations.dart';

import '../../helpers/action_fixtures.dart';
import '../../helpers/pump_app.dart';

class _MockGetLastCallback extends Mock implements GetLastCallback {}

class _MockIsOwner extends Mock implements GetIsWorkspaceOwner {}

class _FakeConnectionsController extends ConnectionsController {
  _FakeConnectionsController(this.agents);

  final List<Agent> agents;

  @override
  Future<List<Agent>> build() async => agents;
}

final List<Agent> _agents = [
  Agent(
    id: 'g1',
    name: 'Email agent',
    platform: AgentPlatform.n8n,
    callbackUrl: 'https://n8n.example.com/hook',
    lastActionAt: DateTime.now().subtract(const Duration(minutes: 4)),
  ),
  const Agent(
    id: 'g2',
    name: 'Support triage',
    platform: AgentPlatform.custom,
    status: AgentStatus.disabled,
    callbackUrl: 'https://support.example.com/hook',
  ),
];

void main() {
  group('ConnectionsScreen', () {
    Future<void> pumpConnections(
      WidgetTester tester,
      List<Agent> agents, {
      Size size = phoneSize,
      ThemeMode themeMode = ThemeMode.light,
      Locale locale = const Locale('en'),
      GetIsWorkspaceOwner? isOwner,
      List<ActionItem>? feed,
    }) =>
        pumpApp(
          tester,
          const ConnectionsScreen(),
          size: size,
          themeMode: themeMode,
          locale: locale,
          overrides: [
            connectionsControllerProvider
                .overrideWith(() => _FakeConnectionsController(agents)),
            if (isOwner != null) getIsWorkspaceOwnerProvider.overrideWithValue(isOwner),
            if (feed != null) feedOverride(feed),
          ],
        );

    _MockIsOwner role(Either<Failure, bool> answer) {
      final isOwner = _MockIsOwner();
      when(() => isOwner()).thenAnswer((_) async => answer);
      return isOwner;
    }

    group('owner-only agent management (F08)', () {
      testWidgets('approver: no Connect in the header', (tester) async {
        await pumpConnections(tester, _agents, isOwner: role(const Right(false)));

        expect(find.text('Email agent'), findsOneWidget, reason: 'approvers still see agents');
        expect(find.text('Connect'), findsNothing);
      });

      testWidgets('approver: empty state explains who connects, with no CTA', (tester) async {
        await pumpConnections(tester, const [], isOwner: role(const Right(false)));

        expect(find.text('No agents connected'), findsOneWidget);
        expect(
          find.text("Ask your workspace owner to connect an agent. You'll review its actions here."),
          findsOneWidget,
        );
        expect(find.text('Connect agent'), findsNothing);
        expect(find.text('Connect'), findsNothing);
      });

      testWidgets('approver in Hindi: owner-only copy, no CTA', (tester) async {
        await pumpConnections(
          tester,
          const [],
          locale: const Locale('hi'),
          isOwner: role(const Right(false)),
        );

        expect(
          find.text('किसी एजेंट को जोड़ने के लिए अपने वर्कस्पेस के मालिक से कहें। उसके कार्य आप यहाँ देखेंगे।'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('owner: Connect and the empty-state CTA', (tester) async {
        await pumpConnections(tester, const [], isOwner: role(const Right(true)));

        expect(find.text('Connect'), findsOneWidget);
        expect(find.text('Connect agent'), findsOneWidget);
      });

      testWidgets('role unknown (read failed): entry points stay, backend enforces', (tester) async {
        await pumpConnections(
          tester,
          const [],
          isOwner: role(const Left(NetworkFailure('offline'))),
        );

        expect(find.text('Connect'), findsOneWidget);
        expect(find.text('Connect agent'), findsOneWidget);
      });
    });

    testWidgets('lists agents with platform, activity and status',
        (tester) async {
      await pumpConnections(tester, _agents);

      expect(find.text('Connections'), findsOneWidget);
      expect(find.text('Connect'), findsOneWidget);
      expect(find.byType(AgentRow), findsNWidgets(2));
      expect(find.text('n8n · last action 4 min ago'), findsOneWidget);
      expect(find.text('Custom · paused'), findsOneWidget);
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.text('PAUSED'), findsOneWidget);
    });

    group('last action stays current (v2)', () {
      testWidgets('an action in the live feed replaces "no actions yet"', (tester) async {
        await pumpConnections(
          tester,
          [_agents.first.copyWith(lastActionAt: null)],
          feed: [pendingEmail.copyWith(agentId: 'g1', createdAt: DateTime.now())],
        );

        expect(find.text('n8n · last action just now'), findsOneWidget);
        expect(find.text('n8n · no actions yet'), findsNothing);
      });

      testWidgets('a newer feed action wins over the listed time', (tester) async {
        await pumpConnections(
          tester,
          _agents,
          feed: [pendingEmail.copyWith(agentId: 'g1', createdAt: DateTime.now())],
        );

        expect(find.text('n8n · last action just now'), findsOneWidget);
      });

      testWidgets('an older feed action does not roll the time back', (tester) async {
        await pumpConnections(
          tester,
          _agents,
          feed: [
            pendingEmail.copyWith(
              agentId: 'g1',
              createdAt: DateTime.now().subtract(const Duration(days: 3)),
            ),
          ],
        );

        expect(find.text('n8n · last action 4 min ago'), findsOneWidget);
      });

      testWidgets('without any action it still says so', (tester) async {
        await pumpConnections(tester, [_agents.first.copyWith(lastActionAt: null)], feed: const []);

        expect(find.text('n8n · no actions yet'), findsOneWidget);
      });
    });

    testWidgets('tapping an agent opens its detail', (tester) async {
      final lastCallback = _MockGetLastCallback();
      when(() => lastCallback(any())).thenAnswer((_) async => const Right(null));
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      tester.view
        ..physicalSize = phoneSize
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final router = GoRouter(
        initialLocation: RoutePaths.connections,
        routes: [
          GoRoute(
            name: RouteNames.connections,
            path: RoutePaths.connections,
            builder: (_, _) => const ConnectionsScreen(),
            routes: [
              GoRoute(
                name: RouteNames.agentDetail,
                path: RoutePaths.agentDetail,
                builder: (_, state) => AgentDetailScreen(agentId: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            connectionsControllerProvider.overrideWith(() => _FakeConnectionsController(_agents)),
            feedOverride(const []),
            getLastCallbackProvider.overrideWithValue(lastCallback),
            testActionsSupportedProvider.overrideWithValue(true),
            canManageAgentsProvider.overrideWithValue(true),
          ],
          child: MaterialApp.router(
            theme: AppTheme.buildLight(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Support triage'));
      await tester.pumpAndSettle();

      expect(find.byType(AgentDetailScreen), findsOneWidget);
      expect(find.text('PAUSED'), findsOneWidget);
      expect(find.text('https://support.example.com/hook'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/connections/agents/g2');

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.byType(AgentDetailScreen), findsNothing);
      expect(find.byType(AgentRow), findsNWidgets(2));
    });

    testWidgets('shows the empty state with a connect CTA', (tester) async {
      await pumpConnections(tester, const []);

      expect(find.text('No agents connected'), findsOneWidget);
      expect(find.text('Connect agent'), findsOneWidget);
    });

    for (final (label, themeMode, locale) in [
      ('light en', ThemeMode.light, const Locale('en')),
      ('dark hi', ThemeMode.dark, const Locale('hi')),
    ]) {
      testWidgets('lays out at 320px without overflow ($label)', (tester) async {
        await pumpConnections(
          tester,
          _agents,
          size: narrowPhoneSize,
          themeMode: themeMode,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
