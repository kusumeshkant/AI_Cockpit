// Feature: triggers · Layer: data
// Live Agent Triggers: RLS-scoped REST reads of `agent_trigger` / `trigger_run`
// and the `agents-trigger` / `agents-configure-trigger` Edge Functions (dio).
// Errors are thrown and mapped by the repository's `guard`
// (feature_disabled / trigger_disabled / rate_limited → typed Failures).
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/features/triggers/data/models/agent_trigger_dto.dart';

/// Remote source for agent triggers.
abstract interface class TriggerRemoteDataSource {
  /// Triggers in the workspace (RLS-scoped).
  Future<List<AgentTriggerDto>> listTriggers();

  /// Latest run time per agent id.
  Future<Map<String, DateTime>> lastRuns();

  /// Calls `agents-trigger`.
  Future<TriggerRunDto> runAgent(String agentId);

  /// Calls `agents-configure-trigger` (action `configure`).
  Future<TriggerCredentialsDto> configureTrigger({
    required String agentId,
    required String triggerUrl,
    int? minIntervalSecs,
  });

  /// Calls `agents-configure-trigger` (action `set_enabled`).
  Future<AgentTriggerDto> setTriggerEnabled({
    required String agentId,
    required bool enabled,
  });
}

/// Supabase + Edge Function implementation.
@LazySingleton(as: TriggerRemoteDataSource, env: [AppEnvironments.live])
class TriggerRemoteDataSourceImpl implements TriggerRemoteDataSource {
  /// Creates the datasource.
  const TriggerRemoteDataSourceImpl(this._client, this._functions);

  /// Recent runs scanned for "last run" times.
  static const int recentRunsLimit = 200;

  /// Readable columns (never the Vault secret id).
  static const String _columns =
      'agent_id, trigger_url, secret_hint, enabled, min_interval_secs';

  final SupabaseClient _client;
  final DioClient _functions;

  @override
  Future<List<AgentTriggerDto>> listTriggers() async {
    final rows = await _client.from(DbTables.agentTrigger).select(_columns);
    return rows.map(AgentTriggerDto.fromJson).toList(growable: false);
  }

  @override
  Future<Map<String, DateTime>> lastRuns() async {
    final rows = await _client
        .from(DbTables.triggerRun)
        .select('agent_id, created_at')
        .order('created_at', ascending: false)
        .limit(recentRunsLimit);
    final latest = <String, DateTime>{};
    for (final row in rows) {
      final agentId = row['agent_id'] as String;
      latest.putIfAbsent(agentId, () => DateTime.parse(row['created_at'] as String));
    }
    return latest;
  }

  @override
  Future<TriggerRunDto> runAgent(String agentId) async {
    final data = await _functions.postFunction(ApiEndpoints.agentsTrigger, {
      'agent_id': agentId,
    });
    return TriggerRunDto.fromJson(data);
  }

  @override
  Future<TriggerCredentialsDto> configureTrigger({
    required String agentId,
    required String triggerUrl,
    int? minIntervalSecs,
  }) async {
    final data = await _functions.postFunction(ApiEndpoints.agentsConfigureTrigger, {
      'action': 'configure',
      'agent_id': agentId,
      'trigger_url': triggerUrl,
      'min_interval_secs': ?minIntervalSecs,
    });
    // The secret is returned once (never persisted client-side).
    return TriggerCredentialsDto.fromJson(data);
  }

  @override
  Future<AgentTriggerDto> setTriggerEnabled({
    required String agentId,
    required bool enabled,
  }) async {
    final data = await _functions.postFunction(ApiEndpoints.agentsConfigureTrigger, {
      'action': 'set_enabled',
      'agent_id': agentId,
      'enabled': enabled,
    });
    return AgentTriggerDto.fromJson(Map<String, dynamic>.from(data['trigger'] as Map));
  }
}
