// Feature: audit · Layer: data
// Live audit trail: `audit_entry` decision events via RLS-scoped REST, joined
// with the action title and agent.
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/audit/data/models/audit_entry_dto.dart';

/// Remote audit source.
abstract interface class AuditRemoteDataSource {
  /// Fetches a page of entries.
  Future<List<AuditEntryDto>> fetchEntries({
    required int offset,
    required int limit,
    String? agentId,
  });
}

/// Supabase implementation.
@LazySingleton(as: AuditRemoteDataSource, env: [AppEnvironments.live])
class AuditRemoteDataSourceImpl implements AuditRemoteDataSource {
  /// Creates the datasource.
  const AuditRemoteDataSourceImpl(this._client);

  /// Event shown in the timeline.
  static const String decisionEvent = 'decision_made';

  final SupabaseClient _client;

  @override
  Future<List<AuditEntryDto>> fetchEntries({
    required int offset,
    required int limit,
    String? agentId,
  }) async {
    final join = agentId == null ? 'action' : 'action!inner';
    var query = _client
        .from(DbTables.auditEntry)
        .select(
          'id, action_id, event, decision, reason, edited_payload, created_at, '
          '$join:action_id(title, agent_id, agent:agent_id(name, platform))',
        )
        .eq('event', decisionEvent);
    if (agentId != null) query = query.eq('action.agent_id', agentId);

    final rows = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
    return rows.map(_toDto).toList(growable: false);
  }

  static AuditEntryDto _toDto(Map<String, dynamic> row) {
    final action = row['action'];
    final agent = action is Map ? action['agent'] : null;
    return AuditEntryDto.fromJson({
      ...row,
      'id': '${row['id']}',
      'action_title': action is Map ? action['title'] : null,
      'agent_name': agent is Map ? agent['name'] : null,
      'agent_platform': agent is Map ? agent['platform'] : null,
    });
  }
}
