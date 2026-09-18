import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/features/connections/domain/repositories/connections_repository.dart';
import 'package:cockpit/features/connections/domain/usecases/list_agents.dart';

class _MockConnectionsRepository extends Mock
    implements ConnectionsRepository {}

void main() {
  group('ListAgents', () {
    // TODO(feature/connections): stub listAgents → Right([...]) and Left(Failure).
    test('can be constructed with a repository (placeholder)', () {
      expect(ListAgents(_MockConnectionsRepository()), isA<ListAgents>());
    });
  });
}
