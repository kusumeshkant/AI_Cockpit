// Button with the four spec variants: primary (accent fill), success (go
// fill), danger (stop outline), secondary (lineStrong outline). Radius 11,
// weight 600, soft colored shadow on filled variants (light theme).
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_icon.dart';

/// Visual intent of an [AppButton].
enum AppButtonVariant {
  /// Accent fill — primary action.
  primary,

  /// Green fill — approve.
  success,

  /// Red outline — reject / destructive.
  danger,

  /// Neutral outline.
  secondary,
}

/// Size of an [AppButton].
enum AppButtonSize {
  /// 48px — screens, bars.
  regular,

  /// 36px — app-bar actions.
  compact,
}

/// Cockpit's button.
class AppButton extends StatelessWidget {
  /// Creates a button. A `null` [onPressed] disables it.
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.regular,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  });

  /// Opacity of disabled buttons.
  static const double disabledOpacity = 0.5;

  /// Localized label.
  final String label;

  /// Tap handler; ignored while [isLoading].
  final VoidCallback? onPressed;

  /// Visual intent.
  final AppButtonVariant variant;

  /// Height class.
  final AppButtonSize size;

  /// Optional leading icon.
  final AppIcons? icon;

  /// Shows a spinner and blocks taps.
  final bool isLoading;

  /// Fills the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final enabled = onPressed != null && !isLoading;
    final compact = size == AppButtonSize.compact;

    final (Color fill, Color foreground, Color? border) = switch (variant) {
      AppButtonVariant.primary => (colors.accent, colors.onFill, null),
      AppButtonVariant.success => (colors.go, colors.onFill, null),
      AppButtonVariant.danger => (Colors.transparent, colors.stop, colors.stop),
      AppButtonVariant.secondary =>
        (Colors.transparent, colors.inkSoft, colors.lineStrong),
    };
    final radius = BorderRadius.circular(
      compact ? spacing.radiusSegment : spacing.radiusButton,
    );
    final labelStyle = (compact
            ? context.textTheme.labelLarge?.copyWith(
                fontSize: context.textTheme.bodyMedium?.fontSize,
              )
            : context.textTheme.labelLarge)
        ?.copyWith(color: foreground);

    final Widget content = isLoading
        ? SizedBox.square(
            dimension: spacing.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: spacing.xxs,
              color: foreground,
            ),
          )
        : FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  AppIcon(icon!, size: spacing.iconSm, color: foreground),
                  SizedBox(width: spacing.xs + spacing.xxs),
                ],
                Text(label, maxLines: 1, style: labelStyle),
              ],
            ),
          );

    final button = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: enabled && border == null && !compact
            ? context.fillShadow(fill)
            : const <BoxShadow>[],
      ),
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: border == null
              ? BorderSide.none
              : BorderSide(color: border, width: spacing.borderMedium),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: SizedBox(
            height: compact ? spacing.buttonHeightCompact : spacing.buttonHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? spacing.md + spacing.xxs : spacing.lg,
              ),
              child: Center(widthFactor: 1, child: content),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Opacity(
        opacity: onPressed == null ? disabledOpacity : 1,
        child: expand ? SizedBox(width: double.infinity, child: button) : button,
      ),
    );
  }
}
