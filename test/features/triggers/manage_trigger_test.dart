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
import 'package:cockpit/features/connections/presentation/widgets/agent_row.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/configure_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/get_is_workspace_owner.dart';
import 'package:cockpit/features/triggers/domain/usecases/list_agent_triggers.dart';
import 'package:cockpit/features/triggers/domain/usecases/run_agent.dart';
import 'package:cockpit/features/triggers/domain/usecases/set_trigger_enabled.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';
import 'package:cockpit/features/triggers/presentation/widgets/manage_trigger_sheet.dart';

import '../../helpers/pump_app.dart';

class _Agents extends ConnectionsController {
  @override
  Future<List<Agent>> build() async => _agents;
}

class _MockListTriggers extends Mock implements ListAgentTriggers {}

class _MockRunAgent extends Mock implements RunAgent {}

class _MockConfigure extends Mock implements ConfigureTrigger {}

class _MockSetEnabled extends Mock implements SetTriggerEnabled {}

class _MockIsOwner extends Mock implements GetIsWorkspaceOwner {}

const _agents = [
  Agent(id: 'g_email', name: 'Email agent', platform: AgentPlatform.n8n, callbackUrl: 'https://x.example/1'),
  Agent(id: 'g_plain', name: 'Finance bot', platform: AgentPlatform.make, callbackUrl: 'https://x.example/2'),
];

const _emailTrigger = AgentTrigger(
  agentId: 'g_email',
  triggerUrl: 'https://n8n.example.com/start',
  secretHint: 'abcd',
  enabled: true,
  minIntervalSecs: 45,
);

const _newSecret = 'whtrig_rotatedsecret_0123456789_7e2f';

TriggerCredentials _credentials(String agentId, String url) => TriggerCredentials(
      trigger: AgentTrigger(
        agentId: agentId,
        triggerUrl: url,
        secretHint: '7e2f',
        enabled: true,
        minIntervalSecs: 45,
      ),
      secret: _newSecret,
    );

void main() {
  late _MockListTriggers listTriggers;
  late _MockRunAgent runAgent;
  late _MockConfigure configure;
  late _MockSetEnabled setEnabled;
  late _MockIsOwner isOwner;

  setUp(() {
    listTriggers = _MockListTriggers();
    runAgent = _MockRunAgent();
    configure = _MockConfigure();
    setEnabled = _MockSetEnabled();
    isOwner = _MockIsOwner();
    when(() => listTriggers()).thenAnswer((_) async => const Right([_emailTrigger]));
    when(() => isOwner()).thenAnswer((_) async => const Right(true));
    when(() => configure(
          agentId: any(named: 'agentId'),
          triggerUrl: any(named: 'triggerUrl'),
          minIntervalSecs: any(named: 'minIntervalSecs'),
        )).thenAnswer((invocation) async {
      final agentId = invocation.namedArguments[#agentId] as String;
      final url = invocation.namedArguments[#triggerUrl] as String;
      return Right(_credentials(agentId, url));
    });
    when(() => setEnabled(agentId: any(named: 'agentId'), enabled: any(named: 'enabled')))
        .thenAnswer((invocation) async => Right(
              _emailTrigger.copyWith(enabled: invocation.namedArguments[#enabled] as bool),
            ));
  });

  Future<void> pumpConnections(
    WidgetTester tester, {
    bool flag = true,
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
          connectionsControllerProvider.overrideWith(_Agents.new),
          listAgentTriggersProvider.overrideWithValue(listTriggers),
          runAgentUseCaseProvider.overrideWithValue(runAgent),
          configureTriggerProvider.overrideWithValue(configure),
          setTriggerEnabledProvider.overrideWithValue(setEnabled),
          getIsWorkspaceOwnerProvider.overrideWithValue(isOwner),
        ],
      );

  Iterable<AgentRow> rows(WidgetTester tester) => tester.widgetList<AgentRow>(find.byType(AgentRow));
  Finder chevron(String agentId) => find.byKey(Key('manage.$agentId'));
  Finder runButton(String agentId) => find.byKey(Key('run.$agentId'));

  Future<void> openSheet(WidgetTester tester, String name) async {
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
    expect(find.byType(ManageTriggerSheet), findsOneWidget);
  }

  Future<void> closeSheet(WidgetTester tester) async {
    Navigator.of(tester.element(find.byType(ManageTriggerSheet))).pop();
    await tester.pumpAndSettle();
  }

  Finder urlField() => find.descendant(
        of: find.byKey(const Key('manageTrigger.url')),
        matching: find.byType(TextField),
      );

  void verifyNoConfigure() => verifyNever(() => configure(
        agentId: any(named: 'agentId'),
        triggerUrl: any(named: 'triggerUrl'),
        minIntervalSecs: any(named: 'minIntervalSecs'),
      ));

  group('visibility', () {
    testWidgets('flag OFF: no chevron, rows not tappable, role never read', (tester) async {
      await pumpConnections(tester, flag: false);

      expect(chevron('g_email'), findsNothing);
      expect(rows(tester).every((row) => row.onTap == null), isTrue);
      verifyNever(() => isOwner());
    });

    testWidgets('non-owner: no chevron and onTap is null', (tester) async {
      when(() => isOwner()).thenAnswer((_) async => const Right(false));
      await pumpConnections(tester);

      expect(runButton('g_email'), findsOneWidget, reason: 'non-owners can still Run');
      expect(chevron('g_email'), findsNothing);
      expect(chevron('g_plain'), findsNothing);
      expect(rows(tester).every((row) => row.onTap == null), isTrue);
    });

    testWidgets('role fetch fails: treated as approver, sheet never opens', (tester) async {
      when(() => isOwner()).thenAnswer((_) async => const Left(NetworkFailure('offline')));
      await pumpConnections(tester);

      expect(rows(tester).every((row) => row.onTap == null), isTrue);
      await tester.tap(find.text('Finance bot'));
      await tester.pumpAndSettle();
      expect(find.byType(ManageTriggerSheet), findsNothing);
    });

    testWidgets('owner + flag ON: chevron on every row (with and without a trigger)', (tester) async {
      await pumpConnections(tester);

      expect(chevron('g_email'), findsOneWidget);
      expect(chevron('g_plain'), findsOneWidget);
      expect(rows(tester).every((row) => row.onTap != null), isTrue);
      expect(tester.getSize(find.byType(AgentRow).first).height, greaterThanOrEqualTo(44));
    });
  });

  group('enable / disable', () {
    testWidgets('toggle off hides Run at once; toggle on brings it back', (tester) async {
      await pumpConnections(tester);
      await openSheet(tester, 'Email agent');
      expect(find.text('ON'), findsOneWidget);
      expect(find.text('Secret ends in abcd'), findsOneWidget);

      await tester.tap(find.byKey(const Key('manageTrigger.enabled')));
      await tester.pumpAndSettle();
      verify(() => setEnabled(agentId: 'g_email', enabled: false)).called(1);
      expect(runButton('g_email'), findsNothing);
      expect(find.text('OFF'), findsOneWidget);

      await tester.tap(find.byKey(const Key('manageTrigger.enabled')));
      await tester.pumpAndSettle();
      verify(() => setEnabled(agentId: 'g_email', enabled: true)).called(1);
      expect(runButton('g_email'), findsOneWidget);
      verify(() => listTriggers()).called(1); // no refetch needed
    });

    testWidgets('a failed toggle keeps the state and shows the error', (tester) async {
      when(() => setEnabled(agentId: any(named: 'agentId'), enabled: any(named: 'enabled')))
          .thenAnswer((_) async => const Left(NetworkFailure('offline')));
      await pumpConnections(tester);
      await openSheet(tester, 'Email agent');

      await tester.tap(find.byKey(const Key('manageTrigger.enabled')));
      await tester.pumpAndSettle();
      expect(find.text('You appear to be offline. Check your connection.'), findsOneWidget);
      expect(runButton('g_email'), findsOneWidget);
      expect(find.text('ON'), findsOneWidget);
    });
  });

  group('URL', () {
    for (final (label, value) in [
      ('empty', ''),
      ('garbage', 'not a url'),
      ('http', 'http://n8n.example.com/start'),
    ]) {
      testWidgets('$label URL is rejected', (tester) async {
        await pumpConnections(tester);
        await openSheet(tester, 'Finance bot');
        expect(find.text('NOT SET UP'), findsOneWidget);

        await tester.enterText(urlField(), value);
        await tester.tap(find.byKey(const Key('manageTrigger.save')));
        await tester.pumpAndSettle();

        expect(find.text('Enter a valid https:// URL.'), findsOneWidget);
        verifyNoConfigure();
      });
    }

    testWidgets('new trigger: valid https saves without a confirm, secret shown once', (tester) async {
      await pumpConnections(tester);
      await openSheet(tester, 'Finance bot');

      await tester.enterText(urlField(), ' https://make.example.com/run ');
      await tester.tap(find.byKey(const Key('manageTrigger.save')));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      verify(() => configure(agentId: 'g_plain', triggerUrl: 'https://make.example.com/run')).called(1);
      expect(find.text('Trigger secret — shown once, copy it now'), findsOneWidget);
      expect(find.text('whtrig_••••••••••••7e2f'), findsOneWidget);
      expect(find.byTooltip('Copy'), findsOneWidget);
      expect(find.textContaining('rotatedsecret'), findsNothing, reason: 'never the plaintext');
      expect(runButton('g_plain'), findsOneWidget, reason: 'the new trigger is enabled');
    });

    testWidgets('changing an existing URL asks first (it issues a new secret)', (tester) async {
      await pumpConnections(tester);
      await openSheet(tester, 'Email agent');
      expect(tester.widget<TextField>(urlField()).controller?.text, 'https://n8n.example.com/start');

      await tester.enterText(urlField(), 'https://n8n.example.com/v2');
      await tester.tap(find.byKey(const Key('manageTrigger.save')));
      await tester.pumpAndSettle();
      expect(find.text('Issue a new trigger secret?'), findsOneWidget);

      await tester.tap(find.byKey(const Key('manageTrigger.confirm')));
      await tester.pumpAndSettle();
      verify(() => configure(agentId: 'g_email', triggerUrl: 'https://n8n.example.com/v2', minIntervalSecs: 45))
          .called(1);
    });
  });

  group('rotate', () {
    testWidgets('cancel does nothing', (tester) async {
      await pumpConnections(tester);
      await openSheet(tester, 'Email agent');

      await tester.tap(find.byKey(const Key('manageTrigger.rotate')));
      await tester.pumpAndSettle();
      expect(find.text('The current secret stops working immediately. '
          "Update your agent's verify step with the new secret."), findsOneWidget);
      await tester.tap(find.byKey(const Key('manageTrigger.cancel')));
      await tester.pumpAndSettle();

      verifyNoConfigure();
      expect(find.text('Trigger secret — shown once, copy it now'), findsNothing);
    });

    testWidgets('confirm reuses URL + interval, shows the NEW secret once, not after reopening',
        (tester) async {
      await pumpConnections(tester);
      await openSheet(tester, 'Email agent');

      await tester.tap(find.byKey(const Key('manageTrigger.rotate')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('manageTrigger.confirm')));
      await tester.pumpAndSettle();

      verify(() => configure(
            agentId: 'g_email',
            triggerUrl: 'https://n8n.example.com/start',
            minIntervalSecs: 45,
          )).called(1);
      expect(find.text('Trigger secret — shown once, copy it now'), findsOneWidget);
      expect(find.text('whtrig_••••••••••••7e2f'), findsOneWidget);
      expect(find.text('Secret ends in 7e2f'), findsOneWidget);

      await closeSheet(tester);
      await openSheet(tester, 'Email agent');
      expect(find.text('Trigger secret — shown once, copy it now'), findsNothing);
      expect(find.text('whtrig_••••••••••••7e2f'), findsNothing);
      expect(find.text('Secret ends in 7e2f'), findsOneWidget);
    });

    testWidgets('feature_disabled shows the message, no secret, no crash', (tester) async {
      when(() => configure(
            agentId: any(named: 'agentId'),
            triggerUrl: any(named: 'triggerUrl'),
            minIntervalSecs: any(named: 'minIntervalSecs'),
          )).thenAnswer((_) async => const Left(FeatureDisabledFailure()));
      await pumpConnections(tester);
      await openSheet(tester, 'Email agent');

      await tester.tap(find.byKey(const Key('manageTrigger.rotate')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('manageTrigger.confirm')));
      await tester.pumpAndSettle();

      expect(find.text("This feature isn't available yet."), findsOneWidget);
      expect(find.text('Trigger secret — shown once, copy it now'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('Run error text', () {
    for (final (label, Either<Failure, TriggerRun> result, message) in [
      ('feature_disabled', const Left(FeatureDisabledFailure()), "This feature isn't available yet."),
      ('network (offline / client timeout)', const Left(NetworkFailure('timeout')), 'No internet connection'),
      (
        'agent timed out',
        const Right(TriggerRun(runId: 'r1', delivered: false, detail: 'timeout')),
        "Agent didn't accept the run",
      ),
      (
        'agent returned 500',
        const Right(TriggerRun(runId: 'r2', delivered: false, detail: 'http_500')),
        "Agent didn't accept the run",
      ),
    ]) {
      testWidgets(label, (tester) async {
        when(() => runAgent('g_email')).thenAnswer((_) async => result);
        await pumpConnections(tester);

        await tester.tap(runButton('g_email'));
        await tester.pumpAndSettle();
        expect(find.text(message), findsOneWidget);
        expect(find.byTooltip('Retry'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('320px', () {
    for (final (label, locale) in [('en', const Locale('en')), ('hi', const Locale('hi'))]) {
      testWidgets('owner rows and the sheet fit without overflow ($label)', (tester) async {
        await pumpConnections(tester, locale: locale, size: narrowPhoneSize);
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Email agent'));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('manageTrigger.rotate')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('manageTrigger.confirm')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });
}
