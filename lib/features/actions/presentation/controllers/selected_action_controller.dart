// Feature: actions · Layer: presentation
// Selected action in the tablet master–detail feed.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/features/actions/domain/entities/action_item.dart';

/// Holds the id the user picked; `null` until they pick one.
class SelectedActionController extends Notifier<String?> {
  @override
  String? build() => null;

  /// Selects [id].
  void choose(String id) => state = id;

  /// Resolves the id to show: the picked one if still in [items], otherwise
  /// the first pending action, otherwise the first action.
  String? resolve(List<ActionItem> items) {
    final picked = state;
    if (picked != null && items.any((item) => item.id == picked)) return picked;
    for (final item in items) {
      if (item.isPending) return item.id;
    }
    return items.isEmpty ? null : items.first.id;
  }
}

/// Selected action id.
final selectedActionIdProvider =
    NotifierProvider<SelectedActionController, String?>(
  SelectedActionController.new,
);
