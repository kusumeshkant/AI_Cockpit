// Feature: actions · Layer: domain
// An action proposed by an agent and awaiting (or holding) a human decision.
// Pure Dart.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/features/actions/domain/entities/action_decision.dart';

part 'action_item.freezed.dart';

/// Lifecycle status of an action.
enum ActionStatus {
  /// Awaiting a decision.
  pending,

  /// Decided (see [ActionItem.decision]).
  decided,

  /// Expired before a decision.
  expired,
}

/// Well-known renderer types. Any other string falls back to the generic
/// renderer (TR-5).
abstract final class ActionTypes {
  /// Email draft: `to`, `subject`, `body`.
  static const String email = 'email';

  /// Before/after diff.
  static const String diff = 'diff';

  /// Tabular rows: `columns`, `rows`.
  static const String table = 'table';
}

/// A proposed agent action.
@freezed
abstract class ActionItem with _$ActionItem {
  /// Creates an [ActionItem].
  const factory ActionItem({
    required String id,
    required String agentId,
    required String type,
    required String title,
    required Map<String, dynamic> payload,
    required ActionStatus status,
    required DateTime createdAt,
    String? agentName,
    AgentPlatform? agentPlatform,
    String? summary,
    @Default(<String>[]) List<String> editableFields,
    DecisionType? decision,
    DateTime? decidedAt,
    DateTime? expiresAt,
  }) = _ActionItem;

  const ActionItem._();

  /// Whether the action still needs a decision.
  bool get isPending => status == ActionStatus.pending;
}
