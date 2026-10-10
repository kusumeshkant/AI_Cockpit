// DeleteAccount delegates to the repository and passes failures through.
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/data/datasources/auth_demo_ds.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';
import 'package:cockpit/features/auth/domain/usecases/delete_account.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() => repository = _MockAuthRepository());

  test('deletes through the repository', () async {
    when(() => repository.deleteAccount()).thenAnswer((_) async => const Right(unit));

    final result = await DeleteAccount(repository)();

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => repository.deleteAccount()).called(1);
  });

  test('returns the repository failure (so the screen can offer a retry)', () async {
    when(() => repository.deleteAccount()).thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await DeleteAccount(repository)();

    expect(result.fold((failure) => failure, (_) => null), isA<NetworkFailure>());
  });

  test('demo mode: deleting clears the demo session', () async {
    final demo = AuthDemoDataSource();
    final emitted = <Object?>[];
    final sub = demo.watchAuthState().listen(emitted.add);
    await pumpEventQueue();

    await demo.deleteAccount();
    await pumpEventQueue();

    expect(emitted.first, isNotNull);
    expect(emitted.last, isNull);
    await sub.cancel();
  });
}
