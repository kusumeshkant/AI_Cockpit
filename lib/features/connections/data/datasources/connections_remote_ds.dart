// Feature: connections · Layer: data
// Live agents: RLS-scoped REST list + `agents-create` / `agents-test-action`
// Edge Functions (dio).
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/features/connections/data/models/agent_dto.dart';

/// Remote source for agents.
abstract interface class ConnectionsRemoteDataSource {
  /// Fetches all agents (RLS-scoped).
  Future<List<AgentDto>> listAgents();

  /// Calls `agents-create`.
  Future<AgentCredentialsDto> createAgent({
    required String name,
    required String callbackUrl,
    required AgentPlatform platform,
  });

  /// Calls `agents-test-action`.
  Future<void> sendTestAction(String agentId);
}

/// Supabase + Edge Function implementation.
@LazySingleton(as: ConnectionsRemoteDataSource, env: [AppEnvironments.live])
class ConnectionsRemoteDataSourceImpl implements ConnectionsRemoteDataSource {
  /// Creates the datasource.
  const ConnectionsRemoteDataSourceImpl(this._client, this._functions);

  static const String _columns =
      'id, name, platform, callback_url, status, secret_hint, last_action_at';

  final SupabaseClient _client;
  final DioClient _functions;

  @override
  Future<List<AgentDto>> listAgents() async {
    final rows = await _client
        .from(DbTables.agent)
        .select(_columns)
        .order('created_at', ascending: false);
    return rows.map(AgentDto.fromJson).toList(growable: false);
  }

  @override
  Future<AgentCredentialsDto> createAgent({
    required String name,
    required String callbackUrl,
    required AgentPlatform platform,
  }) async {
    final data = await _functions.postFunction(ApiEndpoints.agentsCreate, {
      'name': name,
      'platform': platform.name,
      'callback_url': callbackUrl,
    });
    return AgentCredentialsDto(
      agent: AgentDto.fromJson(Map<String, dynamic>.from(data['agent'] as Map)),
      inboundUrl: data['inbound_url'] as String,
      // Returned once by the backend (TR-8); never persisted client-side.
      inboundSecret: data['signing_secret'] as String,
    );
  }

  @override
  Future<void> sendTestAction(String agentId) async {
    // The sample action arrives in the feed through Realtime (and as a push).
    await _functions.postFunction(ApiEndpoints.agentsTestAction, {'agent_id': agentId});
  }
}
