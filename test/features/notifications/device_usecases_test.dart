import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';
import 'package:cockpit/features/auth/domain/usecases/sign_out.dart';
import 'package:cockpit/features/notifications/domain/repositories/push_repository.dart';
import 'package:cockpit/features/notifications/domain/usecases/register_device.dart';
import 'package:cockpit/features/notifications/domain/usecases/unregister_device.dart';

class _MockPushRepository extends Mock implements PushRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockPushRepository push;

  setUp(() {
    push = _MockPushRepository();
    when(() => push.isAvailable).thenReturn(true);
    when(() => push.registerDevice()).thenAnswer((_) async => const Right(unit));
    when(() => push.unregisterDevice()).thenAnswer((_) async => const Right(unit));
  });

  group('RegisterDevice', () {
    test('delegates to the repository', () async {
      expect(await RegisterDevice(push)(), const Right<Failure, Unit>(unit));
      verify(() => push.registerDevice()).called(1);
    });

    test('is a no-op success when push is unavailable', () async {
      when(() => push.isAvailable).thenReturn(false);
      expect(await RegisterDevice(push)(), const Right<Failure, Unit>(unit));
      verifyNever(() => push.registerDevice());
    });
  });

  group('UnregisterDevice', () {
    test('delegates to the repository', () async {
      expect(await UnregisterDevice(push)(), const Right<Failure, Unit>(unit));
      verify(() => push.unregisterDevice()).called(1);
    });

    test('is a no-op success when push is unavailable', () async {
      when(() => push.isAvailable).thenReturn(false);
      await UnregisterDevice(push)();
      verifyNever(() => push.unregisterDevice());
    });
  });

  group('SignOut', () {
    late _MockAuthRepository auth;

    setUp(() {
      auth = _MockAuthRepository();
      when(() => auth.signOut()).thenAnswer((_) async => const Right(unit));
    });

    test('removes the push token before ending the session', () async {
      expect(await SignOut(auth, UnregisterDevice(push))(), const Right<Failure, Unit>(unit));
      verifyInOrder([
        () => push.unregisterDevice(),
        () => auth.signOut(),
      ]);
    });

    test('still signs out when token removal fails', () async {
      when(() => push.unregisterDevice()).thenAnswer((_) async => const Left(NetworkFailure()));

      expect(await SignOut(auth, UnregisterDevice(push))(), const Right<Failure, Unit>(unit));
      verify(() => auth.signOut()).called(1);
    });
  });
}
