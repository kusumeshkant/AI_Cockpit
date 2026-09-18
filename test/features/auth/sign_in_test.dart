import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/features/auth/domain/repositories/auth_repository.dart';
import 'package:cockpit/features/auth/domain/usecases/sign_in.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('SignIn', () {
    // TODO(feature/auth): stub repository.signIn, assert Right(unit) and
    // verify delegation; add invalid-email Failure case.
    test('can be constructed with a repository (placeholder)', () {
      expect(SignIn(_MockAuthRepository()), isA<SignIn>());
    });
  });
}
