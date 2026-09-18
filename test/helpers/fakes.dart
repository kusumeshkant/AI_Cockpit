import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';

/// A signed-in user for widget tests.
const AuthUser testUser = AuthUser(
  id: 'u1',
  email: 'meera@clinic.example',
  displayName: 'Meera Rao',
  plan: WorkspacePlan.pro,
);

/// Auth controller that never touches get_it.
class FakeAuthController extends AuthController {
  /// Creates the fake, starting with [initial].
  FakeAuthController([this.initial = testUser]);

  /// Initial user (`null` = signed out).
  final AuthUser? initial;

  /// Failure returned by [signIn] (`null` = success).
  Failure? signInFailure;

  /// Failure returned by [verifyOtp] (`null` = success).
  Failure? verifyFailure;

  /// Emails passed to [signIn].
  final List<String> signInEmails = [];

  /// (email, code) pairs passed to [verifyOtp].
  final List<(String, String)> verifiedCodes = [];

  /// Number of sign-out calls.
  int signOutCalls = 0;

  @override
  Stream<AuthUser?> build() => Stream.value(initial);

  @override
  Future<Failure?> signIn(String email) async {
    signInEmails.add(email);
    return signInFailure;
  }

  @override
  Future<Failure?> verifyOtp(String email, String code) async {
    verifiedCodes.add((email, code));
    return verifyFailure;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    state = const AsyncData<AuthUser?>(null);
  }
}
