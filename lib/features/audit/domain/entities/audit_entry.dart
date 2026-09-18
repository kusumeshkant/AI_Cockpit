// Feature: audit · Layer: domain
// One immutable row of the append-only audit trail. Pure Dart.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cockpit/core/domain/agent_platform.dart';

part 'audit_entry.freezed.dart';

/// Kind of audited event.
enum AuditEvent {
  /// An agent submitted an action.
  actionReceived,

  /// A human decided the action.
  decisionMade,

  /// A callback delivery was attempted.
  callbackAttempted,

  /// The agent acknowledged the callback.
  callbackDelivered,

  /// Callback retries were exhausted.
  callbackFailed,
}

/// Wire values of `audit_entry.decision`.
abstract final class AuditDecisions {
  /// Approved as proposed.
  static const String approved = 'approved';

  /// Approved after edits.
  static const String approvedWithEdits = 'approved_with_edits';

  /// Rejected.
  static const String rejected = 'rejected';
}

/// An audit log entry.
@freezed
abstract class AuditEntry with _$AuditEntry {
  /// Creates an [AuditEntry].
  const factory AuditEntry({
    required String id,
    required String actionId,
    required AuditEvent event,
    required DateTime createdAt,
    String? actionTitle,
    String? agentName,
    AgentPlatform? agentPlatform,
    String? actorEmail,
    String? decision,
    String? reason,
    Map<String, dynamic>? originalPayload,
    Map<String, dynamic>? editedPayload,
  }) = _AuditEntry;

  const AuditEntry._();

  /// Whether this entry records a rejection.
  bool get isRejection => decision == AuditDecisions.rejected;

  /// Whether the action was edited before approval.
  bool get wasEdited =>
      decision == AuditDecisions.approvedWithEdits ||
      (editedPayload?.isNotEmpty ?? false);
}
