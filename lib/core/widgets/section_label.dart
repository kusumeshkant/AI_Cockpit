// Mono uppercase label used above sections and form fields.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';

/// Uppercase mono label in `muted` (or [color]).
class SectionLabel extends StatelessWidget {
  /// Creates a label. [dense] uses the tighter field-label tracking.
  const SectionLabel(this.text, {this.color, this.dense = false, super.key});

  /// Localized text (rendered uppercase).
  final String text;

  /// Override color (e.g. accent inside a summary banner).
  final Color? color;

  /// Field-label tracking (0.06em) instead of section tracking (0.08em).
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.labelMedium;
    final fontSize = style?.fontSize ?? 0;
    return Semantics(
      header: !dense,
      child: Text(
        text.toUpperCase(),
        style: style?.copyWith(
          color: color ?? context.colors.muted,
          letterSpacing: fontSize * (dense ? 0.06 : 0.08),
        ),
      ),
    );
  }
}
