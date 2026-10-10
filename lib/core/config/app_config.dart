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
    this.termsUrl = '',
    this.privacyUrl = '',
    this.supportEmail = '',
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
        termsUrl: const String.fromEnvironment('TERMS_URL'),
        privacyUrl: const String.fromEnvironment('PRIVACY_URL'),
        supportEmail: const String.fromEnvironment('SUPPORT_EMAIL'),
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

  /// Terms of Service page; empty hides the link (prod release builds
  /// require it, see android/app/build.gradle.kts).
  final String termsUrl;

  /// Privacy Policy page; empty hides the link (required for prod releases).
  final String privacyUrl;

  /// Support contact, e.g. for email-based account deletion requests.
  final String supportEmail;

  /// [termsUrl] as an https URI, or `null` when unset or not https.
  Uri? get termsUri => _httpsUri(termsUrl);

  /// [privacyUrl] as an https URI, or `null` when unset or not https.
  Uri? get privacyUri => _httpsUri(privacyUrl);

  static Uri? _httpsUri(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty ? uri : null;
  }

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
