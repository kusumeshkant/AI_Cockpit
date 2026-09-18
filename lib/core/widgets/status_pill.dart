// Status indicator: full-radius pill (dot + uppercase mono label on a tinted
// background) or the bare variant (dot + colored text) used for LIVE/PAUSED.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';

/// Semantic tone of a [StatusPill].
enum StatusTone {
  /// Amber — awaiting a decision / paused.
  pending,

  /// Green — approved / live.
  go,

  /// Red — rejected / failed.
  stop,
}

/// Rounded status label.
class StatusPill extends StatelessWidget {
  /// Tinted pill.
  const StatusPill({required this.label, required this.tone, super.key})
      : bare = false;

  /// Dot + colored text without a background (connections list).
  const StatusPill.bare({required this.label, required this.tone, super.key})
      : bare = true;

  /// Localized label (rendered uppercase).
  final String label;

  /// Semantic tone.
  final StatusTone tone;

  /// Whether the background is omitted.
  final bool bare;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final (foreground, background) = switch (tone) {
      StatusTone.pending => (colors.pending, colors.pendingBg),
      StatusTone.go => (colors.go, colors.goBg),
      StatusTone.stop => (colors.stop, colors.stopBg),
    };
    final dotSize = bare ? spacing.dotMd : spacing.dotSm;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: dotSize,
          child: DecoratedBox(
            decoration: BoxDecoration(color: foreground, shape: BoxShape.circle),
          ),
        ),
        SizedBox(width: spacing.xs + spacing.xxs / 2),
        Text(
          label.toUpperCase(),
          maxLines: 1,
          style: context.textTheme.labelSmall?.copyWith(color: foreground),
        ),
      ],
    );

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: bare
          ? content
          : DecoratedBox(
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(spacing.radiusPill),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm + spacing.xxs / 2,
                  vertical: spacing.xs - spacing.xxs / 2,
                ),
                child: content,
              ),
            ),
    );
  }
}
