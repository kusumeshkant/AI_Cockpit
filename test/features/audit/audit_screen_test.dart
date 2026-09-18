import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';
import 'package:cockpit/features/audit/presentation/controllers/audit_controller.dart';
import 'package:cockpit/features/audit/presentation/screens/audit_screen.dart';
import 'package:cockpit/features/audit/presentation/widgets/audit_timeline_tile.dart';

import '../../helpers/pump_app.dart';

class _FakeAuditController extends AuditController {
  _FakeAuditController(this.entries);

  final List<AuditEntry> entries;

  @override
  Future<List<AuditEntry>> build() async => entries;
}

final DateTime _now = DateTime.now();

final List<AuditEntry> _entries = [
  AuditEntry(
    id: '2',
    actionId: 'a1',
    event: AuditEvent.decisionMade,
    decision: AuditDecisions.approvedWithEdits,
    actionTitle: 'Reply to Priya',
    agentName: 'Email agent',
    agentPlatform: AgentPlatform.n8n,
    createdAt: _now,
  ),
  AuditEntry(
    id: '1',
    actionId: 'a2',
    event: AuditEvent.decisionMade,
    decision: AuditDecisions.rejected,
    actionTitle: 'Delete 40 records',
    agentName: 'Data bot',
    agentPlatform: AgentPlatform.make,
    reason: 'too risky',
    createdAt: _now.subtract(const Duration(days: 1)),
  ),
];

void main() {
  group('AuditScreen', () {
    Future<void> pumpAudit(
      WidgetTester tester, {
      Size size = phoneSize,
      ThemeMode themeMode = ThemeMode.light,
      Locale locale = const Locale('en'),
    }) =>
        pumpApp(
          tester,
          const AuditScreen(),
          size: size,
          themeMode: themeMode,
          locale: locale,
          overrides: [
            auditControllerProvider.overrideWith(() => _FakeAuditController(_entries)),
          ],
        );

    testWidgets('renders the decision timeline with notes', (tester) async {
      await pumpAudit(tester);

      expect(find.text('Audit log'), findsOneWidget);
      expect(find.byType(AuditTimelineTile), findsNWidgets(2));
      expect(find.text('Approved · Reply to Priya'), findsOneWidget);
      expect(find.text('n8n · Email agent · edited before approve'), findsOneWidget);
      expect(find.text('Rejected · Delete 40 records'), findsOneWidget);
      expect(find.text('Make · Data bot · note: “too risky”'), findsOneWidget);
      expect(find.text('Yesterday'), findsOneWidget);
    });

    testWidgets('filters by outcome', (tester) async {
      await pumpAudit(tester);

      await tester.tap(find.text('Rejected'));
      await tester.pumpAndSettle();
      expect(find.byType(AuditTimelineTile), findsOneWidget);
      expect(find.text('Rejected · Delete 40 records'), findsOneWidget);

      await tester.tap(find.text('Approved'));
      await tester.pumpAndSettle();
      expect(find.text('Approved · Reply to Priya'), findsOneWidget);
      expect(find.byType(AuditTimelineTile), findsOneWidget);
    });

    for (final (label, themeMode, locale) in [
      ('light en', ThemeMode.light, const Locale('en')),
      ('dark hi', ThemeMode.dark, const Locale('hi')),
    ]) {
      testWidgets('lays out at 320px without overflow ($label)', (tester) async {
        await pumpAudit(
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
