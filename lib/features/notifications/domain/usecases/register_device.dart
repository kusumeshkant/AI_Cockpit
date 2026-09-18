// Feature: notifications · Layer: domain
// Use case: register this device for push (FCM token → register_fcm_token).
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/notifications/domain/repositories/push_repository.dart';

/// Registers the device's push token for the signed-in user.
@lazySingleton
class RegisterDevice {
  /// Creates the use case.
  const RegisterDevice(this._repository);

  final PushRepository _repository;

  /// Registers the current token; a no-op success when push is unavailable.
  Result<Unit> call() async {
    if (!_repository.isAvailable) return const Right(unit);
    return _repository.registerDevice();
  }
}
