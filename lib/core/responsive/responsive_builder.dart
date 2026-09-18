// Builds different layouts from the available width using LayoutBuilder.
import 'package:flutter/widgets.dart';

import 'package:cockpit/core/responsive/breakpoints.dart';

/// Signature for [ResponsiveBuilder.builder].
typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  ScreenSize size,
  BoxConstraints constraints,
);

/// Rebuilds with the [ScreenSize] derived from its own constraints.
class ResponsiveBuilder extends StatelessWidget {
  /// Creates a responsive builder.
  const ResponsiveBuilder({required this.builder, super.key});

  /// Layout builder for the resolved size class.
  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) =>
            builder(context, Breakpoints.of(constraints.maxWidth), constraints),
      );
}
