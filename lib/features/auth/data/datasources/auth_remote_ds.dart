// Feature: auth · Layer: data
// Supabase Auth: email OTP sign-in, sign-out, account deletion, and the
// signed-in user's profile (app_user + workspace plan, read under RLS).
// A failed code is retried once against `reviewer-signin`, which only ever
// accepts the Play review account while it's switched on server-side.
// Throws; never returns failures.
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/core/utils/logger.dart';
import 'package:cockpit/features/auth/data/models/auth_user_dto.dart';

/// Remote authentication source.
abstract interface class AuthRemoteDataSource {
  /// Sends a sign-in email (one-time code + magic link) to [email].
  Future<void> signIn({required String email});

  /// Verifies the one-time [code] sent to [email] and starts a session.
  Future<void> verifyOtp({required String email, required String code});

  /// Signs out.
  Future<void> signOut();

  /// Deletes the signed-in user's account on the server, then ends the local
  /// session. Safe to call again after a failure (the backend is idempotent).
  Future<void> deleteAccount();

  /// Emits the current user DTO or `null`.
  Stream<AuthUserDto?> watchAuthState();
}

/// Supabase-backed implementation.
@LazySingleton(as: AuthRemoteDataSource, env: [AppEnvironments.live])
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates the datasource.
  const AuthRemoteDataSourceImpl(this._client, this._functions);

  final SupabaseClient _client;
  final DioClient _functions;

  @override
  Future<void> signIn({required String email}) =>
      _client.auth.signInWithOtp(email: email, shouldCreateUser: true);

  @override
  Future<void> verifyOtp({required String email, required String code}) async {
    try {
      await _client.auth.verifyOTP(email: email, token: code, type: OtpType.email);
    } on AuthException catch (error) {
      // Offline: the fallback can't help, so don't add a second wait.
      if (error is AuthRetryableFetchException) rethrow;
      final tokenHash = await _reviewerTokenHash(email, code);
      // Not the review account (the usual case): the user sees the original
      // OTP error, after exactly one extra request.
      if (tokenHash == null) rethrow;
      await _client.auth.verifyOTP(tokenHash: tokenHash, type: OtpType.email);
    }
  }

  /// Play review sign-in (backend `reviewer-signin`): a one-time token hash
  /// when [email] / [code] are the review account's and the server has it
  /// switched on; otherwise `null`. Any refusal or error counts as `null`.
  Future<String?> _reviewerTokenHash(String email, String code) async {
    try {
      final data = await _functions.postFunction(
        ApiEndpoints.reviewerSignin,
        {'email': email, 'code': code},
      );
      final tokenHash = data['token_hash'];
      return tokenHash is String && tokenHash.isNotEmpty ? tokenHash : null;
    } on Exception {
      return null;
    }
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<void> deleteAccount() async {
    await _functions.postFunction(ApiEndpoints.accountDelete, {'confirm': true});
    // The server already revoked every session; only clear this device's.
    await _client.auth.signOut(scope: SignOutScope.local);
  }

  @override
  Stream<AuthUserDto?> watchAuthState() => _client.auth.onAuthStateChange
      .map((state) => state.session?.user)
      // Token refreshes re-emit the same user; don't refetch the profile.
      .distinct((previous, next) => previous?.id == next?.id)
      .asyncMap((user) => user == null ? Future.value() : _profile(user));

  /// The profile of the signed-in [user]. Never throws: the session is valid
  /// either way, and a thrown read would leave the auth stream silent, so the
  /// router would keep a signed-in user on sign-in (and the retry would send
  /// the used code again: "wrong or expired").
  Future<AuthUserDto> _profile(User user) async {
    final Map<String, dynamic>? row;
    try {
      row = await _client
          .from(DbTables.appUser)
          .select('id, email, workspace_id, workspace:workspace_id(plan)')
          .eq('id', user.id)
          .maybeSingle();
    } on Exception catch (error, stack) {
      AppLogger.error('Profile read failed; using the auth user', error, stack);
      return AuthUserDto(id: user.id, email: user.email ?? '');
    }
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
