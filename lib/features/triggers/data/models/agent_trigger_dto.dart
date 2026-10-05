// Feature: triggers · Layer: data
// Wire models for `agent_trigger` rows and the agents-trigger /
// agents-configure-trigger responses (product/backend README, Agent Triggers).
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';

part 'agent_trigger_dto.freezed.dart';
part 'agent_trigger_dto.g.dart';

/// JSON representation of an `agent_trigger` row (never the secret or its id).
@freezed
abstract class AgentTriggerDto with _$AgentTriggerDto {
  /// Creates a DTO.
  const factory AgentTriggerDto({
    required String agentId,
    required String triggerUrl,
    required String secretHint,
    @Default(true) bool enabled,
    @Default(30) int minIntervalSecs,
  }) = _AgentTriggerDto;

  const AgentTriggerDto._();

  /// Parses JSON.
  factory AgentTriggerDto.fromJson(Map<String, dynamic> json) =>
      _$AgentTriggerDtoFromJson(json);

  /// Maps to the domain entity; [lastRunAt] comes from `trigger_run`.
  AgentTrigger toEntity({DateTime? lastRunAt}) => AgentTrigger(
        agentId: agentId,
        triggerUrl: triggerUrl,
        secretHint: secretHint,
        enabled: enabled,
        minIntervalSecs: minIntervalSecs,
        lastRunAt: lastRunAt,
      );
}

/// `agents-trigger` response `data`.
@freezed
abstract class TriggerRunDto with _$TriggerRunDto {
  /// Creates a DTO.
  const factory TriggerRunDto({
    required String runId,
    required bool delivered,
    @Default('') String detail,
  }) = _TriggerRunDto;

  const TriggerRunDto._();

  /// Parses JSON.
  factory TriggerRunDto.fromJson(Map<String, dynamic> json) =>
      _$TriggerRunDtoFromJson(json);

  /// Maps to the domain entity.
  TriggerRun toEntity() => TriggerRun(runId: runId, delivered: delivered, detail: detail);
}

/// `agents-configure-trigger` (configure) response `data`.
@freezed
abstract class TriggerCredentialsDto with _$TriggerCredentialsDto {
  /// Creates a DTO.
  const factory TriggerCredentialsDto({
    required AgentTriggerDto trigger,
    required String triggerSecret,
  }) = _TriggerCredentialsDto;

  const TriggerCredentialsDto._();

  /// Parses JSON.
  factory TriggerCredentialsDto.fromJson(Map<String, dynamic> json) =>
      _$TriggerCredentialsDtoFromJson(json);

  /// Maps to the domain entity. The secret is shown once and never stored.
  TriggerCredentials toEntity() =>
      TriggerCredentials(trigger: trigger.toEntity(), secret: triggerSecret);
}
