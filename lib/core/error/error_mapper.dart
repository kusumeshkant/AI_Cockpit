// Data-layer helper that runs a datasource call and converts exceptions into
// typed failures. Keeps try/catch out of every repository method.
import 'dart:async';
import 'dart:io' show SocketException;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import 'package:cockpit/core/error/exceptions.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/logger.dart';
import 'package:cockpit/core/utils/result.dart';

/// Runs [body] and returns `Right(value)` or `Left(Failure)`.
Result<T> guard<T>(Future<T> Function() body) async {
  try {
    return Right(await body());
  } catch (e, stack) {
    return Left(mapError(e, stack));
  }
}

/// Maps any error thrown by a datasource (dio, Supabase, network, our own
/// [AppException]s) to a [Failure].
Failure mapError(Object error, [StackTrace? stack]) {
  switch (error) {
    case Failure():
      return error;
    case DioException():
      return mapDioException(error);
    case AppException():
      return mapAppException(error);
    case supa.PostgrestException():
      return mapPostgrestException(error);
    case supa.AuthRetryableFetchException():
      return NetworkFailure(error.message);
    case supa.AuthException():
      return mapAuthException(error);
    case SocketException() || http.ClientException() || TimeoutException():
      return NetworkFailure(error.toString());
  }
  AppLogger.error('Unexpected repository error', error, stack);
  return UnexpectedFailure(error.toString());
}

/// Maps a [DioException] (Edge Function calls) to a [Failure]. Status codes
/// follow the backend envelope contract (product/backend/README.md).
Failure mapDioException(DioException e) {
  final message = _envelopeCode(e.response?.data) ?? e.message;
  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError =>
      NetworkFailure(message ?? 'network'),
    DioExceptionType.badResponse => switch (e.response?.statusCode) {
        401 || 403 => AuthFailure(message ?? 'auth'),
        409 => ConflictFailure(message ?? 'conflict'),
        410 => ExpiredFailure(message ?? 'expired'),
        413 || 422 => ValidationFailure(message ?? 'validation'),
        429 => RateLimitedFailure(
            message ?? 'rate_limited',
            _retryAfter(e.response?.headers.value('retry-after')),
          ),
        final code => ServerFailure(message ?? 'server', code),
      },
    _ => UnexpectedFailure(message ?? 'unexpected'),
  };
}

/// Maps a PostgREST error (RLS-scoped REST reads) to a [Failure].
Failure mapPostgrestException(supa.PostgrestException e) {
  final status = int.tryParse(e.code ?? '');
  return switch (e.code) {
    // JWT expired / invalid.
    'PGRST301' || 'PGRST302' || '42501' => AuthFailure(e.message),
    // `.single()` matched no row.
    'PGRST116' => ServerFailure(e.message, 404),
    _ when status == 401 || status == 403 => AuthFailure(e.message),
    _ => ServerFailure(e.message, status),
  };
}

/// Maps a Supabase Auth error to a [Failure]. A wrong or expired OTP code is
/// a validation problem, not a lost session.
Failure mapAuthException(supa.AuthException e) {
  final status = int.tryParse(e.statusCode ?? '');
  if (e.code == 'otp_expired' || status == 400 || status == 403 || status == 422) {
    return ValidationFailure(e.message);
  }
  if (status == 429) return RateLimitedFailure(e.message);
  return AuthFailure(e.message);
}

/// Maps an [AppException] to a [Failure].
Failure mapAppException(AppException e) => switch (e) {
      ServerException(:final message, :final statusCode) =>
        ServerFailure(message, statusCode),
      NetworkException(:final message) => NetworkFailure(message),
      UnauthorizedException(:final message) => AuthFailure(message),
    };

Duration? _retryAfter(String? header) {
  final seconds = int.tryParse(header ?? '');
  return seconds == null || seconds < 0 ? null : Duration(seconds: seconds);
}

String? _envelopeCode(Object? data) {
  if (data is Map && data['error'] is Map) {
    final code = (data['error'] as Map)['code'];
    return code is String ? code : null;
  }
  return null;
}
