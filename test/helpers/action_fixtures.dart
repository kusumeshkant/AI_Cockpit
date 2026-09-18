import 'package:flutter_riverpod/misc.dart' show Override;

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/controllers/actions_feed_controller.dart';

/// Fixed clock for fixtures.
final DateTime fixtureNow = DateTime(2026, 9, 14, 9);

/// Pending email action.
final ActionItem pendingEmail = ActionItem(
  id: 'a1',
  agentId: 'g1',
  agentName: 'Email agent',
  agentPlatform: AgentPlatform.n8n,
  type: ActionTypes.email,
  title: 'Reply to Priya — refund request',
  summary: 'Send an email approving a ₹2,400 refund.',
  payload: const {
    'to': 'priya.k@example.com',
    'subject': 'Re: Refund for order #DQ-2291',
    'body': 'Hi Priya,\n\nYour refund of ₹2,400 is approved.\n\nWarmly,\nTeam DQ',
  },
  editableFields: const ['subject', 'body'],
  status: ActionStatus.pending,
  createdAt: fixtureNow,
);

/// Pending table action.
final ActionItem pendingInvoice = ActionItem(
  id: 'a2',
  agentId: 'g2',
  agentName: 'Finance',
  agentPlatform: AgentPlatform.make,
  type: ActionTypes.table,
  title: 'Post invoice ₹48,900 to Xero',
  summary: 'Vendor: Acme Cloud · Due Oct 2',
  payload: const {
    'columns': ['Field', 'Value'],
    'rows': [
      ['Vendor', 'Acme Cloud'],
      ['Amount', '₹48,900'],
    ],
  },
  status: ActionStatus.pending,
  createdAt: fixtureNow,
);

/// Already-approved action.
final ActionItem approvedLeads = ActionItem(
  id: 'a3',
  agentId: 'g3',
  agentName: 'Leads',
  agentPlatform: AgentPlatform.custom,
  type: 'crm_upsert',
  title: 'Add 2 leads to HubSpot',
  summary: 'Sent to CRM',
  payload: const {'count': 2},
  status: ActionStatus.decided,
  decision: DecisionType.approved,
  createdAt: fixtureNow,
  decidedAt: fixtureNow,
);

/// Default feed for widget tests.
final List<ActionItem> fixtureFeed = [pendingEmail, pendingInvoice, approvedLeads];

/// Feed controller that emits fixed items without get_it.
class FakeFeedController extends ActionsFeedController {
  /// Creates the fake.
  FakeFeedController(this.items);

  /// Items to emit.
  final List<ActionItem> items;

  @override
  Stream<List<ActionItem>> build() => Stream.value(items);
}

/// Overrides the feed with [items].
Override feedOverride(List<ActionItem> items) =>
    actionsFeedControllerProvider.overrideWith(() => FakeFeedController(items));
