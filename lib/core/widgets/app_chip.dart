// Chips: full-radius filter pills (audit) and flex segmented chips (theme,
// language, platform). Selected = accent fill; unselected = outlined.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/theme/app_text_styles.dart';

/// Full-radius filter chip (mono label).
class AppChip extends StatelessWidget {
  /// Creates a chip.
  const AppChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Localized label.
  final String label;

  /// Whether the chip is selected.
  final bool selected;

  /// Called when tapped.
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(spacing.radiusPill);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? colors.accent : colors.paper,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: selected ? BorderSide.none : BorderSide(color: colors.line),
        ),
        child: InkWell(
          onTap: onSelected,
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.md + spacing.xxs / 2,
              vertical: spacing.xs + spacing.xxs,
            ),
            child: Text(
              label,
              style: AppTextStyles.monoData.copyWith(
                color: selected ? colors.onFill : colors.muted,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One option of [SegmentedChips].
@immutable
class SegmentOption<T> {
  /// Creates an option.
  const SegmentOption({required this.value, required this.label});

  /// Value reported on selection.
  final T value;

  /// Localized label.
  final String label;
}

/// Equal-width segmented choice (height 40, radius 10).
class SegmentedChips<T> extends StatelessWidget {
  /// Creates the control.
  const SegmentedChips({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// Options in display order.
  final List<SegmentOption<T>> options;

  /// Currently selected value.
  final T selected;

  /// Called with the tapped value.
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) SizedBox(width: spacing.sm),
          Expanded(
            child: _Segment(
              key: ValueKey(options[i].value),
              label: options[i].label,
              selected: options[i].value == selected,
              onTap: () => onChanged(options[i].value),
            ),
          ),
        ],
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(spacing.radiusSegment);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? colors.accent : colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: selected ? BorderSide.none : BorderSide(color: colors.lineStrong),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: SizedBox(
            height: spacing.segmentHeight,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.xs),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: selected ? colors.onFill : colors.inkSoft,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      height: 1,
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
