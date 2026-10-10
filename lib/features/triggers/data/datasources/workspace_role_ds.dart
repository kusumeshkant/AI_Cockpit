// Feature: triggers · Layer: data
// The signed-in user's workspace role (`app_user.role`, readable under RLS).
// Kept out of the auth profile query on purpose: read by Agent Triggers
// (flag on) and by Connections (owner-only agent management). Demo mode is
// the owner.
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';

/// Source of the signed-in user's role.
abstract interface class WorkspaceRoleDataSource {
  /// The role (`owner` / `approver`), or `null` when signed out or unknown.
  Future<String?> currentRole();
}

/// Role value of the workspace owner.
const String ownerRole = 'owner';

/// Supabase implementation.
@LazySingleton(as: WorkspaceRoleDataSource, env: [AppEnvironments.live])
class WorkspaceRoleDataSourceImpl implements WorkspaceRoleDataSource {
  /// Creates the datasource.
  const WorkspaceRoleDataSourceImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<String?> currentRole() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    final row = await _client
        .from(DbTables.appUser)
        .select('role')
        .eq('id', userId)
        .maybeSingle();
    return row?['role'] as String?;
  }
}

/// Demo implementation: the demo user owns the demo workspace.
@LazySingleton(as: WorkspaceRoleDataSource, env: [AppEnvironments.demo])
class WorkspaceRoleDemoDataSource implements WorkspaceRoleDataSource {
  /// Creates the datasource.
  const WorkspaceRoleDemoDataSource();

  @override
  Future<String?> currentRole() async => ownerRole;
}
