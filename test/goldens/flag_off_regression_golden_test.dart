// Regression goldens: core screens with feature flags at their defaults (OFF).
// Uses only app APIs that predate Agent Triggers. The committed images were
// generated from `main` (before the feature); with the flags off this branch
// renders them byte-identically.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/controllers/action_detail_controller.dart';
import 'package:cockpit/features/actions/presentation/screens/action_detail_screen.dart';
import 'package:cockpit/features/actions/presentation/screens/actions_feed_screen.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';
import 'package:cockpit/features/audit/presentation/controllers/audit_controller.dart';
import 'package:cockpit/features/audit/presentation/screens/audit_screen.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/screens/connections_screen.dart';

import '../helpers/action_fixtures.dart';
import '../helpers/pump_app.dart';
import '../helpers/tolerant_golden_comparator.dart';

class _FakeConnections extends ConnectionsController {
  @override
  Future<List<Agent>> build() async => const [
        Agent(id: 'g1', name: 'Email agent', platform: AgentPlatform.n8n, callbackUrl: 'https://x.example/1'),
        Agent(
          id: 'g2',
          name: 'Support triage',
          status: AgentStatus.disabled,
          callbackUrl: 'https://x.example/2',
        ),
      ];
}

class _FakeAudit extends AuditController {
  @override
  Future<List<AuditEntry>> build() async => [
        AuditEntry(
          id: '1',
          actionId: 'a1',
          event: AuditEvent.decisionMade,
          createdAt: DateTime(2026, 8, 3, 9, 30),
          actionTitle: 'Reply to Priya',
          agentName: 'Email agent',
          agentPlatform: AgentPlatform.n8n,
          decision: AuditDecisions.approvedWithEdits,
        ),
        AuditEntry(
          id: '2',
          actionId: 'a2',
          event: AuditEvent.decisionMade,
          createdAt: DateTime(2026, 8, 2, 16),
          actionTitle: 'Delete 40 records',
          agentName: 'Data bot',
          agentPlatform: AgentPlatform.make,
          decision: AuditDecisions.rejected,
          reason: 'too risky',
        ),
      ];
}

class _FakeDetail extends ActionDetailController {
  _FakeDetail(this.item) : super(item.id);

  final ActionItem item;

  @override
  Future<ActionItem> build() async => item;
}

void main() {
  setUpAll(() => useTolerantGoldens('flag_off_regression_golden_test.dart'));

  testWidgets('feed (flags off)', (tester) async {
    await pumpApp(tester, const ActionsFeedScreen(), overrides: [feedOverride(fixtureFeed)]);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('regression/feed.png'));
  });

  testWidgets('action detail / approve bar (flags off)', (tester) async {
    await pumpApp(
      tester,
      ActionDetailScreen(actionId: pendingEmail.id),
      overrides: [actionDetailControllerProvider(pendingEmail.id).overrideWith(() => _FakeDetail(pendingEmail))],
    );
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('regression/action_detail.png'));
  });

  testWidgets('connections (flags off)', (tester) async {
    await pumpApp(
      tester,
      const ConnectionsScreen(),
      overrides: [connectionsControllerProvider.overrideWith(_FakeConnections.new)],
    );
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('regression/connections.png'));
  });

  testWidgets('audit (flags off)', (tester) async {
    await pumpApp(
      tester,
      const AuditScreen(),
      overrides: [auditControllerProvider.overrideWith(_FakeAudit.new)],
    );
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('regression/audit.png'));
  });
}
