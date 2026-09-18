// Semantic color tokens as a ThemeExtension. Values are copied exactly from
// technical/design/design-spec.md §1 — this is the ONLY file allowed to
// contain color literals. Widgets read colors via `context.colors`.
import 'package:flutter/material.dart';

/// Cockpit's semantic color palette.
///
/// Semantics: amber ([pending]) = awaiting a decision, green ([go]) =
/// approve / live, red ([stop]) = reject / danger. [accent] is for primary
/// actions and active navigation only — never a status color.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Creates a palette.
  const AppColors({
    required this.paper,
    required this.surface,
    required this.surfaceAlt,
    required this.ink,
    required this.inkSoft,
    required this.muted,
    required this.line,
    required this.lineStrong,
    required this.accent,
    required this.accentBright,
    required this.accentInk,
    required this.accentWash,
    required this.pending,
    required this.pendingBg,
    required this.go,
    required this.goBg,
    required this.stop,
    required this.stopBg,
  });

  /// Light palette.
  static const AppColors light = AppColors(
    paper: Color(0xFFF1F4F6),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF6F8FA),
    ink: Color(0xFF12202B),
    inkSoft: Color(0xFF3A4A58),
    muted: Color(0xFF5D6B78),
    line: Color(0xFFD9DFE4),
    lineStrong: Color(0xFFBCC7D0),
    accent: Color(0xFF0D6A83),
    accentBright: Color(0xFF1394B2),
    accentInk: Color(0xFF08414F),
    accentWash: Color(0xFFE2EFF3),
    pending: Color(0xFFB26A05),
    pendingBg: Color(0xFFFBEECF),
    go: Color(0xFF1C7F4E),
    goBg: Color(0xFFDCEFE3),
    stop: Color(0xFFB93B2C),
    stopBg: Color(0xFFF6DCD7),
  );

  /// Dark palette.
  static const AppColors dark = AppColors(
    paper: Color(0xFF0C141C),
    surface: Color(0xFF16212C),
    surfaceAlt: Color(0xFF1B2836),
    ink: Color(0xFFE7EDF2),
    inkSoft: Color(0xFFB3C1CC),
    muted: Color(0xFF8595A2),
    line: Color(0xFF26343F),
    lineStrong: Color(0xFF374956),
    accent: Color(0xFF1EA6C6),
    accentBright: Color(0xFF3FC2DF),
    accentInk: Color(0xFFBFE8F2),
    accentWash: Color(0xFF122D38),
    pending: Color(0xFFE6A848),
    pendingBg: Color(0xFF3A2C12),
    go: Color(0xFF4BBD83),
    goBg: Color(0xFF12301F),
    stop: Color(0xFFE0705F),
    stopBg: Color(0xFF381914),
  );

  /// Scaffold background.
  final Color paper;

  /// Cards, bars, sheets.
  final Color surface;

  /// Subtle inset surfaces (code/credential fields).
  final Color surfaceAlt;

  /// Primary text.
  final Color ink;

  /// Secondary text (body copy inside cards).
  final Color inkSoft;

  /// Tertiary text, labels, inactive icons.
  final Color muted;

  /// Hairline borders and dividers.
  final Color line;

  /// Input and outline-button borders.
  final Color lineStrong;

  /// Primary actions and active navigation.
  final Color accent;

  /// Brighter accent (brand gradient start).
  final Color accentBright;

  /// Text on [accentWash].
  final Color accentInk;

  /// Tinted accent background (summaries, active rail item).
  final Color accentWash;

  /// Pending status (amber).
  final Color pending;

  /// Pending status background.
  final Color pendingBg;

  /// Approve / live status (green).
  final Color go;

  /// Approve / live background.
  final Color goBg;

  /// Reject / danger (red).
  final Color stop;

  /// Reject / danger background.
  final Color stopBg;

  /// Foreground on solid [accent] / [go] fills. Equals [surface]: pure white
  /// in light mode and dark ink in dark mode, where white on the brighter
  /// dark-theme fills would fail contrast.
  Color get onFill => surface;

  @override
  AppColors copyWith({
    Color? paper,
    Color? surface,
    Color? surfaceAlt,
    Color? ink,
    Color? inkSoft,
    Color? muted,
    Color? line,
    Color? lineStrong,
    Color? accent,
    Color? accentBright,
    Color? accentInk,
    Color? accentWash,
    Color? pending,
    Color? pendingBg,
    Color? go,
    Color? goBg,
    Color? stop,
    Color? stopBg,
  }) =>
      AppColors(
        paper: paper ?? this.paper,
        surface: surface ?? this.surface,
        surfaceAlt: surfaceAlt ?? this.surfaceAlt,
        ink: ink ?? this.ink,
        inkSoft: inkSoft ?? this.inkSoft,
        muted: muted ?? this.muted,
        line: line ?? this.line,
        lineStrong: lineStrong ?? this.lineStrong,
        accent: accent ?? this.accent,
        accentBright: accentBright ?? this.accentBright,
        accentInk: accentInk ?? this.accentInk,
        accentWash: accentWash ?? this.accentWash,
        pending: pending ?? this.pending,
        pendingBg: pendingBg ?? this.pendingBg,
        go: go ?? this.go,
        goBg: goBg ?? this.goBg,
        stop: stop ?? this.stop,
        stopBg: stopBg ?? this.stopBg,
      );

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      paper: c(paper, other.paper),
      surface: c(surface, other.surface),
      surfaceAlt: c(surfaceAlt, other.surfaceAlt),
      ink: c(ink, other.ink),
      inkSoft: c(inkSoft, other.inkSoft),
      muted: c(muted, other.muted),
      line: c(line, other.line),
      lineStrong: c(lineStrong, other.lineStrong),
      accent: c(accent, other.accent),
      accentBright: c(accentBright, other.accentBright),
      accentInk: c(accentInk, other.accentInk),
      accentWash: c(accentWash, other.accentWash),
      pending: c(pending, other.pending),
      pendingBg: c(pendingBg, other.pendingBg),
      go: c(go, other.go),
      goBg: c(goBg, other.goBg),
      stop: c(stop, other.stop),
      stopBg: c(stopBg, other.stopBg),
    );
  }
}
