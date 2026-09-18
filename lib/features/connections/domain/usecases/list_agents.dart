// Feature: connections · Layer: domain
// Use case: list the workspace's agents.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/domain/repositories/connections_repository.dart';

/// Lists agents.
@lazySingleton
class ListAgents {
  /// Creates the use case.
  const ListAgents(this._repository);

  final ConnectionsRepository _repository;

  /// Returns all agents in the workspace.
  Result<List<Agent>> call() => _repository.listAgents();
}
