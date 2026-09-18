import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/notifications/data/datasources/fcm_message_ds.dart';
import 'package:cockpit/features/notifications/data/datasources/fcm_token_ds.dart';
import 'package:cockpit/features/notifications/data/repositories/push_repository_impl.dart';
import 'package:cockpit/features/notifications/domain/entities/push_message.dart';

class _MockTokens extends Mock implements FcmTokenDataSource {}

class _MockMessages extends Mock implements FcmMessageDataSource {}

void main() {
  late _MockTokens tokens;
  late _MockMessages messages;
  late PushRepositoryImpl repository;

  setUp(() {
    tokens = _MockTokens();
    messages = _MockMessages();
    repository = PushRepositoryImpl(tokens, messages);
    when(() => tokens.registerToken(any())).thenAnswer((_) async {});
    when(() => tokens.unregisterToken(any())).thenAnswer((_) async {});
  });

  group('registerDevice', () {
    test('registers the current FCM token', () async {
      when(() => tokens.getToken()).thenAnswer((_) async => 'device-token-1');

      expect(await repository.registerDevice(), const Right<Failure, Unit>(unit));
      verify(() => tokens.registerToken('device-token-1')).called(1);
    });

    test('is a successful no-op without a token', () async {
      when(() => tokens.getToken()).thenAnswer((_) async => null);

      expect(await repository.registerDevice(), const Right<Failure, Unit>(unit));
      verifyNever(() => tokens.registerToken(any()));
    });

    test('maps an RPC error to a Failure', () async {
      when(() => tokens.getToken()).thenAnswer((_) async => 'device-token-1');
      when(() => tokens.registerToken(any()))
          .thenThrow(const PostgrestException(message: 'JWT expired', code: 'PGRST301'));

      final result = await repository.registerDevice();
      expect(result.fold((failure) => failure, (_) => null), isA<AuthFailure>());
    });
  });

  test('registerOnTokenRefresh registers every rotated token', () async {
    when(() => tokens.onTokenRefresh()).thenAnswer((_) => Stream.fromIterable(['t2', 't3']));

    final results = await repository.registerOnTokenRefresh().toList();

    expect(results, everyElement(const Right<Failure, Unit>(unit)));
    verifyInOrder([
      () => tokens.registerToken('t2'),
      () => tokens.registerToken('t3'),
    ]);
  });

  test('unregisterDevice removes the current token', () async {
    when(() => tokens.getToken()).thenAnswer((_) async => 'device-token-1');

    expect(await repository.unregisterDevice(), const Right<Failure, Unit>(unit));
    verify(() => tokens.unregisterToken('device-token-1')).called(1);
  });

  test('openedMessages emits the launch notification first, then taps', () async {
    const launch = PushMessage(data: {'type': 'action', 'action_id': 'launch'});
    const tap = PushMessage(data: {'type': 'action', 'action_id': 'tap'});
    when(() => messages.initialMessage()).thenAnswer((_) async => launch);
    when(() => messages.onMessageOpenedApp()).thenAnswer((_) => Stream.value(tap));

    expect(await repository.openedMessages().toList(), [launch, tap]);
  });

  test('openedMessages survives a failing launch lookup', () async {
    const tap = PushMessage(data: {'type': 'action', 'action_id': 'tap'});
    when(() => messages.initialMessage()).thenThrow(StateError('no firebase'));
    when(() => messages.onMessageOpenedApp()).thenAnswer((_) => Stream.value(tap));

    expect(await repository.openedMessages().toList(), [tap]);
  });

  test('isAvailable follows the token source', () {
    when(() => tokens.isAvailable).thenReturn(false);
    expect(repository.isAvailable, isFalse);
  });
}
