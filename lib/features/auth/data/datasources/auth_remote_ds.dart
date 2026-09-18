// Feature: auth · Layer: data
// Supabase Auth: email OTP sign-in, sign-out, and the signed-in user's
// profile (app_user + workspace plan, read under RLS). Throws; never returns
// failures.
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/auth/data/models/auth_user_dto.dart';

/// Remote authentication source.
abstract interface class AuthRemoteDataSource {
  /// Sends a sign-in email (one-time code + magic link) to [email].
  Future<void> signIn({required String email});

  /// Verifies the one-time [code] sent to [email] and starts a session.
  Future<void> verifyOtp({required String email, required String code});

  /// Signs out.
  Future<void> signOut();

  /// Emits the current user DTO or `null`.
  Stream<AuthUserDto?> watchAuthState();
}

/// Supabase-backed implementation.
@LazySingleton(as: AuthRemoteDataSource, env: [AppEnvironments.live])
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates the datasource.
  const AuthRemoteDataSourceImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<void> signIn({required String email}) =>
      _client.auth.signInWithOtp(email: email, shouldCreateUser: true);

  @override
  Future<void> verifyOtp({required String email, required String code}) =>
      _client.auth.verifyOTP(email: email, token: code, type: OtpType.email);

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Stream<AuthUserDto?> watchAuthState() => _client.auth.onAuthStateChange
      .map((state) => state.session?.user)
      // Token refreshes re-emit the same user; don't refetch the profile.
      .distinct((previous, next) => previous?.id == next?.id)
      .asyncMap((user) => user == null ? Future.value() : _profile(user));

  Future<AuthUserDto> _profile(User user) async {
    final row = await _client
        .from(DbTables.appUser)
        .select('id, email, workspace_id, workspace:workspace_id(plan)')
        .eq('id', user.id)
        .maybeSingle();
    if (row == null) {
      // Profile not provisioned yet (sign-up trigger) — use the auth user.
      return AuthUserDto(id: user.id, email: user.email ?? '');
    }
    final workspace = row['workspace'];
    return AuthUserDto(
      id: row['id'] as String,
      email: (row['email'] as String?) ?? user.email ?? '',
      displayName: user.userMetadata?['full_name'] as String?,
      workspaceId: row['workspace_id'] as String?,
      plan: workspace is Map ? (workspace['plan'] as String? ?? 'solo') : 'solo',
    );
  }
}
