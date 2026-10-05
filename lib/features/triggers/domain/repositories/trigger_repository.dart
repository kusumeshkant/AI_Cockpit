// Feature: triggers · Layer: domain
// Contract for Agent Triggers. Implementations never throw; failures come back
// as Left (FeatureDisabledFailure, TriggerDisabledFailure, RateLimitedFailure…).
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';

/// Agent trigger access.
abstract interface class TriggerRepository {
  /// Triggers configured in the workspace, with each agent's last run time.
  Result<List<AgentTrigger>> listTriggers();

  /// Starts the agent [agentId] through its trigger.
  Result<TriggerRun> runAgent(String agentId);

  /// Creates or reconfigures [agentId]'s trigger (rotates the secret).
  Result<TriggerCredentials> configureTrigger({
    required String agentId,
    required String triggerUrl,
    int? minIntervalSecs,
  });

  /// Enables or disables [agentId]'s trigger.
  Result<AgentTrigger> setTriggerEnabled({
    required String agentId,
    required bool enabled,
  });
}
