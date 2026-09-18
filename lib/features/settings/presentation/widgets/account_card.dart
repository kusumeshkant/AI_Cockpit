// Feature: settings · Layer: presentation
// Account card: avatar initial, name, workspace/plan line, Sign out (red).
// Signed out → a Sign in button instead.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/features/auth/domain/entities/auth_user.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/settings/presentation/controllers/settings_controller.dart';

/// Account summary with sign-out.
class AccountCard extends ConsumerWidget {
  /// Creates the card. [inlineSignOut] puts Sign out on the account row
  /// (wide layouts) instead of its own row.
  const AccountCard({this.inlineSignOut = false, super.key});

  /// Wide-layout variant.
  final bool inlineSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final user = ref.watch(authControllerProvider).value;

    if (user == null) {
      return AppCard(
        child: AppButton(
          label: context.l10n.signIn,
          variant: AppButtonVariant.secondary,
          expand: true,
          onPressed: () => context.goNamed(RouteNames.signIn),
        ),
      );
    }

    final signOut = _SignOutButton(
      onPressed: () => ref.read(settingsControllerProvider).signOut(),
    );

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(spacing.cardPadding),
            child: Row(
              children: [
                _Avatar(user: user),
                SizedBox(width: spacing.md),
                Expanded(
                  child: _Identity(user: user, showEmail: inlineSignOut),
                ),
                if (inlineSignOut) ...[
                  SizedBox(width: spacing.sm),
                  signOut,
                ],
              ],
            ),
          ),
          if (!inlineSignOut) ...[
            const Divider(),
            signOut,
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = user.displayName ?? user.email;
    return ExcludeSemantics(
      child: Container(
        width: context.spacing.avatarSize,
        height: context.spacing.avatarSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.accentWash,
          shape: BoxShape.circle,
        ),
        child: Text(
          name.isEmpty ? '' : name.characters.first.toUpperCase(),
          style: context.textTheme.titleLarge?.copyWith(color: colors.accent),
        ),
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.user, required this.showEmail});

  final AuthUser user;
  final bool showEmail;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final plan = switch (user.plan) {
      WorkspacePlan.solo => l10n.planSolo,
      WorkspacePlan.pro => l10n.planPro,
      WorkspacePlan.consultant => l10n.planConsultant,
    };
    var meta = l10n.metaPair(l10n.workspaceCount(1), plan);
    if (showEmail) meta = l10n.metaPair(meta, user.email);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          user.displayName ?? user.email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleSmall,
        ),
        SizedBox(height: context.spacing.xxs),
        Text(
          meta,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelMedium?.copyWith(
            color: colors.muted,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    return Semantics(
      button: true,
      label: context.l10n.signOut,
      excludeSemantics: true,
      child: InkWell(
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: spacing.minTapTarget),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.cardPadding),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(
                  AppIcons.logout,
                  size: spacing.iconMd - spacing.xxs,
                  color: colors.stop,
                ),
                SizedBox(width: spacing.sm + spacing.xxs),
                Text(
                  context.l10n.signOut,
                  style: context.textTheme.titleSmall?.copyWith(color: colors.stop),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
