// Compile-time configuration read from --dart-define / --dart-define-from-file.
// Secrets are never committed; see technical/06-setup-and-stack.md.
import 'package:flutter/services.dart' show appFlavor;

import 'package:cockpit/core/config/flavor.dart';

/// Immutable runtime configuration for the current build.
class AppConfig {
  /// Creates a config. Prefer [AppConfig.fromEnvironment].
  const AppConfig({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.sentryDsn,
    required this.posthogKey,
    required this.firebaseEnabled,
  });

  /// Reads configuration from compile-time environment declarations.
  factory AppConfig.fromEnvironment() => AppConfig(
        flavor: resolveFlavor(
          buildFlavor: appFlavor,
          defineFlavor: const String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
        ),
        supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
        supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
        sentryDsn: const String.fromEnvironment('SENTRY_DSN'),
        posthogKey: const String.fromEnvironment('POSTHOG_KEY'),
        firebaseEnabled: const bool.fromEnvironment('FIREBASE_ENABLED', defaultValue: true),
      );

  /// The native build flavor (`--flavor`, exposed as [appFlavor]) wins over
  /// the `FLAVOR` dart-define, so a prod build made without dart-defines is
  /// still treated as prod.
  static Flavor resolveFlavor({required String? buildFlavor, required String defineFlavor}) =>
      Flavor.fromName(buildFlavor ?? defineFlavor);

  /// App version shown in Settings.
  static const String appVersion =
      String.fromEnvironment('APP_VERSION', defaultValue: '0.1.0');

  /// Active flavor.
  final Flavor flavor;

  /// Supabase project URL.
  final String supabaseUrl;

  /// Supabase anon (public) key.
  final String supabaseAnonKey;

  /// Sentry DSN; empty disables Sentry.
  final String sentryDsn;

  /// PostHog project key; empty disables analytics.
  final String posthogKey;

  /// Whether to try Firebase (push). On by default; initialisation is skipped
  /// quietly when the platform config file is absent. `FIREBASE_ENABLED=false`
  /// opts out.
  final bool firebaseEnabled;

  /// True when Supabase credentials are provided.
  bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// True when this build must not start: a non-debug prod build without a
  /// backend would otherwise fall back to in-memory demo data. Debug builds
  /// and the dev flavor keep the demo fallback.
  bool blocksStartup({required bool debugBuild}) =>
      !debugBuild && flavor == Flavor.prod && !hasSupabase;

  /// True when a Sentry DSN is provided.
  bool get hasSentry => sentryDsn.isNotEmpty;

  /// Base URL for Supabase Edge Functions.
  String get functionsBaseUrl => hasSupabase ? '$supabaseUrl/functions/v1' : '';
}
