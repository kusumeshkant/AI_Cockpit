// Feature: notifications · Layer: domain
// Push contract. Push is a hint, never the source of truth: every method is
// safe to call when push isn't configured (no Firebase) and then does nothing.
import 'package:dartz/dartz.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';

/// Device registration and incoming push messages.
abstract interface class PushRepository {
  /// Whether push is configured on this build / device.
  bool get isAvailable;

  /// Asks the OS for notification permission. `true` when granted.
  Future<bool> requestPermission();

  /// Registers this device's current token for the signed-in user. Succeeds
  /// without doing anything when there is no token (push unavailable,
  /// permission denied).
  Result<Unit> registerDevice();

  /// Re-registers whenever FCM rotates the token; emits each outcome.
  Stream<Either<Failure, Unit>> registerOnTokenRefresh();

  /// Removes this device's token for the signed-in user (before sign-out).
  Result<Unit> unregisterDevice();

  /// Messages received while the app is in the foreground.
  Stream<PushMessage> foregroundMessages();

  /// Notifications the user tapped: the one that launched the app (if any)
  /// first, then taps while the app was in the background.
  Stream<PushMessage> openedMessages();
}
