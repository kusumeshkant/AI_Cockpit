// Inline stroke-SVG icon set copied from the approved mockups
// (technical/design/*.dc.html). 24×24 viewBox, round caps/joins, colored via
// `currentColor`. No icon fonts, no emoji.
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:cockpit/core/theme/app_theme.dart';

/// Available icons: SVG body markup and stroke width.
enum AppIcons {
  /// Tray — Actions.
  tray(
    '<path d="M4 13h4l2 3h4l2-3h4"/><path d="M4 13 6.2 5h11.6L20 13"/>'
    '<path d="M4 13v5a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-5"/>',
  ),

  /// Link — Connections.
  link(
    '<path d="M10.5 13.5a4 4 0 0 0 5.7 0l2.3-2.3a4 4 0 0 0-5.7-5.7l-1 1"/>'
    '<path d="M13.5 10.5a4 4 0 0 0-5.7 0l-2.3 2.3a4 4 0 0 0 5.7 5.7l1-1"/>',
  ),

  /// Bulleted list — Audit.
  list(
    '<path d="M9 6h11M9 12h11M9 18h11"/><circle cx="4.5" cy="6" r="1.1"/>'
    '<circle cx="4.5" cy="12" r="1.1"/><circle cx="4.5" cy="18" r="1.1"/>',
  ),

  /// Gear — Settings.
  gear(
    '<circle cx="12" cy="12" r="3"/><path d="M12 4v2M12 18v2M4 12h2M18 12h2'
    'M6 6l1.4 1.4M16.6 16.6 18 18M6 18l1.4-1.4M16.6 7.4 18 6"/>',
  ),

  /// Back chevron.
  chevronLeft('<path d="M15 6l-6 6 6 6"/>', 1.9),

  /// Forward chevron.
  chevronRight('<path d="M9 6l6 6-6 6"/>', 1.9),

  /// Copy to clipboard.
  copy(
    '<rect x="9" y="9" width="11" height="11" rx="2"/>'
    '<path d="M5 15V6a1 1 0 0 1 1-1h9"/>',
    1.9,
  ),

  /// Check / approve.
  check('<path d="M5 12l4 4L19 7"/>', 2.4),

  /// Close / reject.
  close('<path d="M6 6l12 12M18 6 6 18"/>', 2.2),

  /// Plus / add.
  plus('<path d="M12 5v14M5 12h14"/>', 2.2),

  /// Envelope.
  mail('<rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/>'),

  /// Warning triangle.
  alert(
    '<path d="M12 9v4M12 17h.01"/><path d="M10.3 3.9 2.4 18a1.7 1.7 0 0 0 1.5 '
    '2.5h16.2a1.7 1.7 0 0 0 1.5-2.5L13.7 3.9a1.7 1.7 0 0 0-3 0Z"/>',
    2,
  ),

  /// Sign out.
  logout(
    '<path d="M16 17l5-5-5-5M21 12H9M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>',
    1.9,
  ),

  /// Pencil / editable.
  pencil(
    '<path d="M12 20h9"/><path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/>',
    2,
  ),

  /// 2×2 grid — agent tile.
  grid('<path d="M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h6v6h-6z"/>'),

  /// Open arc — waiting / in progress.
  progress('<path d="M12 3a9 9 0 1 0 9 9"/>', 2);

  const AppIcons(this.body, [this.strokeWidth = 1.8]);

  /// SVG child elements.
  final String body;

  /// Stroke width in viewBox units.
  final double strokeWidth;

  /// Complete SVG document.
  String get svg =>
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" '
      'stroke="currentColor" stroke-width="$strokeWidth" stroke-linecap="round" '
      'stroke-linejoin="round">$body</svg>';
}

/// Renders an [AppIcons] glyph.
class AppIcon extends StatelessWidget {
  /// Creates an icon. [color] defaults to the ambient [IconTheme] color, then
  /// `muted`; [size] defaults to `spacing.iconMd`.
  const AppIcon(this.icon, {this.size, this.color, this.semanticLabel, super.key});

  /// The glyph.
  final AppIcons icon;

  /// Square size.
  final double? size;

  /// Stroke color.
  final Color? color;

  /// Accessibility label; `null` excludes the icon from semantics.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? context.spacing.iconMd;
    final resolvedColor =
        color ?? IconTheme.of(context).color ?? context.colors.muted;
    return SvgPicture.string(
      icon.svg,
      width: resolvedSize,
      height: resolvedSize,
      theme: SvgTheme(currentColor: resolvedColor),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
