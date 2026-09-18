// Feature: actions · Layer: data
// Wire model for `action` rows (joined with agent name/platform); maps to
// ActionItem.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';

part 'action_item_dto.freezed.dart';
part 'action_item_dto.g.dart';

/// Wire names of [DecisionType] (blueprint §5.2).
abstract final class DecisionWire {
  /// Maps a wire value to a [DecisionType].
  static DecisionType? parse(String? value) => switch (value) {
        'approved' => DecisionType.approved,
        'approved_with_edits' => DecisionType.approvedWithEdits,
        'rejected' => DecisionType.rejected,
        _ => null,
      };

  /// Maps a [DecisionType] to its wire value.
  static String encode(DecisionType type) => switch (type) {
        DecisionType.approved => 'approved',
        DecisionType.approvedWithEdits => 'approved_with_edits',
        DecisionType.rejected => 'rejected',
      };
}

/// JSON representation of an `action` row.
@freezed
abstract class ActionItemDto with _$ActionItemDto {
  /// Creates a DTO.
  const factory ActionItemDto({
    required String id,
    required String agentId,
    required String type,
    required String title,
    required Map<String, dynamic> payload,
    required String status,
    required DateTime createdAt,
    String? agentName,
    String? agentPlatform,
    String? summary,
    @Default(<String>[]) List<String> editableFields,
    String? decision,
    DateTime? decidedAt,
    DateTime? expiresAt,
  }) = _ActionItemDto;

  const ActionItemDto._();

  /// Parses JSON.
  factory ActionItemDto.fromJson(Map<String, dynamic> json) =>
      _$ActionItemDtoFromJson(json);

  /// Maps to the domain entity.
  ActionItem toEntity() => ActionItem(
        id: id,
        agentId: agentId,
        type: type,
        title: title,
        payload: payload,
        status: ActionStatus.values.firstWhere(
          (s) => s.name == status,
          orElse: () => ActionStatus.pending,
        ),
        createdAt: createdAt,
        agentName: agentName,
        agentPlatform:
            agentPlatform == null ? null : AgentPlatform.fromWire(agentPlatform),
        summary: summary,
        editableFields: editableFields,
        decision: DecisionWire.parse(decision),
        decidedAt: decidedAt,
        expiresAt: expiresAt,
      );
}
