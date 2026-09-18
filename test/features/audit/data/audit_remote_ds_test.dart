import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/audit/data/datasources/audit_remote_ds.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';

import '../../../helpers/live_fakes.dart';

void main() {
  late List<Recorded> requests;
  late SupabaseClient client;

  setUp(() {
    requests = [];
    client = fakeSupabase(
      (_) => jsonResponse([
        {
          'id': 42,
          'action_id': 'a1',
          'event': 'decision_made',
          'decision': 'approved_with_edits',
          'reason': null,
          'edited_payload': {'subject': 'Re: Hi'},
          'created_at': '2026-09-15T07:04:00Z',
          'action': {
            'title': 'Reply to Priya',
            'agent_id': 'g1',
            'agent': {'name': 'Email agent', 'platform': 'n8n'},
          },
        },
      ]),
      requests,
    );
  });

  tearDown(() => client.dispose());

  test('reads decision events with action title and agent joined', () async {
    final dtos = await AuditRemoteDataSourceImpl(client).fetchEntries(offset: 50, limit: 50);

    final uri = requests.single.url;
    expect(uri.path, '/rest/v1/audit_entry');
    expect(uri.queryParameters['event'], 'eq.decision_made');
    expect(uri.queryParameters['select'], contains('action:action_id(title,agent_id,agent:agent_id(name,platform))'));
    expect(uri.queryParameters['order'], 'created_at.desc.nullslast');
    expect(uri.queryParameters['offset'], '50');
    expect(uri.queryParameters['limit'], '50');

    final entry = dtos.single.toEntity();
    expect(entry.id, '42');
    expect(entry.event, AuditEvent.decisionMade);
    expect(entry.actionTitle, 'Reply to Priya');
    expect(entry.agentName, 'Email agent');
    expect(entry.agentPlatform, AgentPlatform.n8n);
    expect(entry.wasEdited, isTrue);
  });

  test('filtering by agent uses an inner join on the action', () async {
    await AuditRemoteDataSourceImpl(client).fetchEntries(offset: 0, limit: 10, agentId: 'g1');

    final uri = requests.single.url;
    expect(uri.queryParameters['select'], contains('action!inner:action_id('));
    expect(uri.queryParameters['action.agent_id'], 'eq.g1');
  });
}
