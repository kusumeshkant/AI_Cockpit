// Feature: triggers · Layer: domain
// Agent Triggers (app → agent): an agent's trigger configuration, the result
// of one run, and the one-time secret returned when a trigger is configured
// (never retrievable again). Pure Dart.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agent_trigger.freezed.dart';

/// An agent's trigger. The secret itself is never part of it.
@freezed
abstract class AgentTrigger with _$AgentTrigger {
  /// Creates an [AgentTrigger].
  const factory AgentTrigger({
    required String agentId,
    required String triggerUrl,
    required String secretHint,
    required bool enabled,
    required int minIntervalSecs,
    DateTime? lastRunAt,
  }) = _AgentTrigger;
}

/// Outcome of starting an agent. [delivered] is false when the agent didn't
/// acknowledge the trigger (the run is recorded as failed).
@freezed
abstract class TriggerRun with _$TriggerRun {
  /// Creates a [TriggerRun].
  const factory TriggerRun({
    required String runId,
    required bool delivered,
    required String detail,
  }) = _TriggerRun;
}

/// Result of configuring a trigger. [secret] is shown once.
@freezed
abstract class TriggerCredentials with _$TriggerCredentials {
  /// Creates [TriggerCredentials].
  const factory TriggerCredentials({
    required AgentTrigger trigger,
    required String secret,
  }) = _TriggerCredentials;
}
