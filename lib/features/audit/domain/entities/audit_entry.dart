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

  /// A user started the agent (Agent Triggers).
  triggerFired,

  /// Starting the agent failed (Agent Triggers).
  triggerFailed,
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
    required AuditEvent event,
    required DateTime createdAt,
    /// The action decided; `null` for trigger events, which concern an agent.
    String? actionId,
    /// The agent a trigger event concerns.
    String? agentId,
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

  /// Whether this entry records an agent run (Agent Triggers).
  bool get isTriggerEvent =>
      event == AuditEvent.triggerFired || event == AuditEvent.triggerFailed;

  /// Whether this entry records a rejection.
  bool get isRejection => decision == AuditDecisions.rejected;

  /// Whether the action was edited before approval.
  bool get wasEdited =>
      decision == AuditDecisions.approvedWithEdits ||
      (editedPayload?.isNotEmpty ?? false);
}
