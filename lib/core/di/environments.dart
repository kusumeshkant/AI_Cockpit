// injectable environment names. Kept separate from injection.dart so data
// sources can reference them without importing the generated config.

/// Dependency-injection environments.
abstract final class AppEnvironments {
  /// Real Supabase / Edge Function data sources.
  static const String live = 'live';

  /// In-memory demo data sources, used when no backend is configured so the
  /// UI can be run and reviewed end to end.
  static const String demo = 'demo';
}
