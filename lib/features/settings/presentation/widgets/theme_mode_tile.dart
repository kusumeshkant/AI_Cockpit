// Feature: settings · Layer: presentation
// Theme mode picker (System / Light / Dark) — drives ThemeController.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/theme_controller.dart';
import 'package:cockpit/core/widgets/app_chip.dart';
import 'package:cockpit/features/settings/presentation/controllers/settings_controller.dart';

/// Segmented theme-mode choice.
class ThemeModeTile extends ConsumerWidget {
  /// Creates the tile.
  const ThemeModeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SegmentedChips<ThemeMode>(
      selected: ref.watch(themeControllerProvider),
      onChanged: (mode) =>
          ref.read(settingsControllerProvider).setThemeMode(mode),
      options: [
        SegmentOption(value: ThemeMode.system, label: l10n.themeSystem),
        SegmentOption(value: ThemeMode.light, label: l10n.themeLight),
        SegmentOption(value: ThemeMode.dark, label: l10n.themeDark),
      ],
    );
  }
}
