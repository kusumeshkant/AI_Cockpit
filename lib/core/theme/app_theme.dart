// Builds light and dark ThemeData from the design tokens and exposes
// `context.colors` / `context.spacing` / `context.textTheme` shortcuts, plus
// script-aware label helpers (`context.monoLabel`, `labelCase`,
// `labelTracking`). [AppTheme.localize] adapts a theme's labels to a locale;
// LocalizedTypography applies it app-wide.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_colors.dart';
import 'package:cockpit/core/theme/app_spacing.dart';
import 'package:cockpit/core/theme/app_text_styles.dart';

/// Theme factory.
abstract final class AppTheme {
  /// Light theme.
  static ThemeData buildLight() => _build(Brightness.light, AppColors.light);

  /// Dark theme.
  static ThemeData buildDark() => _build(Brightness.dark, AppColors.dark);

  /// [theme] with its mono label styles (text theme + tooltips) adapted to
  /// [locale]'s script. Returns [theme] itself for Latin locales.
  static ThemeData localize(ThemeData theme, Locale? locale) {
    if (!AppTextStyles.isDevanagari(locale)) return theme;
    return theme.copyWith(
      textTheme: AppTextStyles.localizeLabels(theme.textTheme, locale),
      tooltipTheme: theme.tooltipTheme.copyWith(
        textStyle: AppTextStyles.forLocale(
          theme.tooltipTheme.textStyle,
          locale,
        ),
      ),
    );
  }

  static ThemeData _build(Brightness brightness, AppColors colors) {
    const spacing = AppSpacing.standard;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: colors.accent,
      onPrimary: colors.onFill,
      primaryContainer: colors.accentWash,
      onPrimaryContainer: colors.accentInk,
      secondary: colors.accentBright,
      onSecondary: colors.onFill,
      error: colors.stop,
      onError: colors.onFill,
      errorContainer: colors.stopBg,
      onErrorContainer: colors.stop,
      surface: colors.surface,
      onSurface: colors.ink,
      onSurfaceVariant: colors.muted,
      surfaceContainerHighest: colors.surfaceAlt,
      outline: colors.lineStrong,
      outlineVariant: colors.line,
    );
    final textTheme = AppTextStyles.textTheme.apply(
      bodyColor: colors.ink,
      displayColor: colors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.paper,
      canvasColor: colors.paper,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[colors, spacing],
      dividerTheme: DividerThemeData(
        color: colors.line,
        thickness: spacing.borderThin,
        space: spacing.borderThin,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.accent,
        selectionHandleColor: colors.accent,
        selectionColor: colors.accentWash,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: colors.paper),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusPanel),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.accent),
      tooltipTheme: TooltipThemeData(
        textStyle: textTheme.labelMedium?.copyWith(color: colors.paper),
        decoration: BoxDecoration(
          color: colors.ink,
          borderRadius: BorderRadius.circular(spacing.radiusField),
        ),
      ),
    );
  }
}

/// Shortcuts to theme tokens.
extension ThemeContextX on BuildContext {
  /// Semantic colors of the active theme.
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  /// Spacing tokens of the active theme.
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;

  /// Text theme of the active theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Whether the active theme is dark.
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  /// Mono 11 for localized labels (filter chips, counts), adapted to the
  /// active script. Data that needs monospace uses AppTextStyles.monoData.
  TextStyle get monoLabel => AppTextStyles.forLocale(
    AppTextStyles.monoData,
    Localizations.maybeLocaleOf(this),
  )!;

  /// [text] in label case: uppercase for cased scripts (Latin), unchanged
  /// for caseless ones (Devanagari).
  String labelCase(String text) =>
      AppTextStyles.isDevanagari(Localizations.maybeLocaleOf(this))
      ? text
      : text.toUpperCase();

  /// Label tracking of [em] × [style]'s font size, or 0 where tracking would
  /// break the script (Devanagari conjuncts).
  double labelTracking(TextStyle? style, double em) =>
      AppTextStyles.isDevanagari(Localizations.maybeLocaleOf(this))
      ? 0
      : (style?.fontSize ?? 0) * em;

  /// Card shadow: `0 1px 2px ink@5%` in light, none in dark (border only).
  List<BoxShadow> get cardShadow => isDarkTheme
      ? const <BoxShadow>[]
      : [
          BoxShadow(
            color: colors.ink.withValues(alpha: 0.05),
            offset: Offset(0, spacing.borderThin),
            blurRadius: spacing.xxs,
          ),
        ];

  /// Soft colored shadow under primary / success buttons (light only).
  List<BoxShadow> fillShadow(Color color) => isDarkTheme
      ? const <BoxShadow>[]
      : [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            offset: Offset(0, spacing.xs),
            blurRadius: spacing.md,
            spreadRadius: -spacing.xs,
          ),
        ];
}
