// Feature: triggers · Layer: domain
// Use case: start an agent through its trigger.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/repositories/trigger_repository.dart';

/// Starts an agent.
@lazySingleton
class RunAgent {
  /// Creates the use case.
  const RunAgent(this._repository);

  final TriggerRepository _repository;

  /// Starts [agentId].
  Result<TriggerRun> call(String agentId) => _repository.runAgent(agentId);
}
