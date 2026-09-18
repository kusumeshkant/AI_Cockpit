// Feature: auth · Layer: data
// In-memory demo auth source (AppEnvironments.demo): starts signed in as a
// demo user so the app can be reviewed without a backend.
import 'dart:async';

import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:cockpit/features/auth/data/models/auth_user_dto.dart';

/// Demo implementation of [AuthRemoteDataSource].
@LazySingleton(as: AuthRemoteDataSource, env: [AppEnvironments.demo])
class AuthDemoDataSource implements AuthRemoteDataSource {
  /// Creates the datasource, signed in as the demo user.
  AuthDemoDataSource();

  static const AuthUserDto _demoUser = AuthUserDto(
    id: 'demo-user',
    email: 'you@company.com',
    displayName: 'Demo user',
    workspaceId: 'demo-workspace',
  );

  final StreamController<AuthUserDto?> _changes =
      StreamController<AuthUserDto?>.broadcast();
  AuthUserDto? _current = _demoUser;

  @override
  Future<void> signIn({required String email}) async {
    _current = _demoUser.copyWith(email: email);
    _changes.add(_current);
  }

  @override
  Future<void> verifyOtp({required String email, required String code}) =>
      signIn(email: email);

  @override
  Future<void> signOut() async {
    _current = null;
    _changes.add(null);
  }

  @override
  Stream<AuthUserDto?> watchAuthState() async* {
    yield _current;
    yield* _changes.stream;
  }
}
