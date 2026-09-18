// Surface container: surface fill, 1px line border, radius 15, padding 14,
// soft shadow in light mode. Optional tap and selected (2px accent) states.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';

/// Cockpit's card.
class AppCard extends StatelessWidget {
  /// Creates a card.
  const AppCard({
    required this.child,
    this.onTap,
    this.padding,
    this.selected = false,
    super.key,
  });

  /// Card content.
  final Widget child;

  /// Optional tap handler (adds an ink response).
  final VoidCallback? onTap;

  /// Inner padding; defaults to `spacing.cardPadding`. Pass
  /// [EdgeInsets.zero] for sectioned cards that manage their own padding.
  final EdgeInsetsGeometry? padding;

  /// Highlights the card with a thick accent border (master–detail).
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(spacing.radiusCard);

    final content = Padding(
      padding: padding ?? EdgeInsets.all(spacing.cardPadding),
      child: child,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: context.cardShadow,
      ),
      child: Material(
        color: colors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: selected ? colors.accent : colors.line,
            width: selected ? spacing.borderThick : spacing.borderThin,
          ),
        ),
        child: onTap == null
            ? content
            : InkWell(onTap: onTap, child: content),
      ),
    );
  }
}
