// Feature: audit · Layer: domain
// Use case: page through the audit log.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';
import 'package:cockpit/features/audit/domain/repositories/audit_repository.dart';

/// Loads audit entries.
@lazySingleton
class GetAuditEntries {
  /// Creates the use case.
  const GetAuditEntries(this._repository);

  final AuditRepository _repository;

  /// Returns page [page] of entries, optionally filtered by [agentId].
  Result<List<AuditEntry>> call({String? agentId, int page = 0}) =>
      _repository.getAuditEntries(agentId: agentId, page: page);
}
