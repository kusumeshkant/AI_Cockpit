// Feature: actions · Layer: data
// In-memory demo actions (AppEnvironments.demo), seeded with the items shown
// in technical/design/Main.dc.html. Decisions update the in-memory list so the
// review flow can be exercised end to end without a backend.
import 'dart:async';

import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/actions/data/datasources/actions_remote_ds.dart';
import 'package:cockpit/features/actions/data/models/action_item_dto.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';

/// Demo implementation of [ActionsRemoteDataSource].
@LazySingleton(as: ActionsRemoteDataSource, env: [AppEnvironments.demo])
class ActionsDemoDataSource implements ActionsRemoteDataSource {
  /// Creates the datasource with seed data relative to now.
  ActionsDemoDataSource() : _items = _seed(DateTime.now());

  final List<ActionItemDto> _items;
  final StreamController<List<ActionItemDto>> _changes =
      StreamController<List<ActionItemDto>>.broadcast();

  static List<ActionItemDto> _seed(DateTime now) => [
        ActionItemDto(
          id: 'act_priya_refund',
          agentId: 'agt_email',
          agentName: 'Email agent',
          agentPlatform: 'n8n',
          type: 'email',
          title: 'Reply to Priya — refund request',
          summary:
              'Send an email approving a ₹2,400 refund and apologising for the delay.',
          payload: const {
            'to': 'priya.k@example.com',
            'subject': 'Re: Refund for order #DQ-2291',
            'body': 'Hi Priya,\n\nThanks for reaching out and apologies for the '
                "delay. I've approved your refund of ₹2,400 — it'll land in "
                'your account within 3–5 business days.\n\nWarmly,\nTeam DQ',
          },
          editableFields: const ['subject', 'body'],
          status: 'pending',
          createdAt: now.subtract(const Duration(minutes: 4)),
        ),
        ActionItemDto(
          id: 'act_xero_invoice',
          agentId: 'agt_finance',
          agentName: 'Finance',
          agentPlatform: 'make',
          type: 'table',
          title: 'Post invoice ₹48,900 to Xero',
          summary: 'Vendor: Acme Cloud · Due Oct 2 · GST 18%',
          payload: const {
            'columns': ['Field', 'Value'],
            'rows': [
              ['Vendor', 'Acme Cloud'],
              ['Amount', '₹48,900'],
              ['GST', '18%'],
              ['Due', 'Oct 2'],
            ],
          },
          status: 'pending',
          createdAt: now.subtract(const Duration(minutes: 38)),
        ),
        ActionItemDto(
          id: 'act_ticket_4821',
          agentId: 'agt_support',
          agentName: 'Support',
          agentPlatform: 'custom',
          type: 'escalation',
          title: 'Escalate ticket #4821 to human',
          summary: 'Customer flagged “urgent” twice · sentiment negative',
          payload: const {
            'ticket': 4821,
            'flags': ['urgent', 'urgent'],
            'sentiment': 'negative',
            'assign_to': 'tier-2',
          },
          status: 'pending',
          createdAt: now.subtract(const Duration(hours: 1)),
        ),
        ActionItemDto(
          id: 'act_hubspot_leads',
          agentId: 'agt_leads',
          agentName: 'Leads',
          agentPlatform: 'custom',
          type: 'table',
          title: 'Add 2 leads to HubSpot',
          summary: 'Sent to CRM',
          payload: const {
            'columns': ['Name', 'Company'],
            'rows': [
              ['Arjun Mehta', 'Skyline Realty'],
              ['Sara Iyer', 'Bloom Clinics'],
            ],
          },
          status: 'decided',
          decision: 'approved',
          createdAt: now.subtract(const Duration(hours: 2)),
          decidedAt: now.subtract(const Duration(hours: 1, minutes: 30)),
        ),
      ];

  @override
  Stream<List<ActionItemDto>> watchPending() async* {
    yield List.unmodifiable(_items);
    yield* _changes.stream;
  }

  @override
  Future<List<ActionItemDto>> fetchPending() async => List.unmodifiable(_items);

  @override
  Future<ActionItemDto> getById(String id) async =>
      _items.firstWhere((item) => item.id == id);

  @override
  Future<void> postDecision(ActionDecision decision) async {
    final index = _items.indexWhere((item) => item.id == decision.actionId);
    if (index < 0 || _items[index].status != 'pending') return;
    final current = _items[index];
    _items[index] = current.copyWith(
      status: 'decided',
      decision: DecisionWire.encode(decision.type),
      decidedAt: DateTime.now(),
      payload: {...current.payload, ...?decision.editedPayload},
    );
    _changes.add(List.unmodifiable(_items));
  }
}
