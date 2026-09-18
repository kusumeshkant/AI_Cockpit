// Spacing, radius, size and layout tokens (design-spec.md §1). The only place
// layout numbers are defined; widgets read them via `context.spacing`.
import 'package:flutter/material.dart';

/// Layout tokens. Identical in light and dark themes.
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  /// Creates the token set.
  const AppSpacing();

  /// Default tokens.
  static const AppSpacing standard = AppSpacing();

  // ---- Spacing scale ------------------------------------------------------

  /// 2 — hairline gaps.
  double get xxs => 2;

  /// 4.
  double get xs => 4;

  /// 8.
  double get sm => 8;

  /// 12.
  double get md => 12;

  /// 16.
  double get lg => 16;

  /// 22.
  double get xl => 22;

  /// 28 — wide gutters (sign-in).
  double get xxl => 28;

  // ---- Layout -------------------------------------------------------------

  /// Horizontal/vertical screen padding for lists.
  double get screenPadding => 14;

  /// Inner padding of cards.
  double get cardPadding => 14;

  /// Gap between stacked cards.
  double get cardGap => 11;

  /// Gap between settings sections.
  double get sectionGap => 18;

  // ---- Radii --------------------------------------------------------------

  /// Cards.
  double get radiusCard => 15;

  /// Panels, inputs, banners.
  double get radiusPanel => 12;

  /// Buttons.
  double get radiusButton => 11;

  /// Segmented chips, icon buttons, rail items.
  double get radiusSegment => 10;

  /// Inset fields (credentials).
  double get radiusField => 9;

  /// Pills and chips (fully rounded).
  double get radiusPill => 100;

  // ---- Controls -----------------------------------------------------------

  /// Standard button height.
  double get buttonHeight => 48;

  /// Compact button height (app-bar actions).
  double get buttonHeightCompact => 36;

  /// Text input height.
  double get inputHeight => 48;

  /// Segmented chip height.
  double get segmentHeight => 40;

  /// Minimum tap target.
  double get minTapTarget => 44;

  /// Width of the fixed-size Edit button in the decision bar.
  double get editButtonWidth => 66;

  /// Hairline border.
  double get borderThin => 1;

  /// Outline-button border.
  double get borderMedium => 1.5;

  /// Selected-card border.
  double get borderThick => 2;

  // ---- Icons & marks ------------------------------------------------------

  /// Inline icons (inside buttons, fields).
  double get iconSm => 16;

  /// Default icons (app bar, rail).
  double get iconMd => 20;

  /// Bottom-nav icons.
  double get iconLg => 22;

  /// Empty/error illustration icons.
  double get iconXl => 40;

  /// Status dot inside pills.
  double get dotSm => 6;

  /// Bare status dot / count dot.
  double get dotMd => 8;

  /// Timeline dot.
  double get dotLg => 11;

  /// Timeline connector width.
  double get connectorWidth => 2;

  /// Agent icon tile.
  double get tileSize => 42;

  /// Account avatar.
  double get avatarSize => 40;

  /// Sign-in brand mark.
  double get brandMarkLarge => 44;

  /// Rail brand mark.
  double get brandMarkSmall => 30;

  /// App-bar icon button.
  double get iconButtonSize => 36;

  /// Width of the To/Subject label column in the email renderer.
  double get fieldLabelWidth => 56;

  // ---- Responsive ---------------------------------------------------------

  /// Left navigation rail width (≥ medium breakpoint).
  double get railWidth => 212;

  /// Master list column width in master–detail layouts.
  double get listPaneWidth => 340;

  /// Max readable width of detail content.
  double get detailMaxWidth => 560;

  /// Max width of centered single-column forms (sign-in).
  double get formMaxWidth => 420;

  @override
  AppSpacing copyWith() => this;

  @override
  AppSpacing lerp(covariant ThemeExtension<AppSpacing>? other, double t) =>
      this;
}
