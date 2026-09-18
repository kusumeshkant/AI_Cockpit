// Attaches the Supabase session JWT (and project key) to Edge Function
// requests, refreshing an expired session first.
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/di/environments.dart';

/// dio interceptor adding `Authorization: Bearer <jwt>` and `apikey`.
@LazySingleton(env: [AppEnvironments.live])
class AuthInterceptor extends Interceptor {
  /// Creates the interceptor.
  AuthInterceptor(this._client);

  final SupabaseClient _client;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var session = _client.auth.currentSession;
    if (session != null && session.isExpired) {
      try {
        session = (await _client.auth.refreshSession()).session;
      } on AuthException {
        session = null;
      }
    }
    options.headers['apikey'] = AppConfig.fromEnvironment().supabaseAnonKey;
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    handler.next(options);
  }
}
