import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';
import 'package:cockpit/features/audit/domain/usecases/get_audit_entries.dart';
import 'package:cockpit/features/audit/presentation/controllers/audit_controller.dart';
import 'package:cockpit/features/audit/presentation/widgets/audit_timeline_tile.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';

import '../../helpers/pump_app.dart';

class _MockGetAuditEntries extends Mock implements GetAuditEntries {}

class _SignedIn extends AuthController {
  @override
  Stream<AuthUser?> build() => Stream.value(const AuthUser(id: 'u1', email: 'u@test.dev'));
}

final _now = DateTime.now();

final _decision = AuditEntry(
  id: '1',
  actionId: 'a1',
  event: AuditEvent.decisionMade,
  createdAt: _now.subtract(const Duration(hours: 1)),
  actionTitle: 'Reply to Priya',
  decision: AuditDecisions.approved,
);

final _fired = AuditEntry(
  id: '2',
  agentId: 'g1',
  event: AuditEvent.triggerFired,
  createdAt: _now.subtract(const Duration(minutes: 5)),
  agentName: 'Email agent',
  agentPlatform: AgentPlatform.n8n,
);

final _failed = AuditEntry(
  id: '3',
  agentId: 'g1',
  event: AuditEvent.triggerFailed,
  createdAt: _now.subtract(const Duration(minutes: 30)),
  agentName: 'Email agent',
  agentPlatform: AgentPlatform.n8n,
);

void main() {
  group('AuditController', () {
    late _MockGetAuditEntries getEntries;

    setUp(() {
      getEntries = _MockGetAuditEntries();
      getIt.registerSingleton<GetAuditEntries>(getEntries);
      when(() => getEntries(includeTriggerEvents: any(named: 'includeTriggerEvents')))
          .thenAnswer((_) async => Right([_fired, _decision, _failed]));
    });

    tearDown(getIt.reset);

    Future<ProviderContainer> load({required bool flag}) async {
      final container = ProviderContainer(
        overrides: [
          agentTriggersOverride(enabled: flag),
          authControllerProvider.overrideWith(_SignedIn.new),
        ],
      );
      addTearDown(container.dispose);
      await container.read(auditControllerProvider.future);
      return container;
    }

    test('flag OFF: decisions only, trigger events not requested', () async {
      final container = await load(flag: false);
      verify(() => getEntries(includeTriggerEvents: false)).called(1);
      expect(container.read(auditControllerProvider).value, [_decision]);
    });

    test('flag ON: trigger entries included; Approved filter stays decisions-only', () async {
      final container = await load(flag: true);
      verify(() => getEntries(includeTriggerEvents: true)).called(1);
      expect(container.read(auditControllerProvider).value, [_fired, _decision, _failed]);

      container.read(auditFilterProvider.notifier).choose(AuditFilter.approved);
      expect(container.read(filteredAuditEntriesProvider).value, [_decision]);
      container.read(auditFilterProvider.notifier).choose(AuditFilter.rejected);
      expect(container.read(filteredAuditEntriesProvider).value, isEmpty);
    });
  });

  group('AuditTimelineTile', () {
    Color dotColor(WidgetTester tester) => (tester
            .widget<DecoratedBox>(find.descendant(of: find.byType(AuditTimelineTile), matching: find.byType(DecoratedBox)).first)
            .decoration as BoxDecoration)
        .color!;

    testWidgets('trigger_fired: "Agent run started", accent dot, agent source', (tester) async {
      await pumpApp(tester, AuditTimelineTile(entry: _fired, isLast: true));
      expect(find.text('Agent run started'), findsOneWidget);
      expect(find.text('n8n · Email agent'), findsOneWidget);
      final context = tester.element(find.byType(AuditTimelineTile));
      expect(dotColor(tester), context.colors.accent);
    });

    testWidgets('trigger_failed: "Run failed", stop dot', (tester) async {
      await pumpApp(tester, AuditTimelineTile(entry: _failed, isLast: true));
      expect(find.text('Run failed'), findsOneWidget);
      final context = tester.element(find.byType(AuditTimelineTile));
      expect(dotColor(tester), context.colors.stop);
    });

    testWidgets('decision entries render as before', (tester) async {
      await pumpApp(tester, AuditTimelineTile(entry: _decision, isLast: true));
      expect(find.text('Approved · Reply to Priya'), findsOneWidget);
      final context = tester.element(find.byType(AuditTimelineTile));
      expect(dotColor(tester), context.colors.go);
    });

    testWidgets('Hindi trigger labels', (tester) async {
      await pumpApp(tester, AuditTimelineTile(entry: _fired, isLast: true), locale: const Locale('hi'));
      expect(find.text('एजेंट चलाना शुरू हुआ'), findsOneWidget);
    });
  });
}
