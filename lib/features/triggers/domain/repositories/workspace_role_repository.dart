// Feature: triggers · Layer: domain
// Contract for reading the signed-in user's workspace role. Only Agent
// Triggers needs it (managing a trigger is owner-only), so it lives here and
// not in the auth profile. Implementations never throw.
import 'package:cockpit/core/utils/result.dart';

/// Workspace role access.
abstract interface class WorkspaceRoleRepository {
  /// Whether the signed-in user owns their workspace.
  Result<bool> isWorkspaceOwner();
}
