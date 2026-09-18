// Feature: auth · Layer: presentation
// Streams the signed-in user and exposes sign-in / sign-out commands.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/domain/usecases/sign_in.dart';
import 'package:cockpit/features/auth/domain/usecases/sign_out.dart';
import 'package:cockpit/features/auth/domain/usecases/verify_otp.dart';
import 'package:cockpit/features/auth/domain/usecases/watch_auth_state.dart';

/// Auth state controller.
class AuthController extends StreamNotifier<AuthUser?> {
  @override
  Stream<AuthUser?> build() => getIt<WatchAuthState>()();

  /// Sends the sign-in email for [email]. Returns `null` on success.
  Future<Failure?> signIn(String email) async {
    final result = await getIt<SignIn>()(email: email);
    return result.fold((failure) => failure, (_) => null);
  }

  /// Verifies the emailed one-time [code]. On success the auth stream emits
  /// the signed-in user. Returns `null` on success.
  Future<Failure?> verifyOtp(String email, String code) async {
    final result = await getIt<VerifyOtp>()(email: email, code: code);
    return result.fold((failure) => failure, (_) => null);
  }

  /// Signs out.
  Future<void> signOut() async {
    // TODO(feature/auth): surface failures as a snackbar.
    await getIt<SignOut>()();
  }
}

/// The current [AuthUser], or `null` when signed out.
final authControllerProvider =
    StreamNotifierProvider<AuthController, AuthUser?>(AuthController.new);
