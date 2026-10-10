// F07: code resend cooldown, in-flight lock, rate limit; digits-only input.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/utils/clock.dart';
import 'package:cockpit/core/utils/otp_input_formatter.dart';
import 'package:cockpit/features/auth/domain/auth_constants.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/auth/presentation/controllers/otp_resend_controller.dart';

class _Auth extends AuthController {
  final List<String> sent = [];
  Failure? failure;
  Completer<void>? gate;

  @override
  Stream<AuthUser?> build() => Stream.value(null);

  @override
  Future<Failure?> signIn(String email) async {
    sent.add(email);
    await gate?.future;
    return failure;
  }
}

void main() {
  late _Auth auth;
  late DateTime now;
  late ProviderContainer container;

  setUp(() {
    auth = _Auth();
    now = DateTime(2026, 10, 10, 9);
    container = ProviderContainer(
      overrides: [
        authControllerProvider.overrideWith(() => auth),
        clockProvider.overrideWithValue(() => now),
      ],
    );
  });

  tearDown(() => container.dispose());

  OtpResendController controller() => container.read(otpResendControllerProvider.notifier);

  test('the first send works and starts the cooldown', () async {
    expect(await controller().send('a@x.example'), isA<OtpSent>());
    expect(controller().remaining('a@x.example'), otpResendCooldown);
  });

  test('during the cooldown the same address is not sent again', () async {
    await controller().send('a@x.example');
    now = now.add(const Duration(seconds: 30));

    expect(await controller().send('A@X.example '), isA<OtpSendIgnored>(), reason: 'same address');
    expect(controller().remaining('a@x.example'), const Duration(seconds: 30));
    expect(auth.sent, hasLength(1));

    now = now.add(const Duration(seconds: 30));
    expect(await controller().send('a@x.example'), isA<OtpSent>());
    expect(auth.sent, hasLength(2));
  });

  test('a different address is not held back', () async {
    await controller().send('a@x.example');

    expect(await controller().send('b@x.example'), isA<OtpSent>());
    expect(auth.sent, ['a@x.example', 'b@x.example']);
  });

  test('a double tap while a request is in flight sends once', () async {
    auth.gate = Completer<void>();
    final first = controller().send('a@x.example');
    final second = await controller().send('a@x.example');
    auth.gate!.complete();

    expect(second, isA<OtpSendIgnored>());
    expect(await first, isA<OtpSent>());
    expect(auth.sent, hasLength(1));
  });

  test('a rate limit starts the cooldown (at least the server hint)', () async {
    auth.failure = const RateLimitedFailure('over_email_send_rate_limit', Duration(minutes: 5));

    final result = await controller().send('a@x.example');

    expect(result, isA<OtpSendFailed>());
    expect(controller().remaining('a@x.example'), const Duration(minutes: 5));
  });

  test('other failures leave no cooldown, so the user can retry', () async {
    auth.failure = const NetworkFailure();

    expect(await controller().send('a@x.example'), isA<OtpSendFailed>());
    expect(controller().remaining('a@x.example'), Duration.zero);
  });

  group('OtpInputFormatter', () {
    const formatter = OtpInputFormatter(otpLength);
    String format(String text) =>
        formatter.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: text)).text;

    test('keeps digits only and cuts at the code length', () {
      expect(format('123 456'), '123456');
      expect(format('12-34-56'), '123456');
      expect(format('Your code: 98765432'), '987654');
      expect(format('abc'), '');
    });
  });
}
