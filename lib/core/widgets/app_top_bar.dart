// Screen header. Two forms from the mockups:
//  * large  — Archivo 800 screen title, optional subtitle, trailing action,
//             optional bottom row (filter chips).
//  * back   — back chevron, Archivo 700 title + mono subtitle, trailing.
// Surface fill with a bottom hairline; on wide layouts the fill is dropped so
// the header sits on paper as in the tablet mockups.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/responsive/context_ext.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_icon.dart';

/// Screen header bar.
class AppTopBar extends StatelessWidget {
  /// Large-title header for top-level screens.
  const AppTopBar({
    required this.title,
    this.subtitle,
    this.trailing,
    this.bottom,
    super.key,
  })  : onBack = null,
        isBack = false;

  /// Header with a back button for pushed screens.
  const AppTopBar.back({
    required this.title,
    required this.onBack,
    this.subtitle,
    this.trailing,
    super.key,
  })  : bottom = null,
        isBack = true;

  /// Localized title.
  final String title;

  /// Optional subtitle widget (count line, source line).
  final Widget? subtitle;

  /// Optional trailing widget (icon button, action, status pill).
  final Widget? trailing;

  /// Optional row under the title (filter chips).
  final Widget? bottom;

  /// Back handler for [AppTopBar.back].
  final VoidCallback? onBack;

  /// Whether this is the back variant.
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final onPaper = !context.isMobile && !isBack;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: isBack
                ? context.textTheme.titleLarge
                : context.textTheme.displayLarge,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: spacing.xxs),
          subtitle!,
        ],
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: onPaper ? colors.paper : colors.surface,
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: isBack
              ? EdgeInsets.fromLTRB(spacing.md, spacing.lg, spacing.md, spacing.screenPadding)
              : EdgeInsets.fromLTRB(spacing.lg, spacing.xl, spacing.lg, spacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment:
                    isBack ? CrossAxisAlignment.center : CrossAxisAlignment.end,
                children: [
                  if (isBack) ...[
                    _BackButton(onPressed: onBack!),
                    SizedBox(width: spacing.xs + spacing.xxs),
                  ],
                  Expanded(child: titleBlock),
                  if (trailing != null) ...[
                    SizedBox(width: spacing.sm),
                    trailing!,
                  ],
                ],
              ),
              if (bottom != null) ...[
                SizedBox(height: spacing.md),
                bottom!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return AppIconButton(
      icon: AppIcons.chevronLeft,
      tooltip: context.l10n.back,
      onPressed: onPressed,
      iconSize: spacing.iconLg,
      filled: false,
      color: context.colors.ink,
    );
  }
}

/// Square icon button (36px visual, 44px tap target).
class AppIconButton extends StatelessWidget {
  /// Creates the button.
  const AppIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconSize,
    this.filled = true,
    this.color,
    super.key,
  });

  /// Glyph.
  final AppIcons icon;

  /// Localized tooltip and semantics label.
  final String tooltip;

  /// Tap handler.
  final VoidCallback? onPressed;

  /// Glyph size; defaults to `spacing.iconMd`.
  final double? iconSize;

  /// Paper-filled background (app-bar gear) vs. transparent (back).
  final bool filled;

  /// Glyph color; defaults to `muted`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(spacing.radiusSegment);

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        excludeSemantics: true,
        child: SizedBox.square(
          dimension: spacing.minTapTarget,
          child: Center(
            child: Material(
              color: filled ? colors.paper : Colors.transparent,
              borderRadius: radius,
              child: InkWell(
                onTap: onPressed,
                borderRadius: radius,
                child: SizedBox.square(
                  dimension: spacing.iconButtonSize,
                  child: Center(
                    child: AppIcon(
                      icon,
                      size: iconSize ?? spacing.iconMd,
                      color: color ?? colors.muted,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
