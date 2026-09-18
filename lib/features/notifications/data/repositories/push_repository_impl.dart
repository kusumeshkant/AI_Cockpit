// Feature: notifications · Layer: data
// PushRepository implementation over the FCM token and message sources.
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/logger.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/notifications/data/datasources/fcm_message_ds.dart';
import 'package:cockpit/features/notifications/data/datasources/fcm_token_ds.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';
import 'package:cockpit/features/notifications/domain/repositories/push_repository.dart';

/// Default [PushRepository].
@LazySingleton(as: PushRepository)
class PushRepositoryImpl implements PushRepository {
  /// Creates the repository.
  const PushRepositoryImpl(this._tokens, this._messages);

  final FcmTokenDataSource _tokens;
  final FcmMessageDataSource _messages;

  @override
  bool get isAvailable => _tokens.isAvailable;

  @override
  Future<bool> requestPermission() async {
    try {
      return await _tokens.requestPermission();
    } catch (error) {
      AppLogger.warning('Notification permission request failed: $error');
      return false;
    }
  }

  @override
  Result<Unit> registerDevice() => guard(() async {
        final token = await _tokens.getToken();
        if (token != null && token.isNotEmpty) await _tokens.registerToken(token);
        return unit;
      });

  @override
  Stream<Either<Failure, Unit>> registerOnTokenRefresh() =>
      _tokens.onTokenRefresh().asyncMap(
            (token) => guard(() async {
              await _tokens.registerToken(token);
              return unit;
            }),
          );

  @override
  Result<Unit> unregisterDevice() => guard(() async {
        final token = await _tokens.getToken();
        if (token != null && token.isNotEmpty) await _tokens.unregisterToken(token);
        return unit;
      });

  @override
  Stream<PushMessage> foregroundMessages() => _messages.onMessage();

  @override
  Stream<PushMessage> openedMessages() async* {
    PushMessage? initial;
    try {
      initial = await _messages.initialMessage();
    } catch (error) {
      AppLogger.warning('Reading the launch notification failed: $error');
    }
    if (initial != null) yield initial;
    yield* _messages.onMessageOpenedApp();
  }
}
