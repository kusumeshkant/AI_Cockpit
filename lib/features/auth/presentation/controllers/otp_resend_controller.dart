// Feature: auth · Layer: presentation
// Sends the sign-in code email and enforces the resend cooldown (F07). The
// email itself goes through AuthController.signIn (the SignIn use case), so a
// resend is the same backend call as the first send. The cooldown applies per
// email: switching to another address may send at once.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/clock.dart';
import 'package:cockpit/features/auth/domain/auth_constants.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';

/// Resend state: the last address a code was requested for, until when a new
/// request for it is held back, and whether a request is in flight.
class OtpResendState {
  /// Creates the state.
  const OtpResendState({this.email, this.cooldownUntil, this.sending = false});

  /// Address of the last successful (or rate-limited) request.
  final String? email;

  /// No new request for [email] before this time.
  final DateTime? cooldownUntil;

  /// A request is in flight.
  final bool sending;

  /// Time left before [forEmail] can be requested again (zero when free).
  Duration remaining(String forEmail, DateTime now) {
    final until = cooldownUntil;
    if (until == null || !_sameEmail(email, forEmail)) return Duration.zero;
    final left = until.difference(now);
    return left.isNegative ? Duration.zero : left;
  }

  static bool _sameEmail(String? a, String b) =>
      a != null && a.trim().toLowerCase() == b.trim().toLowerCase();
}

/// Outcome of [OtpResendController.send].
sealed class OtpSendResult {
  const OtpSendResult();
}

/// The email was sent.
final class OtpSent extends OtpSendResult {
  /// Creates the result.
  const OtpSent();
}

/// Nothing was sent: a request is already in flight or the cooldown runs.
final class OtpSendIgnored extends OtpSendResult {
  /// Creates the result.
  const OtpSendIgnored();
}

/// Sending failed with [failure].
final class OtpSendFailed extends OtpSendResult {
  /// Creates the result.
  const OtpSendFailed(this.failure);

  /// Why it failed.
  final Failure failure;
}

/// Sends sign-in codes with a cooldown and double-tap protection.
class OtpResendController extends Notifier<OtpResendState> {
  @override
  OtpResendState build() => const OtpResendState();

  DateTime get _now => ref.read(clockProvider)();

  /// Time left before [email] can be requested again.
  Duration remaining(String email) => state.remaining(email, _now);

  /// Requests a code for [email] unless one is in flight or the cooldown for
  /// this address is still running.
  Future<OtpSendResult> send(String email) async {
    if (state.sending || remaining(email) > Duration.zero) return const OtpSendIgnored();
    state = OtpResendState(email: state.email, cooldownUntil: state.cooldownUntil, sending: true);

    final failure = await ref.read(authControllerProvider.notifier).signIn(email);
    final now = _now;
    switch (failure) {
      case null:
        state = OtpResendState(email: email, cooldownUntil: now.add(otpResendCooldown));
        return const OtpSent();
      case RateLimitedFailure(:final retryAfter):
        // Auth refused: wait at least the server's hint, never less than ours.
        final wait = retryAfter != null && retryAfter > otpResendCooldown
            ? retryAfter
            : otpResendCooldown;
        state = OtpResendState(email: email, cooldownUntil: now.add(wait));
        return OtpSendFailed(failure);
      default:
        state = OtpResendState(email: state.email, cooldownUntil: state.cooldownUntil);
        return OtpSendFailed(failure);
    }
  }
}

/// Sign-in code sending + cooldown.
final otpResendControllerProvider =
    NotifierProvider<OtpResendController, OtpResendState>(OtpResendController.new);
