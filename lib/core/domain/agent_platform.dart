// Shared domain value: where an agent runs. Used by the connections, actions
// and audit features. Pure Dart.

/// Automation platform hosting an agent.
enum AgentPlatform {
  /// n8n workflow.
  n8n,

  /// Make scenario.
  make,

  /// Zapier zap.
  zapier,

  /// Custom code.
  custom;

  /// Parses a wire value, falling back to [AgentPlatform.custom].
  static AgentPlatform fromWire(String? value) => values.firstWhere(
        (p) => p.name == value,
        orElse: () => AgentPlatform.custom,
      );
}
