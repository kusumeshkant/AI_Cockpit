// Feature: settings · Layer: presentation
// Settings.
//  * phone (Settings.dc.html): labelled sections stacked — Appearance
//    (theme segmented) → Language (segmented) → Account (Sign out row).
//  * wide content (TabletSettings.dc.html): two-column grid of cards with
//    the label inside each card; the account card spans both columns with
//    Sign out inline.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/responsive/breakpoints.dart';
import 'package:cockpit/core/responsive/context_ext.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/core/widgets/section_label.dart';
import 'package:cockpit/features/settings/presentation/widgets/account_card.dart';
import 'package:cockpit/features/settings/presentation/widgets/language_tile.dart';
import 'package:cockpit/features/settings/presentation/widgets/theme_mode_tile.dart';

/// Settings screen.
class SettingsScreen extends StatelessWidget {
  /// Creates the screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      topBar: AppTopBar(title: context.l10n.settingsTitle),
      body: LayoutBuilder(
        builder: (context, constraints) =>
            !context.isMobile &&
                    constraints.maxWidth >= Breakpoints.twoColumnMinWidth
                ? const _WideSettings()
                : const _PhoneSettings(),
      ),
    );
  }
}

class _PhoneSettings extends StatelessWidget {
  const _PhoneSettings();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        _Section(
          label: l10n.appearance,
          child: AppCard(
            child: _TitledControl(
              title: l10n.themeLabel,
              child: const ThemeModeTile(),
            ),
          ),
        ),
        SizedBox(height: spacing.sectionGap),
        _Section(
          label: l10n.language,
          child: const AppCard(child: LanguageTile()),
        ),
        SizedBox(height: spacing.sectionGap),
        _Section(label: l10n.sectionAccount, child: const AccountCard()),
      ],
    );
  }
}

class _WideSettings extends StatelessWidget {
  const _WideSettings();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final cardPadding = EdgeInsets.all(spacing.lg + spacing.xxs);

    return ListView(
      padding: EdgeInsets.all(spacing.xxl),
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AppCard(
                  padding: cardPadding,
                  child: _LabelledCardContent(
                    label: l10n.appearance,
                    title: l10n.themeLabel,
                    child: const ThemeModeTile(),
                  ),
                ),
              ),
              SizedBox(width: spacing.sectionGap),
              Expanded(
                child: AppCard(
                  padding: cardPadding,
                  child: _LabelledCardContent(
                    label: l10n.language,
                    title: l10n.appLanguage,
                    child: const LanguageTile(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.sectionGap),
        const AccountCard(inlineSignOut: true),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(label),
        SizedBox(height: context.spacing.sm + context.spacing.xxs / 2),
        child,
      ],
    );
  }
}

class _LabelledCardContent extends StatelessWidget {
  const _LabelledCardContent({
    required this.label,
    required this.title,
    required this.child,
  });

  final String label;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionLabel(label),
        SizedBox(height: context.spacing.md),
        _TitledControl(title: title, child: child),
      ],
    );
  }
}

class _TitledControl extends StatelessWidget {
  const _TitledControl({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: context.textTheme.titleSmall),
        SizedBox(height: context.spacing.sm + context.spacing.xxs),
        child,
      ],
    );
  }
}
