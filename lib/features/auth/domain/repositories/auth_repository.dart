// Feature: auth · Layer: domain
// Authentication contract, implemented in the data layer.
import 'package:dartz/dartz.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';

/// Authentication operations.
abstract interface class AuthRepository {
  /// Starts sign-in for [email]: sends an email with a one-time code / link.
  Result<Unit> signIn({required String email});

  /// Completes sign-in with the one-time [code] emailed to [email].
  Result<Unit> verifyOtp({required String email, required String code});

  /// Signs the current user out and clears the session.
  Result<Unit> signOut();

  /// Emits the current user, or `null` when signed out.
  Stream<AuthUser?> watchAuthState();
}
