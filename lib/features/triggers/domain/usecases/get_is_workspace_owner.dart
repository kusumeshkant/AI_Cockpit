// Feature: triggers · Layer: domain
// Use case: is the signed-in user the workspace owner (may manage triggers)?
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/triggers/domain/repositories/workspace_role_repository.dart';

/// Reads whether the signed-in user owns the workspace.
@lazySingleton
class GetIsWorkspaceOwner {
  /// Creates the use case.
  const GetIsWorkspaceOwner(this._repository);

  final WorkspaceRoleRepository _repository;

  /// `true` only for the workspace owner.
  Result<bool> call() => _repository.isWorkspaceOwner();
}
