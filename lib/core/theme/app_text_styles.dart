// Type scale (design-spec.md §1): Archivo for display/headings, IBM Plex Sans
// for body, IBM Plex Mono for labels, status and data. Fonts come from the
// google_fonts package. Colors are applied by ThemeData / widgets.
//
// Labels are script-aware: IBM Plex Mono has no Devanagari, and tracking or
// uppercasing breaks Devanagari conjuncts. For Devanagari locales the mono
// label styles switch to IBM Plex Sans Devanagari with no tracking and no case
// transform (see [AppTextStyles.forLocale]). Latin is untouched.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Font family resolution.
abstract final class AppFonts {
  /// When false, styles use plain family names instead of google_fonts.
  /// Set to false in `test/flutter_test_config.dart`: google_fonts fetches
  /// over HTTP, which widget tests block.
  static bool useGoogleFonts = true;

  /// Archivo (display / headings).
  static TextStyle archivo(TextStyle style) => useGoogleFonts
      ? GoogleFonts.archivo(textStyle: style)
      : style.copyWith(fontFamily: 'Archivo');

  /// IBM Plex Sans (body).
  static TextStyle plexSans(TextStyle style) => useGoogleFonts
      ? GoogleFonts.ibmPlexSans(textStyle: style)
      : style.copyWith(fontFamily: 'IBM Plex Sans');

  /// IBM Plex Mono (labels, status, data).
  static TextStyle plexMono(TextStyle style) => useGoogleFonts
      ? GoogleFonts.ibmPlexMono(textStyle: style)
      : style.copyWith(fontFamily: 'IBM Plex Mono');

  /// IBM Plex Sans Devanagari (labels in Devanagari locales).
  static TextStyle plexSansDevanagari(TextStyle style) => useGoogleFonts
      ? GoogleFonts.ibmPlexSansDevanagari(textStyle: style)
      : style.copyWith(fontFamily: 'IBM Plex Sans Devanagari');
}

/// Cockpit's text styles.
///
/// | Slot | Font | Use |
/// |---|---|---|
/// | displayLarge | Archivo 800 23 | Screen titles |
/// | displayMedium | Archivo 800 26 | Brand wordmark |
/// | headlineSmall | Archivo 700 22 | Sign-in headline |
/// | titleLarge | Archivo 700 17 | App-bar & action titles |
/// | titleMedium | Plex Sans 600 15 | Card titles |
/// | titleSmall | Plex Sans 600 14 | Row titles |
/// | bodyLarge | Plex Sans 400 14.5 | Input text |
/// | bodyMedium | Plex Sans 400 13.5 | Body / email text |
/// | bodySmall | Plex Sans 400 12 | Card previews |
/// | labelLarge | Plex Sans 600 14 | Buttons |
/// | labelMedium | Plex Mono 500 10 | Section labels, sources, timestamps |
/// | labelSmall | Plex Mono 600 9.5 | Status pills, nav labels |
abstract final class AppTextStyles {
  /// Full text theme, merged into [ThemeData.textTheme].
  static TextTheme get textTheme => TextTheme(
        displayLarge: AppFonts.archivo(
          const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.46,
            height: 1.2,
          ),
        ),
        displayMedium: AppFonts.archivo(
          const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.52,
            height: 1.15,
          ),
        ),
        headlineSmall: AppFonts.archivo(
          const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.22,
            height: 1.25,
          ),
        ),
        titleLarge: AppFonts.archivo(
          const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.17,
            height: 1.3,
          ),
        ),
        titleMedium: AppFonts.plexSans(
          const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.3),
        ),
        titleSmall: AppFonts.plexSans(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.35),
        ),
        bodyLarge: AppFonts.plexSans(
          const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w400, height: 1.4),
        ),
        bodyMedium: AppFonts.plexSans(
          const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400, height: 1.5),
        ),
        bodySmall: AppFonts.plexSans(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.45),
        ),
        labelLarge: AppFonts.plexSans(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2),
        ),
        labelMedium: AppFonts.plexMono(
          const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            height: 1.35,
          ),
        ),
        labelSmall: AppFonts.plexMono(
          const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.57,
            height: 1.3,
          ),
        ),
      );

  /// Mono 11 — counts, filter chips, credential values. Localized text
  /// (chips, counts) goes through `context.monoLabel`, which adapts to the
  /// script; use this directly only for data that needs monospace (JSON,
  /// diffs, secrets).
  static TextStyle get monoData => AppFonts.plexMono(
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.35),
      );

  /// Languages written in Devanagari: no letter case, and conjuncts that
  /// break under tracking.
  static const Set<String> _devanagariLanguages = {'hi', 'mr', 'ne', 'sa', 'kok', 'mai'};

  /// Whether [locale] is written in Devanagari.
  static bool isDevanagari(Locale? locale) =>
      locale != null &&
      (locale.scriptCode == 'Deva' || _devanagariLanguages.contains(locale.languageCode));

  /// Label treatment for [locale]: [style] unchanged for Latin, or a
  /// Devanagari-capable, untracked copy for Devanagari (size, weight, height
  /// and color kept).
  static TextStyle? forLocale(TextStyle? style, Locale? locale) {
    if (style == null || !isDevanagari(locale)) return style;
    return AppFonts.plexSansDevanagari(style.copyWith(letterSpacing: 0));
  }

  /// [theme]'s mono label slots (labelMedium, labelSmall) adapted to [locale].
  static TextTheme localizeLabels(TextTheme theme, Locale? locale) {
    if (!isDevanagari(locale)) return theme;
    return theme.copyWith(
      labelMedium: forLocale(theme.labelMedium, locale),
      labelSmall: forLocale(theme.labelSmall, locale),
    );
  }
}
