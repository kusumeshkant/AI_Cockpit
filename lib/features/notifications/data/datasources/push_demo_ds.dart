// Feature: notifications · Layer: data
// Demo mode (no backend): push is unavailable, everything is a no-op.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/notifications/data/datasources/fcm_message_ds.dart';
import 'package:cockpit/features/notifications/data/datasources/fcm_token_ds.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';

/// No-op token source for demo mode.
@LazySingleton(as: FcmTokenDataSource, env: [AppEnvironments.demo])
class FcmTokenDemoDataSource implements FcmTokenDataSource {
  /// Creates the datasource.
  const FcmTokenDemoDataSource();

  @override
  bool get isAvailable => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<String> onTokenRefresh() => const Stream<String>.empty();

  @override
  Future<void> registerToken(String token) async {}

  @override
  Future<void> unregisterToken(String token) async {}
}

/// No-op message source for demo mode.
@LazySingleton(as: FcmMessageDataSource, env: [AppEnvironments.demo])
class FcmMessageDemoDataSource implements FcmMessageDataSource {
  /// Creates the datasource.
  const FcmMessageDemoDataSource();

  @override
  Stream<PushMessage> onMessage() => const Stream<PushMessage>.empty();

  @override
  Stream<PushMessage> onMessageOpenedApp() => const Stream<PushMessage>.empty();

  @override
  Future<PushMessage?> initialMessage() async => null;
}
