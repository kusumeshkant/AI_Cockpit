// Feature: auth · Layer: presentation
// Sign-in (design: technical/design/SignIn.dc.html): brand mark + tagline,
// headline, email field, "Email me a code", terms notice. Vertically
// centered, width-capped on tablets. After the email is sent, the code step
// completes sign-in: paste/autofill, auto-verify once every digit is in,
// "Resend code" with a cooldown, and "Change email" (F07).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/utils/otp_input_formatter.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_text_field.dart';
import 'package:cockpit/core/widgets/brand_mark.dart';
import 'package:cockpit/core/widgets/legal_links.dart';
import 'package:cockpit/features/auth/domain/auth_constants.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/auth/presentation/controllers/otp_resend_controller.dart';

/// Sign-in screen.
class SignInScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static final RegExp _codePattern = RegExp('^\\d{$otpLength}\$');

  final TextEditingController _email = TextEditingController();
  final TextEditingController _code = TextEditingController();
  bool _showError = false;
  bool _submitting = false;
  bool _codeSent = false;
  String? _codeError;
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  String get _address => _email.text.trim();

  Duration get _cooldown => ref.read(otpResendControllerProvider.notifier).remaining(_address);

  /// Rebuilds once a second while the resend cooldown runs.
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() {});
      if (_cooldown == Duration.zero) timer.cancel();
    });
  }

  String _sendFailureMessage(Failure failure) => failure is RateLimitedFailure
      ? context.l10n.otpTooManyRequests
      : context.failureMessage(failure);

  void _showMessage(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  bool get _isValid => _emailPattern.hasMatch(_email.text.trim());

  Future<void> _submit() async {
    if (!_isValid) {
      setState(() => _showError = true);
      return;
    }
    if (_submitting) return;
    FocusScope.of(context).unfocus();
    // Same address within the cooldown: a code is already on its way.
    if (_cooldown > Duration.zero) {
      setState(() => _codeSent = true);
      _startTicker();
      return;
    }
    setState(() => _submitting = true);
    final result = await ref.read(otpResendControllerProvider.notifier).send(_address);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _codeSent = result is OtpSent;
    });
    _startTicker();
    if (result case OtpSendFailed(:final failure)) _showMessage(_sendFailureMessage(failure));
  }

  Future<void> _resend() async {
    final result = await ref.read(otpResendControllerProvider.notifier).send(_address);
    if (!mounted) return;
    setState(() {
      if (result is OtpSent) {
        _code.clear();
        _codeError = null;
      }
    });
    _startTicker();
    switch (result) {
      case OtpSent():
        _showMessage(context.l10n.codeResent);
      case OtpSendFailed(:final failure):
        _showMessage(_sendFailureMessage(failure));
      case OtpSendIgnored():
        break;
    }
  }

  void _onCodeChanged(String value) {
    if (_codeError != null) setState(() => _codeError = null);
    // Auto-verify once every digit is in (typed, pasted or autofilled).
    if (_codePattern.hasMatch(value) && !_submitting) _verify();
  }

  Future<void> _verify() async {
    final l10n = context.l10n;
    if (_submitting) return;
    if (!_codePattern.hasMatch(_code.text.trim())) {
      setState(() => _codeError = l10n.otpIncomplete(otpLength));
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _codeError = null;
    });
    // On success the auth stream emits the user and the router leaves this
    // screen; nothing else to do here.
    final failure = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(_email.text.trim(), _code.text.trim());
    if (!mounted) return;
    setState(() {
      _submitting = false;
      if (failure is ValidationFailure) _codeError = l10n.otpWrongOrExpired;
    });
    if (failure != null && failure is! ValidationFailure) {
      _showMessage(context.failureMessage(failure));
    }
  }

  void _changeEmail() => setState(() {
        _codeSent = false;
        _code.clear();
        _codeError = null;
      });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final text = context.textTheme;

    return Scaffold(
      backgroundColor: colors.paper,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.xxl,
              vertical: spacing.xl,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: spacing.formMaxWidth),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        BrandMark(size: spacing.brandMarkLarge, halo: true),
                        SizedBox(width: spacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // One line on every width: scales down on
                              // narrow phones / large text instead of wrapping.
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  l10n.appTitle,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: text.displayMedium,
                                ),
                              ),
                              Text(
                                context.labelCase(l10n.brandTagline),
                                style: text.labelMedium?.copyWith(
                                  color: colors.muted,
                                  letterSpacing: context.labelTracking(text.labelMedium, 0.04),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.xxl + spacing.xxs),
                    Text(l10n.signInHeadline, style: text.headlineSmall),
                    SizedBox(height: spacing.sm + spacing.xxs),
                    Text(
                      l10n.signInBody(otpLength),
                      style: text.bodyMedium?.copyWith(color: colors.muted),
                    ),
                    SizedBox(height: spacing.xl + spacing.xs),
                    AppTextField(
                      label: l10n.email,
                      hint: l10n.emailHint,
                      controller: _email,
                      enabled: !_codeSent,
                      leadingIcon: AppIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.go,
                      autofillHints: const [AutofillHints.email],
                      errorText: _showError && !_isValid ? l10n.invalidEmail : null,
                      onChanged: (_) {
                        if (_showError) setState(() {});
                      },
                      onSubmitted: (_) => _submit(),
                    ),
                    SizedBox(height: spacing.lg),
                    if (_codeSent) ...[
                      Text(
                        l10n.otpSentTo(_address, otpLength, otpValidity.inMinutes),
                        style: text.bodySmall?.copyWith(color: colors.muted),
                      ),
                      SizedBox(height: spacing.md),
                      AppTextField(
                        key: const ValueKey('sign_in_code'),
                        label: l10n.otpCodeLabel,
                        hint: l10n.otpCodeHint,
                        controller: _code,
                        enabled: !_submitting,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        inputFormatters: const [OtpInputFormatter(otpLength)],
                        errorText: _codeError,
                        onChanged: _onCodeChanged,
                        onSubmitted: (_) => _verify(),
                      ),
                      SizedBox(height: spacing.lg),
                      AppButton(
                        label: l10n.verifyCode,
                        onPressed: _verify,
                        isLoading: _submitting,
                        expand: true,
                      ),
                      SizedBox(height: spacing.sm),
                      _ResendButton(
                        remaining: _cooldown,
                        sending: ref.watch(otpResendControllerProvider.select((s) => s.sending)),
                        onPressed: _submitting ? null : _resend,
                      ),
                      SizedBox(height: spacing.sm),
                      AppButton(
                        label: l10n.changeEmail,
                        variant: AppButtonVariant.secondary,
                        onPressed: _submitting ? null : _changeEmail,
                        expand: true,
                      ),
                    ] else
                      AppButton(
                        label: l10n.sendCode,
                        onPressed: _submit,
                        isLoading: _submitting,
                        expand: true,
                      ),
                    SizedBox(height: spacing.lg + spacing.xxs),
                    Text(
                      l10n.termsNotice,
                      textAlign: TextAlign.center,
                      style: text.bodySmall?.copyWith(color: colors.muted),
                    ),
                    const LegalLinks(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Resend code", or "Resend code in m:ss" (disabled) during the cooldown.
class _ResendButton extends StatelessWidget {
  const _ResendButton({required this.remaining, required this.sending, required this.onPressed});

  final Duration remaining;
  final bool sending;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final waiting = remaining > Duration.zero;
    // Round up so the label never shows 0:00 while still waiting.
    final seconds = (remaining.inMilliseconds + 999) ~/ 1000;
    final time = '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
    return AppButton(
      key: const ValueKey('sign_in_resend'),
      label: waiting ? l10n.resendCodeIn(time) : l10n.resendCode,
      variant: AppButtonVariant.secondary,
      isLoading: sending,
      onPressed: waiting || sending ? null : onPressed,
      expand: true,
    );
  }
}
