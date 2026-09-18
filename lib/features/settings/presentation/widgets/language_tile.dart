// Feature: settings · Layer: presentation
// Language picker (System / English / हिन्दी) — drives LocaleController.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/localization/locale_controller.dart';
import 'package:cockpit/core/widgets/app_chip.dart';
import 'package:cockpit/features/settings/presentation/controllers/settings_controller.dart';

/// Segmented language choice. `null` means "follow the device".
class LanguageTile extends ConsumerWidget {
  /// Creates the tile.
  const LanguageTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SegmentedChips<String?>(
      selected: ref.watch(localeControllerProvider)?.languageCode,
      onChanged: (code) => ref
          .read(settingsControllerProvider)
          .setLocale(code == null ? null : Locale(code)),
      options: [
        SegmentOption(value: null, label: l10n.languageSystem),
        SegmentOption(value: 'en', label: l10n.languageEnglish),
        SegmentOption(value: 'hi', label: l10n.languageHindi),
      ],
    );
  }
}
