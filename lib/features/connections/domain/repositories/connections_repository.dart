// Feature: connections · Layer: domain
// Contract for managing agent connections.
import 'package:dartz/dartz.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';

/// Agent connection operations.
abstract interface class ConnectionsRepository {
  /// Lists agents in the current workspace.
  Result<List<Agent>> listAgents();

  /// Creates an agent; the returned secret is shown once.
  Result<AgentCredentials> createAgent({
    required String name,
    required String callbackUrl,
    required AgentPlatform platform,
  });

  /// Inserts a sample pending action for [agentId].
  Result<Unit> sendTestAction(String agentId);
}
