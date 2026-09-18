// Feature: auth · Layer: domain
// Use case: observe the authentication state (drives router redirects).
import 'package:injectable/injectable.dart';

import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';

/// Streams the signed-in user (or `null`).
@lazySingleton
class WatchAuthState {
  /// Creates the use case.
  const WatchAuthState(this._repository);

  final AuthRepository _repository;

  /// Emits auth state changes.
  Stream<AuthUser?> call() => _repository.watchAuthState();
}
