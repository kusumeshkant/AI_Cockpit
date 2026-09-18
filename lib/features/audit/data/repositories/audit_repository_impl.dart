// Feature: audit · Layer: data
// AuditRepository implementation.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/audit/data/datasources/audit_remote_ds.dart';
import 'package:cockpit/features/audit/domain/entities/audit_entry.dart';
import 'package:cockpit/features/audit/domain/repositories/audit_repository.dart';

/// Default [AuditRepository].
@LazySingleton(as: AuditRepository)
class AuditRepositoryImpl implements AuditRepository {
  /// Creates the repository.
  const AuditRepositoryImpl(this._remote);

  final AuditRemoteDataSource _remote;

  @override
  Result<List<AuditEntry>> getAuditEntries({
    String? agentId,
    int page = 0,
    int pageSize = 50,
  }) =>
      guard(() async {
        final dtos = await _remote.fetchEntries(
          offset: page * pageSize,
          limit: pageSize,
          agentId: agentId,
        );
        return dtos.map((dto) => dto.toEntity()).toList(growable: false);
      });
}
