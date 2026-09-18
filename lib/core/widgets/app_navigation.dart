// Primary navigation: bottom nav (phones) and left rail (≥ medium width).
// Both take the same [AppNavItem] list so the shell can swap them.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/brand_mark.dart';

/// A top-level destination.
@immutable
class AppNavItem {
  /// Creates a destination.
  const AppNavItem({
    required this.icon,
    required this.label,
    required this.railLabel,
    this.badgeCount,
  });

  /// Glyph.
  final AppIcons icon;

  /// Short label for the bottom nav (e.g. "Connect").
  final String label;

  /// Longer label for the rail (e.g. "Connections").
  final String railLabel;

  /// Optional count badge shown in the rail.
  final int? badgeCount;
}

/// Phone bottom navigation: icon 22 + mono 9.5 label; active = accent.
class AppBottomNav extends StatelessWidget {
  /// Creates the bar.
  const AppBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    super.key,
  });

  /// Destinations.
  final List<AppNavItem> items;

  /// Selected destination.
  final int currentIndex;

  /// Called with the tapped index.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.xs,
            spacing.sm,
            spacing.xs,
            spacing.md,
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _BottomNavButton(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final color = selected ? colors.accent : colors.muted;
    final labelStyle = context.textTheme.labelSmall?.copyWith(
      color: color,
      letterSpacing: 0,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        borderRadius: BorderRadius.circular(spacing.radiusSegment),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: spacing.minTapTarget),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(item.icon, size: spacing.iconLg, color: color),
              SizedBox(height: spacing.xs - spacing.xxs / 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tablet left rail: brand + destinations; active = accentWash pill.
class AppNavRail extends StatelessWidget {
  /// Creates the rail.
  const AppNavRail({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    required this.brandName,
    super.key,
  });

  /// Destinations.
  final List<AppNavItem> items;

  /// Selected destination.
  final int currentIndex;

  /// Called with the tapped index.
  final ValueChanged<int> onSelected;

  /// Localized product name next to the mark.
  final String brandName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(right: BorderSide(color: colors.line)),
      ),
      child: SizedBox(
        width: spacing.railWidth,
        child: SafeArea(
          right: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.screenPadding,
              vertical: spacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.xs + spacing.xxs),
                  child: Row(
                    children: [
                      BrandMark(size: spacing.brandMarkSmall),
                      SizedBox(width: spacing.sm),
                      Flexible(
                        child: Text(
                          brandName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.xl + spacing.xs),
                for (var i = 0; i < items.length; i++) ...[
                  _RailButton(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onSelected(i),
                  ),
                  SizedBox(height: spacing.xs),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final color = selected ? colors.accent : colors.muted;
    final badge = item.badgeCount;

    return Semantics(
      button: true,
      selected: selected,
      label: item.railLabel,
      child: Material(
        color: selected ? colors.accentWash : Colors.transparent,
        borderRadius: BorderRadius.circular(spacing.radiusSegment),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(spacing.radiusSegment),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: spacing.minTapTarget),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              child: Row(
                children: [
                  AppIcon(item.icon, size: spacing.iconMd, color: color),
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Text(
                      item.railLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (badge != null && badge > 0)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.accent,
                        borderRadius: BorderRadius.circular(spacing.radiusPill),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.sm,
                          vertical: spacing.xxs / 2,
                        ),
                        child: Text(
                          '$badge',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: colors.onFill,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
