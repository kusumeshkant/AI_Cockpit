// Feature: notifications · Layer: domain
// Use case: stop pushes to this device (before sign-out).
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/notifications/domain/repositories/push_repository.dart';

/// Removes the device's push token for the signed-in user.
@lazySingleton
class UnregisterDevice {
  /// Creates the use case.
  const UnregisterDevice(this._repository);

  final PushRepository _repository;

  /// Unregisters the current token; a no-op success when push is unavailable.
  Result<Unit> call() async {
    if (!_repository.isAvailable) return const Right(unit);
    return _repository.unregisterDevice();
  }
}
