import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cockpit/features/audit/domain/repositories/audit_repository.dart';
import 'package:cockpit/features/audit/domain/usecases/get_audit_entries.dart';

class _MockAuditRepository extends Mock implements AuditRepository {}

void main() {
  group('GetAuditEntries', () {
    // TODO(feature/audit): verify paging and agent filter are forwarded.
    test('can be constructed with a repository (placeholder)', () {
      expect(GetAuditEntries(_MockAuditRepository()), isA<GetAuditEntries>());
    });
  });
}
