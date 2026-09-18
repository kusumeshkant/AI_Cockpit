// Feature: actions · Layer: presentation
// Renderer registry: maps an action `type` to its widget. Unknown types always
// fall back to GenericRenderer (TR-5), so agents can send new types safely.
import 'package:flutter/widgets.dart';

import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/presentation/renderers/diff_renderer.dart';
import 'package:cockpit/features/actions/presentation/renderers/email_renderer.dart';
import 'package:cockpit/features/actions/presentation/renderers/generic_renderer.dart';
import 'package:cockpit/features/actions/presentation/renderers/table_renderer.dart';

/// Editing state passed to renderers that support editable fields.
@immutable
class RendererEditing {
  /// Creates the editing state.
  const RendererEditing({required this.enabled, required this.controllers});

  /// Not editing.
  static const RendererEditing off =
      RendererEditing(enabled: false, controllers: {});

  /// Whether editable fields are currently inputs.
  final bool enabled;

  /// Controllers keyed by payload field name.
  final Map<String, TextEditingController> controllers;
}

/// Resolves the body widget for an action.
abstract final class ActionRenderers {
  /// Builds the renderer for [item].
  static Widget build(
    ActionItem item, {
    RendererEditing editing = RendererEditing.off,
  }) =>
      switch (item.type) {
        ActionTypes.email => EmailRenderer(item: item, editing: editing),
        ActionTypes.diff => DiffRenderer(item: item),
        ActionTypes.table => TableRenderer(item: item),
        _ => GenericRenderer(item: item),
      };
}
