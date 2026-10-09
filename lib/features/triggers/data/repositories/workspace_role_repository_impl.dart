// Feature: triggers · Layer: data
// WorkspaceRoleRepository implementation. Errors map to Failures via `guard`;
// a missing / unknown role reads as "not the owner".
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/triggers/data/datasources/workspace_role_ds.dart';
import 'package:cockpit/features/triggers/domain/repositories/workspace_role_repository.dart';

/// Default [WorkspaceRoleRepository].
@LazySingleton(as: WorkspaceRoleRepository)
class WorkspaceRoleRepositoryImpl implements WorkspaceRoleRepository {
  /// Creates the repository.
  const WorkspaceRoleRepositoryImpl(this._source);

  final WorkspaceRoleDataSource _source;

  @override
  Result<bool> isWorkspaceOwner() => guard(() async => await _source.currentRole() == ownerRole);
}
