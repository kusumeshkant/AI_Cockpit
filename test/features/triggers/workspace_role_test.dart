import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/triggers/data/datasources/workspace_role_ds.dart';
import 'package:cockpit/features/triggers/data/repositories/workspace_role_repository_impl.dart';
import 'package:cockpit/features/triggers/domain/repositories/workspace_role_repository.dart';
import 'package:cockpit/features/triggers/domain/usecases/get_is_workspace_owner.dart';

import '../../helpers/live_fakes.dart';

class _MockRoleRepository extends Mock implements WorkspaceRoleRepository {}

class _FakeRoleSource implements WorkspaceRoleDataSource {
  _FakeRoleSource(this._role, {this.error});

  final String? _role;
  final Object? error;

  @override
  Future<String?> currentRole() async {
    if (error case final error?) throw error;
    return _role;
  }
}

const _userId = '22222222-2222-4222-8222-222222222222';

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
        'email': 'owner@clinic.example',
        'created_at': '2026-09-15T06:00:00Z',
        'app_metadata': {'provider': 'email'},
        'user_metadata': <String, dynamic>{},
      },
    };

void main() {
  test('GetIsWorkspaceOwner delegates to the repository', () async {
    final repository = _MockRoleRepository();
    when(repository.isWorkspaceOwner).thenAnswer((_) async => const Right(true));

    expect(await GetIsWorkspaceOwner(repository)(), const Right<Failure, bool>(true));
    verify(repository.isWorkspaceOwner).called(1);
  });

  group('WorkspaceRoleRepositoryImpl', () {
    Future<Either<Failure, bool>> owner(_FakeRoleSource source) =>
        WorkspaceRoleRepositoryImpl(source).isWorkspaceOwner();

    test('owner → true', () async {
      expect(await owner(_FakeRoleSource('owner')), const Right<Failure, bool>(true));
    });

    test('approver or missing role → false', () async {
      expect(await owner(_FakeRoleSource('approver')), const Right<Failure, bool>(false));
      expect(await owner(_FakeRoleSource(null)), const Right<Failure, bool>(false));
    });

    test('a read error comes back as a Failure (never thrown)', () async {
      final result = await owner(_FakeRoleSource(null, error: const SocketLikeError()));
      expect(result.isLeft(), isTrue);
    });
  });

  group('WorkspaceRoleDataSourceImpl', () {
    late List<Recorded> requests;
    late SupabaseClient client;

    setUp(() {
      requests = [];
      client = fakeSupabase((request) {
        if (request.url.path == '/auth/v1/verify') return jsonResponse(_session());
        if (request.url.path == '/rest/v1/app_user') return jsonResponse({'role': 'owner'});
        return jsonResponse({'message': 'unexpected'}, status: 404);
      }, requests);
    });

    tearDown(() => client.dispose());

    test('signed out → null, without a query', () async {
      expect(await WorkspaceRoleDataSourceImpl(client).currentRole(), isNull);
      expect(requests.where((r) => r.url.path == '/rest/v1/app_user'), isEmpty);
    });

    test("reads only the signed-in user's role column", () async {
      await client.auth.verifyOTP(email: 'owner@clinic.example', token: '123456', type: OtpType.email);

      expect(await WorkspaceRoleDataSourceImpl(client).currentRole(), 'owner');
      final uri = requests.lastWhere((r) => r.url.path == '/rest/v1/app_user').url;
      expect(uri.queryParameters['select'], 'role');
      expect(uri.queryParameters['id'], 'eq.$_userId');
      expect(jsonEncode(uri.queryParameters), isNot(contains('workspace')));
    });
  });

  test('demo user is the owner', () async {
    expect(await const WorkspaceRoleDemoDataSource().currentRole(), ownerRole);
  });
}

/// Any non-Failure error a datasource may throw.
class SocketLikeError implements Exception {
  /// Creates the error.
  const SocketLikeError();
}
