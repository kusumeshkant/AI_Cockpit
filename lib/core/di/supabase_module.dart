// Registers the Supabase client for the live environment. Supabase is only
// initialised in bootstrap when SUPABASE_URL / SUPABASE_ANON_KEY are provided,
// which is exactly when the `live` environment is selected.
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/di/environments.dart';

/// Third-party registrations.
@module
abstract class SupabaseModule {
  /// Initialised Supabase client (Auth, REST, Realtime, RPC).
  @LazySingleton(env: [AppEnvironments.live])
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
