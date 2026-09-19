import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';
import 'package:cockpit/features/auth/domain/usecases/verify_otp.dart';

import '../helpers/live_fakes.dart';

void main() {
  group('mapError', () {
    test('Edge Function statuses map to typed failures', () {
      expect(mapError(edgeError(409, 'conflict')), isA<ConflictFailure>());
      expect(mapError(edgeError(410, 'expired')), isA<ExpiredFailure>());
      expect(mapError(edgeError(422, 'validation')), isA<ValidationFailure>());
      expect(mapError(edgeError(401, 'unauthorized')), isA<AuthFailure>());
      final limited = mapError(edgeError(429, 'rate_limited', headers: {'retry-after': '17'}));
      expect(limited, isA<RateLimitedFailure>());
      expect((limited as RateLimitedFailure).retryAfter, const Duration(seconds: 17));
      final server = mapError(edgeError(404, 'not_found'));
      expect(server, isA<ServerFailure>());
      expect((server as ServerFailure).statusCode, 404);
      expect(server.message, 'not_found', reason: 'envelope code is kept for diagnostics');
    });

    test('feature-specific envelope codes map to their failures', () {
      expect(mapError(edgeError(404, 'feature_disabled')), isA<FeatureDisabledFailure>());
      expect(mapError(edgeError(409, 'trigger_disabled')), isA<TriggerDisabledFailure>());
      // Same statuses with other codes keep their existing mapping.
      expect(mapError(edgeError(404, 'not_found')), isA<ServerFailure>());
      expect(mapError(edgeError(409, 'conflict')), isA<ConflictFailure>());
      expect(mapError(edgeError(429, 'rate_limited')), isA<RateLimitedFailure>());
    });

    test('PostgREST errors map to auth / server failures', () {
      expect(
        mapError(const supa.PostgrestException(message: 'JWT expired', code: 'PGRST301')),
        isA<AuthFailure>(),
      );
      final missing = mapError(const supa.PostgrestException(message: 'no rows', code: 'PGRST116'));
      expect((missing as ServerFailure).statusCode, 404);
    });

    test('Auth errors: bad OTP is validation, 429 is rate limited, offline is network', () {
      expect(
        mapError(const supa.AuthApiException('Token has expired or is invalid', statusCode: '403', code: 'otp_expired')),
        isA<ValidationFailure>(),
      );
      expect(mapError(const supa.AuthApiException('Too many requests', statusCode: '429')), isA<RateLimitedFailure>());
      expect(mapError(supa.AuthRetryableFetchException(message: 'offline')), isA<NetworkFailure>());
    });

    test('transport errors are network failures; unknown errors are unexpected', () {
      expect(mapError(const SocketException('no route')), isA<NetworkFailure>());
      expect(mapError(http.ClientException('connection closed')), isA<NetworkFailure>());
      expect(mapError(TimeoutException('slow')), isA<NetworkFailure>());
      expect(mapError(StateError('bug')), isA<UnexpectedFailure>());
    });
  });

  test('unwrapEnvelope returns data and rejects malformed bodies', () {
    expect(unwrapEnvelope({'ok': true, 'data': {'a': 1}}), {'a': 1});
    expect(() => unwrapEnvelope({'ok': false}), throwsA(anything));
    expect(mapError(_capture(() => unwrapEnvelope('nope'))), isA<ServerFailure>());
  });

  test('VerifyOtp rejects malformed codes without calling the repository', () async {
    final repository = _MockAuthRepository();
    final result = await VerifyOtp(repository).call(email: 'a@b.co', code: '12ab');

    expect(result.fold((failure) => failure, (_) => null), isA<ValidationFailure>());
    verifyNever(() => repository.verifyOtp(email: any(named: 'email'), code: any(named: 'code')));
  });
}

class _MockAuthRepository extends Mock implements AuthRepository {}

Object _capture(void Function() body) {
  try {
    body();
  } catch (error) {
    return error;
  }
  throw StateError('expected an error');
}
