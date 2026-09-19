// Feature: triggers · Layer: domain
// Use case: the workspace's agent triggers (with last run times).
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/repositories/trigger_repository.dart';

/// Lists agent triggers.
@lazySingleton
class ListAgentTriggers {
  /// Creates the use case.
  const ListAgentTriggers(this._repository);

  final TriggerRepository _repository;

  /// Returns every configured trigger.
  Result<List<AgentTrigger>> call() => _repository.listTriggers();
}
