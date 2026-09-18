// Feature: connections · Layer: data
// Wire models for `agent` rows and the agents-create response.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';

part 'agent_dto.freezed.dart';
part 'agent_dto.g.dart';

/// JSON representation of an `agent` row.
@freezed
abstract class AgentDto with _$AgentDto {
  /// Creates a DTO.
  const factory AgentDto({
    required String id,
    required String name,
    required String callbackUrl,
    @Default('custom') String platform,
    @Default('active') String status,
    String? secretHint,
    DateTime? lastActionAt,
  }) = _AgentDto;

  const AgentDto._();

  /// Parses JSON.
  factory AgentDto.fromJson(Map<String, dynamic> json) =>
      _$AgentDtoFromJson(json);

  /// Maps to the domain entity.
  Agent toEntity() => Agent(
        id: id,
        name: name,
        callbackUrl: callbackUrl,
        platform: AgentPlatform.fromWire(platform),
        status: AgentStatus.values.firstWhere(
          (s) => s.name == status,
          orElse: () => AgentStatus.disabled,
        ),
        secretHint: secretHint,
        lastActionAt: lastActionAt,
      );
}

/// JSON response of `agents-create`.
@freezed
abstract class AgentCredentialsDto with _$AgentCredentialsDto {
  /// Creates a DTO.
  const factory AgentCredentialsDto({
    required AgentDto agent,
    required String inboundUrl,
    required String inboundSecret,
  }) = _AgentCredentialsDto;

  const AgentCredentialsDto._();

  /// Parses JSON.
  factory AgentCredentialsDto.fromJson(Map<String, dynamic> json) =>
      _$AgentCredentialsDtoFromJson(json);

  /// Maps to the domain entity.
  AgentCredentials toEntity() => AgentCredentials(
        agent: agent.toEntity(),
        inboundUrl: inboundUrl,
        inboundSecret: inboundSecret,
      );
}
