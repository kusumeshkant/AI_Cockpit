// App-wide Riverpod providers for platform singletons that must be created
// before the widget tree (overridden in main.dart and in tests).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The loaded [SharedPreferences] instance. Must be overridden in
/// `ProviderScope(overrides: [...])`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden at the ProviderScope.',
  ),
);
