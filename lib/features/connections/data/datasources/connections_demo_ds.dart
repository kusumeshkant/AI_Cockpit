// Feature: connections · Layer: data
// In-memory demo agents (AppEnvironments.demo), seeded with the rows in
// technical/design/Connections.dc.html. Created agents get fake credentials.
import 'dart:math';

import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/connections/data/datasources/connections_remote_ds.dart';
import 'package:cockpit/features/connections/data/models/agent_dto.dart';

/// Demo implementation of [ConnectionsRemoteDataSource].
@LazySingleton(as: ConnectionsRemoteDataSource, env: [AppEnvironments.demo])
class ConnectionsDemoDataSource implements ConnectionsRemoteDataSource {
  /// Creates the datasource with seed data relative to now.
  ConnectionsDemoDataSource() : _agents = _seed(DateTime.now());

  final List<AgentDto> _agents;
  final Random _random = Random();

  static List<AgentDto> _seed(DateTime now) => [
        AgentDto(
          id: 'agt_email',
          name: 'Email agent',
          platform: 'n8n',
          callbackUrl: 'https://n8n.example.com/webhook/cockpit',
          secretHint: '3a9f',
          lastActionAt: now.subtract(const Duration(minutes: 4)),
        ),
        AgentDto(
          id: 'agt_finance',
          name: 'Finance bot',
          platform: 'make',
          callbackUrl: 'https://hook.make.com/cockpit-finance',
          secretHint: 'b71c',
          lastActionAt: now.subtract(const Duration(hours: 1)),
        ),
        const AgentDto(
          id: 'agt_support',
          name: 'Support triage',
          platform: 'custom',
          status: 'disabled',
          callbackUrl: 'https://support.example.com/cockpit/callback',
          secretHint: '09de',
        ),
      ];

  @override
  Future<List<AgentDto>> listAgents() async => List.unmodifiable(_agents);

  @override
  Future<AgentCredentialsDto> createAgent({
    required String name,
    required String callbackUrl,
    required AgentPlatform platform,
  }) async {
    final id = 'agt_${_hex(4)}';
    final secret = 'whsec_${_hex(24)}';
    final agent = AgentDto(
      id: id,
      name: name,
      platform: platform.name,
      callbackUrl: callbackUrl,
      secretHint: secret.substring(secret.length - 4),
    );
    _agents.insert(0, agent);
    return AgentCredentialsDto(
      agent: agent,
      inboundUrl: 'https://api.cockpit.app/v1/in/$id',
      inboundSecret: secret,
    );
  }

  @override
  Future<void> sendTestAction(String agentId) async {}

  String _hex(int bytes) => List.generate(
        bytes,
        (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();
}
