// Feature: auth · Layer: domain
// Use case: permanently delete the signed-in user's account (F02). The
// backend removes the data and every session (and this device's push
// tokens); the local session is cleared afterwards. Retrying after a failure
// is safe.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';

/// Deletes the current user's account.
@lazySingleton
class DeleteAccount {
  /// Creates the use case.
  const DeleteAccount(this._repository);

  final AuthRepository _repository;

  /// Deletes the account and ends the session.
  Result<Unit> call() => _repository.deleteAccount();
}
