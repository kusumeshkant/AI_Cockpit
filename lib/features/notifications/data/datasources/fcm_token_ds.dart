// Feature: notifications · Layer: data
// FCM device token + its registration with the backend
// (`rpc/register_fcm_token`, `rpc/unregister_fcm_token`). Firebase is
// optional: until Firebase.initializeApp() succeeded in bootstrap, the token
// side reports unavailable and every call is a no-op.
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/di/environments.dart';

/// Device push token source.
abstract interface class FcmTokenDataSource {
  /// Whether Firebase Messaging is usable (Firebase initialised).
  bool get isAvailable;

  /// Asks for notification permission. `true` when authorised.
  Future<bool> requestPermission();

  /// Current FCM token, or `null` if unavailable.
  Future<String?> getToken();

  /// Emits new tokens when FCM rotates them.
  Stream<String> onTokenRefresh();

  /// Registers [token] for the signed-in user (`rpc/register_fcm_token`).
  Future<void> registerToken(String token);

  /// Removes [token] for the signed-in user (`rpc/unregister_fcm_token`).
  Future<void> unregisterToken(String token);
}

/// Firebase Messaging + Supabase RPC implementation.
@LazySingleton(as: FcmTokenDataSource, env: [AppEnvironments.live])
class FcmTokenDataSourceImpl implements FcmTokenDataSource {
  /// Creates the datasource.
  FcmTokenDataSourceImpl(this._client)
      : _messaging = _defaultMessaging,
        _available = _firebaseReady;

  /// Creates the datasource with a fake messaging instance (tests).
  @visibleForTesting
  FcmTokenDataSourceImpl.test(
    this._client, {
    required FirebaseMessaging Function() messaging,
    required bool Function() available,
  })  : _messaging = messaging,
        _available = available;

  final SupabaseClient _client;
  final FirebaseMessaging Function() _messaging;
  final bool Function() _available;

  static FirebaseMessaging _defaultMessaging() => FirebaseMessaging.instance;
  static bool _firebaseReady() => Firebase.apps.isNotEmpty;

  @override
  bool get isAvailable => _available();

  @override
  Future<bool> requestPermission() async {
    if (!isAvailable) return false;
    final settings = await _messaging().requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken() async => isAvailable ? _messaging().getToken() : null;

  @override
  Stream<String> onTokenRefresh() =>
      isAvailable ? _messaging().onTokenRefresh : const Stream<String>.empty();

  @override
  Future<void> registerToken(String token) =>
      _client.rpc<void>('register_fcm_token', params: {'p_token': token});

  @override
  Future<void> unregisterToken(String token) =>
      _client.rpc<void>('unregister_fcm_token', params: {'p_token': token});
}
