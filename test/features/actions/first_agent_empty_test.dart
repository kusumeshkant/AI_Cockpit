// F13: an empty feed in a workspace without agents offers the next step.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/actions/presentation/screens/actions_feed_screen.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';

import '../../helpers/action_fixtures.dart';
import '../../helpers/pump_app.dart';

class _Agents extends ConnectionsController {
  _Agents(this.agents);

  final List<Agent> agents;

  @override
  Future<List<Agent>> build() async => agents;
}

const _oneAgent = [
  Agent(id: 'g1', name: 'Niko', platform: AgentPlatform.n8n, callbackUrl: 'https://x.example/cb'),
];

final Finder _connect = find.byKey(const ValueKey('feed_connect_first_agent'));

Widget _textScale(double scale, Widget child) => Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
        child: child,
      ),
    );

void main() {
  List<Override> overrides({required List<Agent> agents, required bool owner}) => [
        feedOverride(const []),
        connectionsControllerProvider.overrideWith(() => _Agents(agents)),
        canManageAgentsProvider.overrideWithValue(owner),
      ];

  testWidgets('owner with no agents: steps and a Connect button', (tester) async {
    await pumpApp(tester, const ActionsFeedScreen(), overrides: overrides(agents: const [], owner: true));

    expect(find.text('Connect your first agent'), findsOneWidget);
    expect(find.textContaining('It sends each action here'), findsOneWidget);
    expect(_connect, findsOneWidget);
    expect(find.text('All clear'), findsNothing);
  });

  testWidgets('approver with no agents: asked to contact the owner, no button', (tester) async {
    await pumpApp(tester, const ActionsFeedScreen(), overrides: overrides(agents: const [], owner: false));

    expect(find.textContaining('Ask your workspace owner'), findsOneWidget);
    expect(_connect, findsNothing);
  });

  testWidgets('agents but nothing pending: All clear as before', (tester) async {
    await pumpApp(tester, const ActionsFeedScreen(), overrides: overrides(agents: _oneAgent, owner: true));

    expect(find.text('All clear'), findsOneWidget);
    expect(_connect, findsNothing);
  });

  for (final (label, locale) in const [('en', Locale('en')), ('hi', Locale('hi'))]) {
    testWidgets('fits 320dp at 1.5x text ($label)', (tester) async {
      await pumpApp(
        tester,
        _textScale(1.5, const ActionsFeedScreen()),
        size: narrowPhoneSize,
        locale: locale,
        overrides: overrides(agents: const [], owner: true),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('is translated (hi)', (tester) async {
    await pumpApp(
      tester,
      const ActionsFeedScreen(),
      locale: const Locale('hi'),
      overrides: overrides(agents: const [], owner: false),
    );
    expect(find.text('अपना पहला एजेंट जोड़ें'), findsOneWidget);
  });
}
