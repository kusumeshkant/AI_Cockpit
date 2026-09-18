// Feature: notifications · Layer: data
// Incoming FCM messages: foreground deliveries, taps from the background and
// the tap that launched the app. Empty when Firebase isn't initialised.
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';

/// Source of push messages.
abstract interface class FcmMessageDataSource {
  /// Messages received while the app is in the foreground.
  Stream<PushMessage> onMessage();

  /// Notifications tapped while the app was in the background.
  Stream<PushMessage> onMessageOpenedApp();

  /// The notification that launched the app from terminated, if any.
  Future<PushMessage?> initialMessage();
}

/// Firebase Messaging implementation.
@LazySingleton(as: FcmMessageDataSource, env: [AppEnvironments.live])
class FcmMessageDataSourceImpl implements FcmMessageDataSource {
  /// Creates the datasource.
  const FcmMessageDataSourceImpl();

  bool get _available => Firebase.apps.isNotEmpty;

  @override
  Stream<PushMessage> onMessage() => _available
      ? FirebaseMessaging.onMessage.map(fromRemote)
      : const Stream<PushMessage>.empty();

  @override
  Stream<PushMessage> onMessageOpenedApp() => _available
      ? FirebaseMessaging.onMessageOpenedApp.map(fromRemote)
      : const Stream<PushMessage>.empty();

  @override
  Future<PushMessage?> initialMessage() async {
    if (!_available) return null;
    final message = await FirebaseMessaging.instance.getInitialMessage();
    return message == null ? null : fromRemote(message);
  }

  /// Maps an FCM [RemoteMessage] to a [PushMessage].
  @visibleForTesting
  static PushMessage fromRemote(RemoteMessage message) => PushMessage.fromData(
        message.data,
        title: message.notification?.title,
        body: message.notification?.body,
      );
}
