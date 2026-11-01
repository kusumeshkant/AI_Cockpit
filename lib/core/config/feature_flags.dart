// Feature flags. Every flag is OFF by default.
//
// The server decides (backend `feature_setting`, migration 0010), so a
// feature switches on or off with no app re-release:
//  * Agent Triggers = compile-time capability (`--dart-define=AGENT_TRIGGERS`)
//    AND the server's `agent_triggers` flag. A build without the capability
//    never reads the server value for it.
//  * Agent services = the server's `agent_services` flag only.
// Server values come from featureSettingsControllerProvider: last known value
// kept on a failed read, fail closed while nothing is known, `min_app_version`
// respected. PostHog is not consulted for these flags.
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/utils/logger.dart';
import 'package:cockpit/features/feature_settings/domain/entities/feature_setting.dart';
import 'package:cockpit/features/feature_settings/presentation/controllers/feature_settings_controller.dart';

/// Compile-time capabilities.
abstract final class FeatureFlags {
  /// Agent Triggers capability. Off unless built with
  /// `--dart-define=AGENT_TRIGGERS=true`; even then the UI shows only while
  /// the server's `agent_triggers` flag is on (see [agentTriggersProvider]).
  static const bool agentTriggers = bool.fromEnvironment('AGENT_TRIGGERS');
}

/// Remote flag keys (PostHog).
abstract final class RemoteFlagKeys {
  /// Agent Triggers.
  static const String agentTriggers = 'agent_triggers';
}

/// Reads a remote boolean flag; `null` when unknown / unavailable.
abstract interface class RemoteFlagSource {
  /// Whether [key] is enabled remotely, or `null` if it can't be read.
  Future<bool?> isEnabled(String key);
}

/// PostHog-backed flags. Returns `null` (never throws) when PostHog isn't
/// configured for this build or the read fails. Not consulted by the flag
/// providers since 0010 (the server's feature_setting decides); kept for
/// analytics-side experiments once PostHog is initialised.
class PostHogFlagSource implements RemoteFlagSource {
  /// Creates the source. [configured] is false when no POSTHOG_KEY is set.
  const PostHogFlagSource({required this.configured});

  /// Whether PostHog is configured for this build.
  final bool configured;

  @override
  Future<bool?> isEnabled(String key) async {
    if (!configured) return null;
    try {
      return await Posthog().isFeatureEnabled(key);
    } catch (error) {
      AppLogger.warning('Feature flag "$key" unavailable: $error');
      return null;
    }
  }
}

/// Remote flag source (overridable in tests).
final remoteFlagSourceProvider = Provider<RemoteFlagSource>(
  (ref) => PostHogFlagSource(
    configured: AppConfig.fromEnvironment().posthogKey.isNotEmpty,
  ),
);

/// The Agent Triggers compile-time capability (overridable in tests).
final agentTriggersCapabilityProvider = Provider<bool>((ref) => FeatureFlags.agentTriggers);

/// Whether Agent Triggers UI is shown: capability AND server flag.
final agentTriggersProvider = Provider<bool>((ref) {
  if (!ref.watch(agentTriggersCapabilityProvider)) return false;
  return ref.watch(serverFeatureProvider(FeatureKeys.agentTriggers));
});

/// Whether agent services are available (server flag only).
final agentServicesProvider =
    Provider<bool>((ref) => ref.watch(serverFeatureProvider(FeatureKeys.agentServices)));

/// For widget tests: the flag forced to [enabled].
@visibleForTesting
Override agentTriggersOverride({required bool enabled}) =>
    agentTriggersProvider.overrideWithValue(enabled);
