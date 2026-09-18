// Feature: actions · Layer: domain
// A human decision on an action. The idempotency key is generated once per
// decision attempt so retries never double-decide (TR-3). Pure Dart.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_decision.freezed.dart';

/// The kind of decision.
enum DecisionType {
  /// Approved as proposed.
  approved,

  /// Approved after editing [ActionDecision.editedPayload].
  approvedWithEdits,

  /// Rejected, optionally with [ActionDecision.reason].
  rejected,
}

/// A decision to send to `actions-decision`.
@freezed
abstract class ActionDecision with _$ActionDecision {
  /// Creates an [ActionDecision].
  const factory ActionDecision({
    required String actionId,
    required DecisionType type,
    required String idempotencyKey,
    Map<String, dynamic>? editedPayload,
    String? reason,
  }) = _ActionDecision;
}
