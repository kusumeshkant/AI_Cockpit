// Minimum tap target without changing how a control looks. The control keeps
// its visual size and sits centered in a box of at least [minSize]; taps in
// the surrounding band are redirected to the control's center, so it reacts
// (ripple included) as if tapped directly. Same mechanism as Material's
// `MaterialTapTargetSize.padded` for its own buttons and chips.
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Pads [child]'s hit area (and layout) up to [minSize].
class TapTargetPadding extends SingleChildRenderObjectWidget {
  /// Creates the padding.
  const TapTargetPadding({
    required this.minSize,
    required Widget super.child,
    super.key,
  });

  /// Smallest tappable size (e.g. `Size.square(spacing.minTapTarget)`).
  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderTapTargetPadding(minSize);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTapTargetPadding renderObject,
  ) {
    renderObject.minSize = minSize;
  }
}

/// Render object for [TapTargetPadding].
class RenderTapTargetPadding extends RenderShiftedBox {
  /// Creates the render object.
  RenderTapTargetPadding(this._minSize) : super(null);

  /// Smallest tappable size.
  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) return;
    _minSize = value;
    markNeedsLayout();
  }

  Size _padded(Size childSize, BoxConstraints constraints) =>
      constraints.constrain(
        Size(
          math.max(childSize.width, _minSize.width),
          math.max(childSize.height, _minSize.height),
        ),
      );

  @override
  double computeMinIntrinsicWidth(double height) =>
      math.max(super.computeMinIntrinsicWidth(height), _minSize.width);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      math.max(super.computeMaxIntrinsicWidth(height), _minSize.width);

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(super.computeMinIntrinsicHeight(width), _minSize.height);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      math.max(super.computeMaxIntrinsicHeight(width), _minSize.height);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) return constraints.constrain(_minSize);
    return _padded(child.getDryLayout(constraints), constraints);
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.constrain(_minSize);
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    size = _padded(child.size, constraints);
    (child.parentData! as BoxParentData).offset = Alignment.center.alongOffset(
      size - child.size as Offset,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) return true;
    final child = this.child;
    if (child == null || !size.contains(position)) return false;
    // A tap in the padding band counts as a tap on the control's center.
    final center = child.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (result, position) => child.hitTest(result, position: center),
    );
  }
}
