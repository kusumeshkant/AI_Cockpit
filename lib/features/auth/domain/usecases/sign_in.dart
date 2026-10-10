// Feature: auth · Layer: domain
// Use case: request a sign-in code for an email address. An invalid address
// is a ValidationFailure and never reaches the backend.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';
import 'package:cockpit/features/auth/domain/value_objects/email_address.dart';

/// Starts sign-in for an email address.
@lazySingleton
class SignIn {
  /// Creates the use case.
  const SignIn(this._repository);

  final AuthRepository _repository;

  /// Requests a sign-in code for [email].
  Result<Unit> call({required String email}) async {
    if (!EmailAddress.isValid(email)) {
      return const Left(ValidationFailure('invalid_email'));
    }
    return _repository.signIn(email: EmailAddress.normalize(email));
  }
}
