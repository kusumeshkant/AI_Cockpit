// App bootstrap: initialises Firebase, Supabase, Sentry and dependency
// injection inside a guarded zone, then runs the widget produced by the
// caller. Each SDK is skipped when its config is absent so the app still
// runs locally before accounts are set up (see technical/06-setup-and-stack.md at the repo root).
// Firebase is attempted by default and skipped quietly when unconfigured.
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/testing/marionette_config.dart';
import 'package:cockpit/core/utils/logger.dart';

/// Initialises Firebase (push only) from the platform config files
/// (google-services.json / GoogleService-Info.plist). Missing config is not an
/// error: push stays off and the app relies on Realtime + poll.
Future<void> _initFirebase(AppConfig config) async {
  if (!config.firebaseEnabled || kIsWeb) return;
  try {
    await Firebase.initializeApp();
  } catch (error) {
    AppLogger.warning('Firebase not configured; push notifications are off ($error)');
  }
}

/// Builds the root widget once platform services are ready.
typedef RootBuilder = Widget Function(SharedPreferences prefs);

/// Initialises SDKs and DI, then runs the widget returned by [builder].
Future<void> bootstrap(RootBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      // Debug builds use Marionette's binding (a WidgetsFlutterBinding) so an
      // MCP agent can drive the UI over the local VM service. kDebugMode is a
      // compile-time constant: release builds keep the plain binding and
      // tree-shake the Marionette code.
      if (kDebugMode) {
        MarionetteBinding.ensureInitialized(buildMarionetteConfiguration());
      } else {
        WidgetsFlutterBinding.ensureInitialized();
      }
      final config = AppConfig.fromEnvironment();

      await _initFirebase(config);
      if (config.hasSupabase) {
        await Supabase.initialize(
          url: config.supabaseUrl,
          publishableKey: config.supabaseAnonKey,
        );
      }
      // TODO(observability): initialise PostHog with config.posthogKey.

      // No backend configured → run on in-memory demo data.
      configureDependencies(demo: !config.hasSupabase);
      final prefs = await SharedPreferences.getInstance();
      final root = builder(prefs);

      if (config.hasSentry) {
        await SentryFlutter.init(
          (options) {
            options
              ..dsn = config.sentryDsn
              ..environment = config.flavor.name
              ..sendDefaultPii = false;
          },
          appRunner: () => runApp(root),
        );
      } else {
        runApp(root);
      }
    },
    (error, stack) {
      AppLogger.error('Uncaught zone error', error, stack);
      Sentry.captureException(error, stackTrace: stack);
    },
  );
}
