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
  /// Fetches a page of entries. [includeTriggerEvents] (Agent Triggers,
  /// flag-gated) adds `trigger_fired` / `trigger_failed` rows.
  Future<List<AuditEntryDto>> fetchEntries({
    required int offset,
    required int limit,
    String? agentId,
    bool includeTriggerEvents = false,
  });
}

/// Supabase implementation.
@LazySingleton(as: AuditRemoteDataSource, env: [AppEnvironments.live])
class AuditRemoteDataSourceImpl implements AuditRemoteDataSource {
  /// Creates the datasource.
  const AuditRemoteDataSourceImpl(this._client);

  /// Event shown in the timeline.
  static const String decisionEvent = 'decision_made';

  /// Agent Triggers events (shown only while the feature flag is on).
  static const List<String> triggerEvents = ['trigger_fired', 'trigger_failed'];

  final SupabaseClient _client;

  @override
  Future<List<AuditEntryDto>> fetchEntries({
    required int offset,
    required int limit,
    String? agentId,
    bool includeTriggerEvents = false,
  }) async {
    final join = agentId == null ? 'action' : 'action!inner';
    final base = _client.from(DbTables.auditEntry).select(
          'id, action_id, event, decision, reason, edited_payload, created_at, '
          '$join:action_id(title, agent_id, agent:agent_id(name, platform))'
          '${includeTriggerEvents ? ', metadata' : ''}',
        );
    var query = includeTriggerEvents
        ? base.inFilter('event', [decisionEvent, ...triggerEvents])
        : base.eq('event', decisionEvent);
    if (agentId != null) query = query.eq('action.agent_id', agentId);

    final rows = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
    final agents = includeTriggerEvents ? await _agentsOfTriggerRows(rows) : const {};
    return rows.map((row) => _toDto(row, agents)).toList(growable: false);
  }

  /// Trigger events carry their agent in `metadata.agent_id` (no action):
  /// resolve those agents' name / platform in one query.
  Future<Map<String, Map<String, dynamic>>> _agentsOfTriggerRows(
    List<Map<String, dynamic>> rows,
  ) async {
    final ids = {
      for (final row in rows)
        if (row['action'] == null && row['metadata'] is Map)
          (row['metadata'] as Map)['agent_id'],
    }.whereType<String>().toList(growable: false);
    if (ids.isEmpty) return const {};
    final agents = await _client
        .from(DbTables.agent)
        .select('id, name, platform')
        .inFilter('id', ids);
    return {for (final agent in agents) agent['id'] as String: agent};
  }

  static AuditEntryDto _toDto(
    Map<String, dynamic> row,
    Map<dynamic, dynamic> triggerAgents,
  ) {
    final action = row['action'];
    final metadata = row['metadata'];
    final triggerAgentId =
        action == null && metadata is Map ? metadata['agent_id'] as String? : null;
    final agent = action is Map ? action['agent'] : triggerAgents[triggerAgentId];
    return AuditEntryDto.fromJson({
      ...row,
      'id': '${row['id']}',
      'agent_id': triggerAgentId,
      'action_title': action is Map ? action['title'] : null,
      'agent_name': agent is Map ? agent['name'] : null,
      'agent_platform': agent is Map ? agent['platform'] : null,
    });
  }
}
