// Feature: auth · Layer: presentation
// Sign-in (design: technical/design/SignIn.dc.html): brand mark + tagline,
// headline, email field, "Send magic link", terms notice. Vertically centered,
// width-capped on tablets. After the email is sent, a minimal one-time-code
// step completes sign-in (the magic link can't open on an emulator or a
// device that doesn't handle the link).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_text_field.dart';
import 'package:cockpit/core/widgets/brand_mark.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';

/// Sign-in screen.
class SignInScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static final RegExp _codePattern = RegExp(r'^\d{6}$');

  final TextEditingController _email = TextEditingController();
  final TextEditingController _code = TextEditingController();
  bool _showError = false;
  bool _submitting = false;
  bool _codeSent = false;
  String? _codeError;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  bool get _isValid => _emailPattern.hasMatch(_email.text.trim());

  void _showFailure(Failure failure) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(context.failureMessage(failure))));

  Future<void> _submit() async {
    if (!_isValid) {
      setState(() => _showError = true);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    final failure =
        await ref.read(authControllerProvider.notifier).signIn(_email.text.trim());
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _codeSent = failure == null;
    });
    if (failure != null) _showFailure(failure);
  }

  Future<void> _verify() async {
    final l10n = context.l10n;
    if (!_codePattern.hasMatch(_code.text.trim())) {
      setState(() => _codeError = l10n.invalidOtp);
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
      if (failure is ValidationFailure) _codeError = l10n.invalidOtp;
    });
    if (failure != null && failure is! ValidationFailure) _showFailure(failure);
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
                              Text(l10n.appTitle, style: text.displayMedium),
                              Text(
                                l10n.brandTagline.toUpperCase(),
                                style: text.labelMedium?.copyWith(
                                  color: colors.muted,
                                  letterSpacing:
                                      (text.labelMedium?.fontSize ?? 0) * 0.04,
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
                      l10n.signInBody,
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
                        l10n.otpSentTo(_email.text.trim()),
                        style: text.bodySmall?.copyWith(color: colors.muted),
                      ),
                      SizedBox(height: spacing.md),
                      AppTextField(
                        label: l10n.otpCodeLabel,
                        hint: l10n.otpCodeHint,
                        controller: _code,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        errorText: _codeError,
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
                      AppButton(
                        label: l10n.useDifferentEmail,
                        variant: AppButtonVariant.secondary,
                        onPressed: _submitting ? null : _changeEmail,
                        expand: true,
                      ),
                    ] else
                      AppButton(
                        label: l10n.sendMagicLink,
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
