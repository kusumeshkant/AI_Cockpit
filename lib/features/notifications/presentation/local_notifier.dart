// Feature: notifications · Layer: presentation
// Shows pushes that arrive while the app is open (FCM doesn't display those on
// Android) through flutter_local_notifications, on the same `actions_high`
// channel the backend targets, and reports taps.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';

/// Localized texts for the notification channel (Android settings).
class NotificationChannelText {
  /// Creates the texts.
  const NotificationChannelText({required this.name, required this.description});

  /// Channel name.
  final String name;

  /// Channel description.
  final String description;
}

/// Displays local notifications and reports taps.
abstract interface class LocalNotifier {
  /// Sets up the channel and tap handling. If a local notification launched
  /// the app, [onTap] is called for it.
  Future<void> initialize({
    required NotificationChannelText channel,
    required void Function(PushMessage message) onTap,
  });

  /// Shows [message] as a heads-up notification.
  Future<void> show(PushMessage message);
}

/// flutter_local_notifications implementation.
@LazySingleton(as: LocalNotifier, env: [AppEnvironments.live])
class FlutterLocalNotifier implements LocalNotifier {
  /// Creates the notifier.
  FlutterLocalNotifier() : _plugin = FlutterLocalNotificationsPlugin();

  /// Android channel id. Must match `channel_id` in the backend's
  /// `_shared/fcm.ts` and the default channel in AndroidManifest.xml.
  static const String channelId = 'actions_high';

  final FlutterLocalNotificationsPlugin _plugin;
  NotificationChannelText? _channel;
  int _nextId = 0;

  @override
  Future<void> initialize({
    required NotificationChannelText channel,
    required void Function(PushMessage message) onTap,
  }) async {
    _channel = channel;
    void handle(NotificationResponse response) {
      final message = decodePayload(response.payload);
      if (message != null) onTap(message);
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // FCM asks for permission; don't prompt twice.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: handle,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          AndroidNotificationChannel(
            channelId,
            channel.name,
            description: channel.description,
            importance: Importance.high,
          ),
        );

    final launch = await _plugin.getNotificationAppLaunchDetails();
    final response = launch?.notificationResponse;
    if ((launch?.didNotificationLaunchApp ?? false) && response != null) handle(response);
  }

  @override
  Future<void> show(PushMessage message) async {
    final channel = _channel;
    if (channel == null) return;
    await _plugin.show(
      id: _nextId++,
      title: message.title,
      body: message.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Rebuilds a message from a local notification payload (its data map).
  @visibleForTesting
  static PushMessage? decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? PushMessage.fromData(decoded) : null;
    } on FormatException {
      return null;
    }
  }
}

/// Demo mode: nothing to show.
@LazySingleton(as: LocalNotifier, env: [AppEnvironments.demo])
class NoopLocalNotifier implements LocalNotifier {
  /// Creates the notifier.
  const NoopLocalNotifier();

  @override
  Future<void> initialize({
    required NotificationChannelText channel,
    required void Function(PushMessage message) onTap,
  }) async {}

  @override
  Future<void> show(PushMessage message) async {}
}
