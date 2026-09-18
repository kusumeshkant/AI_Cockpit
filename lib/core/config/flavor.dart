// Build flavors. Selected with --dart-define=FLAVOR=dev|prod and matching the
// Android productFlavors in android/app/build.gradle.kts.

/// Deployment environment of the running build.
enum Flavor {
  /// Development: dev Supabase/Firebase projects, verbose logging.
  dev,

  /// Production: live projects.
  prod;

  /// Parses [name], falling back to [Flavor.dev].
  static Flavor fromName(String name) =>
      values.firstWhere((f) => f.name == name, orElse: () => Flavor.dev);
}
