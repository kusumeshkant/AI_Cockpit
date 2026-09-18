// Backend endpoint and table names. Single source of truth for the contract in
// technical/04-technical-blueprint.md §5.

/// Supabase Edge Function paths, relative to `AppConfig.functionsBaseUrl`.
abstract final class ApiEndpoints {
  /// Agent → Cockpit signed inbound action (called by agents, not the app).
  static const String actionsInbound = '/actions-inbound';

  /// App → decide an action (JWT + Idempotency-Key).
  static const String actionsDecision = '/actions-decision';

  /// App → create an agent; returns the inbound secret once.
  static const String agentsCreate = '/agents-create';

  /// App → rotate an agent's inbound secret.
  static const String agentsRotateSecret = '/agents-rotate-secret';

  /// App → insert a sample action for an agent.
  static const String agentsTestAction = '/agents-test-action';
}

/// Postgres table names (accessed through Supabase with RLS).
abstract final class DbTables {
  /// Tenant table.
  static const String workspace = 'workspace';

  /// Users belonging to a workspace.
  static const String appUser = 'app_user';

  /// Connected agents.
  static const String agent = 'agent';

  /// Proposed actions awaiting or holding a decision.
  static const String action = 'action';

  /// Append-only audit trail.
  static const String auditEntry = 'audit_entry';
}
