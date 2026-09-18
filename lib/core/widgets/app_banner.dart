// Tinted informational panel on accentWash: optional mono label, message in
// accentInk, optional leading icon ("What it wants to do", test status).
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/section_label.dart';

/// Accent-tinted banner.
class AppBanner extends StatelessWidget {
  /// Creates a banner.
  const AppBanner({required this.message, this.label, this.icon, super.key});

  /// Localized or content message.
  final String message;

  /// Optional uppercase label above the message.
  final String? label;

  /// Optional leading glyph.
  final AppIcons? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.accentWash,
        borderRadius: BorderRadius.circular(spacing.radiusPanel),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md + spacing.xxs / 2,
          vertical: spacing.md,
        ),
        child: Row(
          crossAxisAlignment:
              label == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: spacing.iconMd - spacing.xxs, color: colors.accent),
              SizedBox(width: spacing.sm + spacing.xxs / 2),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (label != null) ...[
                    SectionLabel(label!, color: colors.accent),
                    SizedBox(height: spacing.xs),
                  ],
                  Text(
                    message,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colors.accentInk,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
