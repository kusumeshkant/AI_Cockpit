// Cockpit logo mark: the AI Cockpit radar symbol from assets/branding/, in
// its light- or dark-background version, optionally haloed (sign-in).
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';

/// Brand mark.
class BrandMark extends StatelessWidget {
  /// Creates a mark of [size]; [halo] adds the accentWash ring.
  const BrandMark({required this.size, this.halo = false, super.key});

  /// Symbol for dark backgrounds.
  static const String darkAsset = 'assets/branding/logo_symbol.png';

  /// Symbol for light backgrounds.
  static const String lightAsset = 'assets/branding/logo_symbol_light.png';

  /// Square size.
  final double size;

  /// Draws a 4px accentWash ring around the mark.
  final bool halo;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Decode at the on-screen pixel size: sharp, and no 512px bitmap per mark.
    final cacheSize = (size * MediaQuery.devicePixelRatioOf(context)).ceil();

    return Semantics(
      label: context.l10n.brandMarkLabel,
      image: true,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: halo
            ? BoxDecoration(
                // Filled with the page colour so only the ring shows around
                // the transparent symbol.
                color: colors.paper,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: colors.accentWash, spreadRadius: spacing.xs)],
              )
            : null,
        child: Image.asset(
          dark ? darkAsset : lightAsset,
          width: size,
          height: size,
          cacheWidth: cacheSize,
          cacheHeight: cacheSize,
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
