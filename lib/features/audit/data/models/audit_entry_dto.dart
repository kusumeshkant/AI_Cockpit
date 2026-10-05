// Feature: audit · Layer: data
// Wire model for `audit_entry` rows (joined with action title and agent).
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';

part 'audit_entry_dto.freezed.dart';
part 'audit_entry_dto.g.dart';

/// JSON representation of an `audit_entry` row.
@freezed
abstract class AuditEntryDto with _$AuditEntryDto {
  /// Creates a DTO.
  const factory AuditEntryDto({
    required String id,
    required String event,
    required DateTime createdAt,
    String? actionId,
    String? agentId,
    String? actionTitle,
    String? agentName,
    String? agentPlatform,
    String? actorEmail,
    String? decision,
    String? reason,
    Map<String, dynamic>? originalPayload,
    Map<String, dynamic>? editedPayload,
  }) = _AuditEntryDto;

  const AuditEntryDto._();

  /// Parses JSON.
  factory AuditEntryDto.fromJson(Map<String, dynamic> json) =>
      _$AuditEntryDtoFromJson(json);

  /// Maps to the domain entity. `event` is snake_case on the wire.
  AuditEntry toEntity() => AuditEntry(
        id: id,
        actionId: actionId,
        agentId: agentId,
        event: AuditEvent.values.firstWhere(
          (e) => _toSnake(e.name) == event,
          orElse: () => AuditEvent.actionReceived,
        ),
        createdAt: createdAt,
        actionTitle: actionTitle,
        agentName: agentName,
        agentPlatform:
            agentPlatform == null ? null : AgentPlatform.fromWire(agentPlatform),
        actorEmail: actorEmail,
        decision: decision,
        reason: reason,
        originalPayload: originalPayload,
        editedPayload: editedPayload,
      );

  static String _toSnake(String camel) => camel.replaceAllMapped(
        RegExp('[A-Z]'),
        (m) => '_${m[0]!.toLowerCase()}',
      );
}
