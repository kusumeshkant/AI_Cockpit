// SignIn validates the address in the domain (F27) before calling the backend.
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';
import 'package:cockpit/features/auth/domain/usecases/sign_in.dart';
import 'package:cockpit/features/auth/domain/value_objects/email_address.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() {
    repository = _MockAuthRepository();
    when(() => repository.signIn(email: any(named: 'email')))
        .thenAnswer((_) async => const Right(unit));
  });

  test('a valid address is trimmed and sent', () async {
    final result = await SignIn(repository)(email: '  meera@clinic.example ');

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => repository.signIn(email: 'meera@clinic.example')).called(1);
  });

  test('an invalid address is a ValidationFailure and never reaches the backend', () async {
    for (final email in ['', 'not-an-email', 'a@b', 'a b@c.example', '@clinic.example']) {
      final result = await SignIn(repository)(email: email);
      expect(result.fold((failure) => failure, (_) => null), isA<ValidationFailure>(), reason: email);
    }
    verifyNever(() => repository.signIn(email: any(named: 'email')));
  });

  test('the rule is shared with the screen', () {
    expect(EmailAddress.isValid('meera@clinic.example'), isTrue);
    expect(EmailAddress.isValid('meera@clinic'), isFalse);
  });
}
