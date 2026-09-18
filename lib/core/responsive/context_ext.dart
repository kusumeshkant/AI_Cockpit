// Screen-size helpers on BuildContext (based on the window, not the parent).
// Prefer ResponsiveBuilder when a widget should adapt to its own constraints.
import 'package:flutter/widgets.dart';

import 'package:cockpit/core/responsive/breakpoints.dart';

/// Responsive shortcuts.
extension ResponsiveContextX on BuildContext {
  /// Size class of the current window.
  ScreenSize get screenSize => Breakpoints.of(MediaQuery.sizeOf(this).width);

  /// Phone-sized window.
  bool get isMobile => screenSize == ScreenSize.compact;

  /// Tablet-sized window (medium or expanded).
  bool get isTablet =>
      screenSize == ScreenSize.medium || screenSize == ScreenSize.expanded;

  /// Large window.
  bool get isLarge => screenSize == ScreenSize.large;
}
