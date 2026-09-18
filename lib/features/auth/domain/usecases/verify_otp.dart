// Feature: auth · Layer: domain
// Use case: complete sign-in with the one-time code from the sign-in email.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';

/// Verifies an email OTP code.
@lazySingleton
class VerifyOtp {
  /// Creates the use case.
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  static final RegExp _code = RegExp(r'^\d{6}$');

  /// Verifies [code] for [email]. Malformed codes fail without a request.
  Result<Unit> call({required String email, required String code}) async {
    final trimmed = code.trim();
    if (!_code.hasMatch(trimmed)) {
      return const Left(ValidationFailure('otp_format'));
    }
    return _repository.verifyOtp(email: email.trim(), code: trimmed);
  }
}
