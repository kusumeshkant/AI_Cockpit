// Configured dio instance for Supabase Edge Functions, plus unwrapping of the
// backend's `{ ok, data | error }` response envelope.
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/error/exceptions.dart';
import 'package:cockpit/core/network/auth_interceptor.dart';

/// Owns the app's [Dio] instance.
@LazySingleton(env: [AppEnvironments.live])
class DioClient {
  /// Creates the client with the auth interceptor attached.
  DioClient(AuthInterceptor authInterceptor)
      : dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.fromEnvironment().functionsBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        )..interceptors.add(authInterceptor);

  /// Wraps an existing [Dio] (tests).
  @visibleForTesting
  DioClient.withDio(this.dio);

  /// Underlying dio instance used by datasources.
  final Dio dio;

  /// POSTs [body] to an Edge Function and returns the envelope's `data`.
  /// Non-2xx responses surface as [DioException] (mapped by `guard`).
  Future<Map<String, dynamic>> postFunction(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final response = await dio.post<Object?>(
      path,
      data: body,
      options: Options(headers: headers),
    );
    return unwrapEnvelope(response.data);
  }
}

/// Extracts `data` from a `{ ok: true, data: {...} }` envelope.
Map<String, dynamic> unwrapEnvelope(Object? body) {
  if (body is Map && body['ok'] == true && body['data'] is Map) {
    return Map<String, dynamic>.from(body['data'] as Map);
  }
  throw const ServerException('Malformed response envelope');
}
