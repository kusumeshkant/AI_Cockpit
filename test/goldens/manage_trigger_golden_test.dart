// Manage-trigger goldens (flag ON, workspace owner): the sheet after rotating
// the secret (status, switch, hint, URL, actions, one-time secret) in light
// and dark, English and Hindi, plus 320px; and the owner's Connections rows
// with the manage chevron at 320px.
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/configure_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/get_is_workspace_owner.dart';
import 'package:cockpit/features/triggers/domain/usecases/list_agent_triggers.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';

import '../helpers/pump_app.dart';
import '../helpers/tolerant_golden_comparator.dart';

class _MockListTriggers extends Mock implements ListAgentTriggers {}

class _MockConfigure extends Mock implements ConfigureTrigger {}

class _MockIsOwner extends Mock implements GetIsWorkspaceOwner {}

const _agents = [
  Agent(id: 'g_email', name: 'Email agent', platform: AgentPlatform.n8n, callbackUrl: 'https://x.example/1'),
  Agent(id: 'g_plain', name: 'Finance bot', platform: AgentPlatform.make, callbackUrl: 'https://x.example/2'),
  Agent(id: 'g_off', name: 'Support triage', callbackUrl: 'https://x.example/3'),
];

class _Agents extends ConnectionsController {
  @override
  Future<List<Agent>> build() async => _agents;
}

const _trigger = AgentTrigger(
  agentId: 'g_email',
  triggerUrl: 'https://n8n.example.com/webhook/cockpit-run',
  secretHint: 'abcd',
  enabled: true,
  minIntervalSecs: 30,
);

const _variants = [
  ('light_en', ThemeMode.light, Locale('en'), Size(390, 1100)),
  ('dark_en', ThemeMode.dark, Locale('en'), Size(390, 1100)),
  ('light_hi', ThemeMode.light, Locale('hi'), Size(390, 1100)),
  ('dark_hi', ThemeMode.dark, Locale('hi'), Size(390, 1100)),
  ('light_en_320', ThemeMode.light, Locale('en'), Size(320, 1100)),
  ('dark_hi_320', ThemeMode.dark, Locale('hi'), Size(320, 1100)),
];

void main() {
  setUpAll(() => useTolerantGoldens('manage_trigger_golden_test.dart'));

  late _MockListTriggers listTriggers;
  late _MockConfigure configure;
  late _MockIsOwner isOwner;

  setUp(() {
    listTriggers = _MockListTriggers();
    configure = _MockConfigure();
    isOwner = _MockIsOwner();
    when(() => listTriggers()).thenAnswer(
      (_) async => Right([
        _trigger,
        _trigger.copyWith(agentId: 'g_off', enabled: false, secretHint: 'efgh'),
      ]),
    );
    when(() => isOwner()).thenAnswer((_) async => const Right(true));
    when(() => configure(
          agentId: any(named: 'agentId'),
          triggerUrl: any(named: 'triggerUrl'),
          minIntervalSecs: any(named: 'minIntervalSecs'),
        )).thenAnswer(
      (_) async => Right(
        TriggerCredentials(
          trigger: _trigger.copyWith(secretHint: '7e2f'),
          secret: 'whtrig_rotatedsecret_0123456789_7e2f',
        ),
      ),
    );
  });

  Future<void> pump(WidgetTester tester, ThemeMode themeMode, Locale locale, Size size) => pumpApp(
        tester,
        const ConnectionsScreen(),
        themeMode: themeMode,
        locale: locale,
        size: size,
        overrides: [
          agentTriggersOverride(enabled: true),
          connectionsControllerProvider.overrideWith(_Agents.new),
          listAgentTriggersProvider.overrideWithValue(listTriggers),
          configureTriggerProvider.overrideWithValue(configure),
          getIsWorkspaceOwnerProvider.overrideWithValue(isOwner),
        ],
      );

  for (final (name, themeMode, locale, size) in _variants) {
    testWidgets('manage sheet · secret rotated ($name)', skip: skipGoldensOnCi, (tester) async {
      await pump(tester, themeMode, locale, size);
      await tester.tap(find.text('Email agent'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('manageTrigger.rotate')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('manageTrigger.confirm')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('triggers/manage_sheet_$name.png'));
    });
  }

  for (final (name, themeMode, locale) in [
    ('light_en', ThemeMode.light, const Locale('en')),
    ('dark_hi', ThemeMode.dark, const Locale('hi')),
  ]) {
    testWidgets('connections · owner chevrons at 320px ($name)', skip: skipGoldensOnCi, (tester) async {
      await pump(tester, themeMode, locale, narrowPhoneSize);

      expect(tester.takeException(), isNull);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('triggers/connections_owner_320_$name.png'));
    });
  }
}
