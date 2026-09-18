import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/features/actions/domain/repositories/actions_repository.dart';
import 'package:cockpit/features/actions/domain/usecases/decide_action.dart';

class _MockActionsRepository extends Mock implements ActionsRepository {}

void main() {
  group('DecideAction', () {
    // TODO(feature/actions): verify idempotency key is passed through and that
    // repeated calls with the same key are safe (TR-3).
    test('can be constructed with a repository (placeholder)', () {
      expect(DecideAction(_MockActionsRepository()), isA<DecideAction>());
    });
  });
}
