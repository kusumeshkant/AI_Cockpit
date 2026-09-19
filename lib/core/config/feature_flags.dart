// Feature flags. Every flag is OFF by default. A flag turns on either at
// compile time (`--dart-define`, for local development against a backend with
// the matching flag) or remotely through PostHog once analytics is
// initialised. Until PostHog is set up (bootstrap TODO) the remote read is
// skipped and never touches the plugin, so the defaults apply.
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/utils/logger.dart';

/// Compile-time flag defaults.
abstract final class FeatureFlags {
  /// Agent Triggers (start an agent from the app). Off unless built with
  /// `--dart-define=AGENT_TRIGGERS=true`. Mirrors the backend's
  /// FEATURE_AGENT_TRIGGERS: with the backend flag off the Edge Functions
  /// answer `feature_disabled`.
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
/// configured for this build or the read fails.
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

/// The remote value of Agent Triggers (`null` until / unless known).
final _remoteAgentTriggersProvider = FutureProvider<bool?>(
  (ref) => ref.watch(remoteFlagSourceProvider).isEnabled(RemoteFlagKeys.agentTriggers),
);

/// Whether Agent Triggers UI is shown. Default OFF: the compile-time default,
/// or the PostHog flag when it has been read as true.
final agentTriggersProvider = Provider<bool>((ref) {
  if (FeatureFlags.agentTriggers) return true;
  return ref.watch(_remoteAgentTriggersProvider).value ?? false;
});

/// For widget tests: the flag forced to [enabled].
@visibleForTesting
Override agentTriggersOverride({required bool enabled}) =>
    agentTriggersProvider.overrideWithValue(enabled);
