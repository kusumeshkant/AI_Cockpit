// Feature: settings · Layer: presentation
// Delete account (F02): what is deleted, then type-to-confirm with the
// account email (sign-in is by emailed code, so a second code would be heavy).
// On success the auth stream emits null and the router's redirect returns to
// sign-in; on
// failure the error is shown and the same button retries (the backend is
// idempotent).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/core/widgets/app_text_field.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';

/// Whether [typed] confirms deletion of the account with [email].
@visibleForTesting
bool confirmsEmail(String typed, String email) =>
    email.isNotEmpty && typed.trim().toLowerCase() == email.trim().toLowerCase();

/// Delete-account screen.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _confirm = TextEditingController();
  bool _deleting = false;
  bool _deleted = false;
  Failure? _failure;

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouteNames.settings);
    }
  }

  Future<void> _delete() async {
    setState(() {
      _deleting = true;
      _failure = null;
    });
    final failure = await ref.read(authControllerProvider.notifier).deleteAccount();
    if (!mounted) return;
    if (failure != null) {
      setState(() {
        _deleting = false;
        _failure = failure;
      });
      return;
    }
    setState(() {
      _deleting = false;
      _deleted = true;
    });
    // Signed out now: the router redirects to sign-in by itself.
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.deleteAccountDone)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final email = ref.watch(authControllerProvider.select((auth) => auth.value?.email)) ?? '';
    final typed = _confirm.text;
    final matches = confirmsEmail(typed, email);
    final canDelete = matches && !_deleting && !_deleted;
    final showMismatch = typed.trim().isNotEmpty && !matches;

    return AppScaffold(
      topBar: AppTopBar.back(title: l10n.deleteAccount, onBack: _close),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    AppIcon(AppIcons.alert, color: colors.stop),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Text(
                        l10n.deleteAccountWarningTitle,
                        style: context.textTheme.titleMedium?.copyWith(color: colors.stop),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.md),
                for (final line in [
                  l10n.deleteAccountWarningAccount,
                  l10n.deleteAccountWarningDevice,
                  l10n.deleteAccountWarningOwner,
                  l10n.deleteAccountWarningApprover,
                ])
                  _Bullet(line),
              ],
            ),
          ),
          SizedBox(height: spacing.sectionGap),
          AppTextField(
            key: const ValueKey('delete_account_confirm'),
            label: l10n.deleteAccountConfirmLabel,
            controller: _confirm,
            hint: email,
            leadingIcon: AppIcons.mail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !_deleting && !_deleted,
            errorText: showMismatch ? l10n.deleteAccountConfirmMismatch : null,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => canDelete ? _delete() : null,
          ),
          if (_failure != null) ...[
            SizedBox(height: spacing.md),
            Text(
              l10n.deleteAccountFailed(context.failureMessage(_failure)),
              style: context.textTheme.bodyMedium?.copyWith(color: colors.stop),
            ),
          ],
          SizedBox(height: spacing.lg),
          AppButton(
            key: const ValueKey('delete_account_button'),
            label: l10n.deleteAccountButton,
            variant: AppButtonVariant.danger,
            expand: true,
            isLoading: _deleting,
            onPressed: canDelete ? _delete : null,
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: spacing.sm),
            child: Container(
              width: spacing.xs + spacing.xxs,
              height: spacing.xs + spacing.xxs,
              decoration: BoxDecoration(color: context.colors.muted, shape: BoxShape.circle),
            ),
          ),
          SizedBox(width: spacing.sm),
          Expanded(child: Text(text, style: context.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
