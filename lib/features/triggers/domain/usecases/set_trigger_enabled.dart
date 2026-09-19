// Feature: triggers · Layer: domain
// Use case: enable or disable an agent's trigger.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/repositories/trigger_repository.dart';

/// Enables / disables an agent trigger.
@lazySingleton
class SetTriggerEnabled {
  /// Creates the use case.
  const SetTriggerEnabled(this._repository);

  final TriggerRepository _repository;

  /// Sets whether [agentId]'s trigger may run.
  Result<AgentTrigger> call({required String agentId, required bool enabled}) =>
      _repository.setTriggerEnabled(agentId: agentId, enabled: enabled);
}
