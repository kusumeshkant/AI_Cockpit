// Entry point. Runs [bootstrap] (SDK init, DI, error zones) and mounts the
// Riverpod ProviderScope around [CockpitApp].
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/app.dart';
import 'package:cockpit/bootstrap.dart';
import 'package:cockpit/core/di/providers.dart';

/// Starts the Cockpit app.
void main() {
  bootstrap(
    (prefs) => ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const CockpitApp(),
    ),
  );
}
