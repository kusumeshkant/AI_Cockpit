import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';
import 'package:cockpit/features/connections/presentation/widgets/agent_row.dart';

import '../../helpers/pump_app.dart';

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
          ],
        );

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
