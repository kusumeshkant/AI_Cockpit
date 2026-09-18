// Cockpit logo mark: rounded square with the accent gradient and a hollow
// centre, optionally haloed (sign-in).
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';

/// Brand mark.
class BrandMark extends StatelessWidget {
  /// Creates a mark of [size]; [halo] adds the accentWash ring.
  const BrandMark({required this.size, this.halo = false, super.key});

  /// Square size.
  final double size;

  /// Draws a 4px accentWash ring around the mark.
  final bool halo;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    // Proportions from the mockups: radius ≈ 27% of size, hole inset ≈ 30%.
    final radius = size * 0.27;
    final inset = size * 0.3;

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.accentBright, colors.accent],
          ),
          boxShadow: halo
              ? [BoxShadow(color: colors.accentWash, spreadRadius: spacing.xs)]
              : null,
        ),
        padding: EdgeInsets.all(inset),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: halo ? colors.paper : colors.surface,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
