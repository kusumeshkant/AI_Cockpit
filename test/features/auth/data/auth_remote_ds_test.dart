import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:cockpit/features/auth/data/models/auth_user_dto.dart';
import 'package:cockpit/features/auth/data/repositories/auth_repository_impl.dart';

import '../../../helpers/live_fakes.dart';

const _userId = '11111111-1111-4111-8111-111111111111';

Map<String, dynamic> _session() => {
      'access_token': fakeJwt(_userId),
      'token_type': 'bearer',
      'expires_in': 3600,
      'expires_at': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      'refresh_token': 'refresh-token',
      'user': {
        'id': _userId,
        'aud': 'authenticated',
        'role': 'authenticated',
        'email': 'meera@clinic.example',
        'created_at': '2026-09-15T06:00:00Z',
        'app_metadata': {'provider': 'email'},
        'user_metadata': <String, dynamic>{},
      },
    };

void main() {
  late List<Recorded> requests;
  late SupabaseClient client;
  var verifyStatus = 200;

  setUp(() {
    requests = [];
    verifyStatus = 200;
    client = fakeSupabase((request) {
      final path = request.url.path;
      if (path == '/auth/v1/otp') return jsonResponse(<String, dynamic>{});
      if (path == '/auth/v1/verify') {
        return verifyStatus == 200
            ? jsonResponse(_session())
            : jsonResponse(
                {'code': 403, 'error_code': 'otp_expired', 'msg': 'Token has expired or is invalid'},
                status: verifyStatus,
              );
      }
      if (path == '/rest/v1/app_user') {
        return jsonResponse({
          'id': _userId,
          'email': 'meera@clinic.example',
          'workspace_id': 'w1',
          'workspace': {'plan': 'pro'},
        });
      }
      return jsonResponse({'message': 'unexpected $path'}, status: 404);
    }, requests);
  });

  tearDown(() => client.dispose());

  test('signIn requests an email OTP and allows sign-up', () async {
    await AuthRemoteDataSourceImpl(client).signIn(email: 'meera@clinic.example');

    final request = requests.single;
    expect(request.url.path, '/auth/v1/otp');
    final body = jsonDecode(request.body) as Map<String, dynamic>;
    expect(body['email'], 'meera@clinic.example');
    expect(body['create_user'], isTrue);
  });

  test('verifyOtp starts a session and the auth stream emits the profile', () async {
    final source = AuthRemoteDataSourceImpl(client);
    final emitted = <AuthUserDto?>[];
    final sub = source.watchAuthState().listen(emitted.add);
    await pumpEventQueue();

    await source.verifyOtp(email: 'meera@clinic.example', code: '123456');
    await pumpEventQueue(times: 50);

    final verify = requests.firstWhere((r) => r.url.path == '/auth/v1/verify');
    final body = jsonDecode(verify.body) as Map<String, dynamic>;
    expect(body['token'], '123456');
    expect(body['type'], 'email');

    final profileRequest = requests.firstWhere((r) => r.url.path == '/rest/v1/app_user');
    expect(profileRequest.url.queryParameters['id'], 'eq.$_userId');

    final user = emitted.whereType<AuthUserDto>().last.toEntity();
    expect(user.id, _userId);
    expect(user.workspaceId, 'w1');
    expect(user.plan.name, 'pro');
    await sub.cancel();
  });

  test('a wrong code maps to a ValidationFailure', () async {
    verifyStatus = 403;
    final repository = AuthRepositoryImpl(AuthRemoteDataSourceImpl(client));

    final result = await repository.verifyOtp(email: 'meera@clinic.example', code: '000000');

    expect(result.fold((failure) => failure, (_) => null), isA<ValidationFailure>());
  });
}
