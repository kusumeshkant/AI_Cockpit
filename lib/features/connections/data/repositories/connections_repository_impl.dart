// Feature: connections · Layer: data
// ConnectionsRepository implementation.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/connections/data/datasources/connections_remote_ds.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/domain/repositories/connections_repository.dart';

/// Default [ConnectionsRepository].
@LazySingleton(as: ConnectionsRepository)
class ConnectionsRepositoryImpl implements ConnectionsRepository {
  /// Creates the repository.
  const ConnectionsRepositoryImpl(this._remote);

  final ConnectionsRemoteDataSource _remote;

  @override
  Result<List<Agent>> listAgents() => guard(() async {
        final dtos = await _remote.listAgents();
        return dtos.map((dto) => dto.toEntity()).toList(growable: false);
      });

  @override
  Result<AgentCredentials> createAgent({
    required String name,
    required String callbackUrl,
    required AgentPlatform platform,
  }) =>
      guard(() async {
        final dto = await _remote.createAgent(
          name: name,
          callbackUrl: callbackUrl,
          platform: platform,
        );
        return dto.toEntity();
      });

  @override
  Result<Unit> sendTestAction(String agentId) => guard(() async {
        await _remote.sendTestAction(agentId);
        return unit;
      });
}
