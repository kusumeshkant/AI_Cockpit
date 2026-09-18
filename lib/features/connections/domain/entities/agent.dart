// Feature: connections · Layer: domain
// A connected external agent, and the one-time credentials returned on
// creation (TR-8: the secret is never retrievable again). Pure Dart.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cockpit/core/domain/agent_platform.dart';

part 'agent.freezed.dart';

/// Lifecycle status of an agent connection.
enum AgentStatus {
  /// Accepts inbound actions.
  active,

  /// Inbound actions are rejected.
  disabled,
}

/// An agent connected to the workspace.
@freezed
abstract class Agent with _$Agent {
  /// Creates an [Agent].
  const factory Agent({
    required String id,
    required String name,
    required String callbackUrl,
    @Default(AgentPlatform.custom) AgentPlatform platform,
    @Default(AgentStatus.active) AgentStatus status,
    String? secretHint,
    DateTime? lastActionAt,
  }) = _Agent;
}

/// Result of creating an agent. [inboundSecret] is shown once.
@freezed
abstract class AgentCredentials with _$AgentCredentials {
  /// Creates [AgentCredentials].
  const factory AgentCredentials({
    required Agent agent,
    required String inboundUrl,
    required String inboundSecret,
  }) = _AgentCredentials;
}
