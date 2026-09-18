// Feature: notifications · Layer: presentation
// Push orchestration for a signed-in session: permission, token registration
// (and re-registration on rotation), foreground display via LocalNotifier,
// and tapped notifications handed to the caller (PushRouter). Best effort:
// with push unavailable, start() does nothing and the app relies on
// Realtime + poll (TR-4).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/utils/logger.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';
import 'package:cockpit/features/notifications/domain/repositories/push_repository.dart';
import 'package:cockpit/features/notifications/domain/usecases/register_device.dart';
import 'package:cockpit/features/notifications/presentation/local_notifier.dart';

/// Signature for handling a tapped notification.
typedef PushOpenHandler = void Function(PushMessage message);

/// Push notification orchestration.
@lazySingleton
class NotificationService {
  /// Creates the service.
  NotificationService(this._repository, this._registerDevice, this._notifier);

  final PushRepository _repository;
  final RegisterDevice _registerDevice;
  final LocalNotifier _notifier;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  bool _running = false;

  /// Whether a session is being served.
  bool get isRunning => _running;

  /// Starts push for the signed-in user. Idempotent; a no-op when push is
  /// unavailable.
  Future<void> start({
    required NotificationChannelText channel,
    required PushOpenHandler onOpen,
  }) async {
    if (_running || !_repository.isAvailable) return;
    _running = true;

    await _notifier.initialize(channel: channel, onTap: onOpen);
    await _repository.requestPermission();
    (await _registerDevice()).fold(
      (failure) => AppLogger.warning('Push token registration failed: $failure'),
      (_) {},
    );
    if (!_running) return; // stopped while starting

    _subscriptions
      ..add(
        _repository.registerOnTokenRefresh().listen(
              (result) => result.fold(
                (failure) => AppLogger.warning('Push token re-registration failed: $failure'),
                (_) {},
              ),
            ),
      )
      ..add(_repository.foregroundMessages().listen((message) => unawaited(_notifier.show(message))))
      ..add(_repository.openedMessages().listen(onOpen));
  }

  /// Stops listening (after sign-out). Token removal happens in SignOut,
  /// while the session is still valid.
  Future<void> stop() async {
    _running = false;
    final subscriptions = List.of(_subscriptions);
    _subscriptions.clear();
    for (final subscription in subscriptions) {
      await subscription.cancel();
    }
  }
}

/// The app's [NotificationService] (overridable in tests).
final notificationServiceProvider =
    Provider<NotificationService>((ref) => getIt<NotificationService>());
