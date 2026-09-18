// Feature: auth · Layer: domain
// Use case: request a sign-in (magic link) for an email address.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';

/// Starts sign-in for an email address.
@lazySingleton
class SignIn {
  /// Creates the use case.
  const SignIn(this._repository);

  final AuthRepository _repository;

  /// Requests a magic link for [email].
  Result<Unit> call({required String email}) {
    // TODO(feature/auth): validate email format and return a validation Failure.
    return _repository.signIn(email: email);
  }
}
