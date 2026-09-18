// Width breakpoints (Material 3 window size classes) plus content-width
// thresholds for multi-pane layouts.

/// Window size class.
enum ScreenSize {
  /// < 600 — phones: bottom nav, single column.
  compact,

  /// 600–839 — large phones, small tablets, foldables: left rail.
  medium,

  /// 840–1199 — tablets.
  expanded,

  /// ≥ 1200 — large tablets / desktop.
  large,
}

/// Breakpoint values in logical pixels.
abstract final class Breakpoints {
  /// Start of [ScreenSize.medium]; the rail replaces the bottom nav here.
  static const double medium = 600;

  /// Start of [ScreenSize.expanded].
  static const double expanded = 840;

  /// Start of [ScreenSize.large].
  static const double large = 1200;

  /// Minimum *content* width (excluding the rail) for the master–detail feed:
  /// a 340px list plus a usable detail pane. Measured on content, not the
  /// window, because the 212px rail already takes space at [medium].
  static const double masterDetailMinWidth = 680;

  /// Minimum content width for two-column settings.
  static const double twoColumnMinWidth = 520;

  /// Classifies a [width].
  static ScreenSize of(double width) {
    if (width >= large) return ScreenSize.large;
    if (width >= expanded) return ScreenSize.expanded;
    if (width >= medium) return ScreenSize.medium;
    return ScreenSize.compact;
  }
}
