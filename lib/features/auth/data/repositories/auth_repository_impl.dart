// Feature: auth · Layer: data
// AuthRepository implementation: delegates to the datasource and maps
// exceptions to failures via `guard`.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/utils/logger.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';

/// Default [AuthRepository].
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  /// Creates the repository.
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Result<Unit> signIn({required String email}) => guard(() async {
        await _remote.signIn(email: email);
        return unit;
      });

  @override
  Result<Unit> verifyOtp({required String email, required String code}) =>
      guard(() async {
        await _remote.verifyOtp(email: email, code: code);
        return unit;
      });

  @override
  Result<Unit> signOut() => guard(() async {
        await _remote.signOut();
        return unit;
      });

  @override
  Stream<AuthUser?> watchAuthState() => _remote
      .watchAuthState()
      .map((dto) => dto?.toEntity())
      .handleError((Object error, StackTrace stack) {
        // A broken auth stream must not crash the app; treat as signed out.
        AppLogger.error('Auth state stream failed', mapError(error, stack));
      });
}
