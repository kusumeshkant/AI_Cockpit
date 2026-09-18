// Feature: auth · Layer: domain
// Use case: sign the current user out. The device's push token is removed
// first, while the session can still authorise the RPC; that step is best
// effort and never blocks signing out.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';
import 'package:cockpit/features/notifications/domain/usecases/unregister_device.dart';

/// Signs the current user out.
@lazySingleton
class SignOut {
  /// Creates the use case.
  const SignOut(this._repository, this._unregisterDevice);

  final AuthRepository _repository;
  final UnregisterDevice _unregisterDevice;

  /// Stops pushes to this device, then signs out.
  Result<Unit> call() async {
    await _unregisterDevice();
    return _repository.signOut();
  }
}
