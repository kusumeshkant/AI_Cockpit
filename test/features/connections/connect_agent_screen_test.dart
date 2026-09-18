import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connect_agent_screen.dart';
import 'package:cockpit/features/connections/presentation/widgets/credentials_panel.dart';

import '../../helpers/pump_app.dart';

class _FakeConnectionsController extends ConnectionsController {
  final List<(String, String, AgentPlatform)> created = [];
  final List<String> tests = [];

  @override
  Future<List<Agent>> build() async => const [];

  @override
  Future<Either<Failure, AgentCredentials>> createAgent({
    required String name,
    required String callbackUrl,
    required AgentPlatform platform,
  }) async {
    created.add((name, callbackUrl, platform));
    return Right(
      AgentCredentials(
        agent: Agent(
          id: 'agt_9fk2',
          name: name,
          callbackUrl: callbackUrl,
          platform: platform,
        ),
        inboundUrl: 'https://api.cockpit.app/v1/in/agt_9fk2',
        inboundSecret: 'whsec_0123456789abcdef3a9f',
      ),
    );
  }

  @override
  Future<Failure?> sendTestAction(String agentId) async {
    tests.add(agentId);
    return null;
  }
}

void main() {
  group('ConnectAgentScreen', () {
    late _FakeConnectionsController controller;

    setUp(() => controller = _FakeConnectionsController());

    Future<void> pumpConnect(
      WidgetTester tester, {
      Size size = phoneSize,
      ThemeMode themeMode = ThemeMode.light,
      Locale locale = const Locale('en'),
      bool received = false,
    }) =>
        pumpApp(
          tester,
          const ConnectAgentScreen(),
          size: size,
          themeMode: themeMode,
          locale: locale,
          overrides: [
            connectionsControllerProvider.overrideWith(() => controller),
            agentHasActionsProvider.overrideWith((ref, agentId) => received),
          ],
        );

    Future<void> fillAndCreate(WidgetTester tester) async {
      await tester.enterText(find.byType(TextField).at(0), 'Email agent');
      await tester.enterText(
        find.byType(TextField).at(1),
        'https://n8n.example.com/hook',
      );
      await tester.tap(find.text('Make'));
      await tester.tap(find.text('Create connection'));
      await tester.pumpAndSettle();
    }

    testWidgets('validates name and https callback URL', (tester) async {
      await pumpConnect(tester);

      await tester.enterText(find.byType(TextField).at(1), 'http://insecure');
      await tester.tap(find.text('Create connection'));
      await tester.pump();

      expect(find.text('Enter a name (1–60 characters).'), findsOneWidget);
      expect(find.text('Enter a valid https:// URL.'), findsOneWidget);
      expect(controller.created, isEmpty);
    });

    testWidgets('creates the agent and shows credentials once', (tester) async {
      await pumpConnect(tester);
      await fillAndCreate(tester);

      expect(
        controller.created.single,
        ('Email agent', 'https://n8n.example.com/hook', AgentPlatform.make),
      );
      expect(find.byType(CredentialsPanel), findsOneWidget);
      expect(find.text('Shown once — copy it now'), findsOneWidget);
      expect(find.text('api.cockpit.app/v1/in/agt_9fk2'), findsOneWidget);
      expect(find.text('whsec_••••••••••••3a9f'), findsOneWidget);
      expect(find.textContaining('0123456789abcdef'), findsNothing);
      expect(
        find.text('Waiting for your first test action from Make…'),
        findsOneWidget,
      );
    });

    testWidgets('sends a test action after creation', (tester) async {
      await pumpConnect(tester);
      await fillAndCreate(tester);

      await tester.tap(find.text('Send a test action'));
      await tester.pumpAndSettle();

      expect(controller.tests, ['agt_9fk2']);
      expect(find.text('Test action sent — check your Actions feed.'), findsOneWidget);
    });

    testWidgets('confirms once the first action from the agent arrives', (tester) async {
      await pumpConnect(tester, received: true);
      await fillAndCreate(tester);

      expect(
        find.text('First action received from Make — check your Actions feed.'),
        findsOneWidget,
      );
      expect(find.textContaining('Waiting for your first'), findsNothing);
    });

    test('maskSecret keeps prefix and last four characters', () {
      expect(
        CredentialsPanel.maskSecret('whsec_abcdefgh1234'),
        'whsec_••••••••••••1234',
      );
    });

    for (final (label, themeMode, locale) in [
      ('light en', ThemeMode.light, const Locale('en')),
      ('dark hi', ThemeMode.dark, const Locale('hi')),
    ]) {
      testWidgets('lays out at 320px without overflow ($label)', (tester) async {
        await pumpConnect(
          tester,
          size: narrowPhoneSize,
          themeMode: themeMode,
          locale: locale,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
