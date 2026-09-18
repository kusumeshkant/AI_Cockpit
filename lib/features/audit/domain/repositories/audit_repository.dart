// Feature: audit · Layer: domain
// Read-only contract for the audit trail (the app never writes audit rows).
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';

/// Audit log access.
abstract interface class AuditRepository {
  /// Returns a page of entries, newest first, optionally for one [agentId].
  Result<List<AuditEntry>> getAuditEntries({
    String? agentId,
    int page = 0,
    int pageSize = 50,
  });
}
