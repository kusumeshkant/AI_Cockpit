// Feature: triggers · Layer: domain
// Contract for reading the signed-in user's workspace role. Agent Triggers
// (managing a trigger) and Connections (connecting an agent) are owner-only;
// it stays out of the auth profile. Implementations never throw.
import 'package:cockpit/core/utils/result.dart';

/// Workspace role access.
abstract interface class WorkspaceRoleRepository {
  /// Whether the signed-in user owns their workspace.
  Result<bool> isWorkspaceOwner();
}
