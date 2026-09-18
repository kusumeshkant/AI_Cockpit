// Feature: actions · Layer: presentation
// Feed state: pending actions plus recently decided ones, streamed from the
// repository. Failures surface as AsyncError.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/features/actions/domain/entities/action_item.dart';
import 'package:cockpit/features/actions/domain/usecases/watch_pending_actions.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';

/// Actions feed controller.
class ActionsFeedController extends StreamNotifier<List<ActionItem>> {
  @override
  Stream<List<ActionItem>> build() {
    // Resubscribe for a different signed-in user (tabs stay alive in the
    // shell). Realtime + 30s poll reconcile live in the live datasource (TR-4).
    ref.watch(authControllerProvider.select((auth) => auth.value?.id));
    return getIt<WatchPendingActions>()().map(
      (result) => result.fold((failure) => throw failure, (items) => items),
    );
  }

  /// Re-subscribes to the feed (pull-to-refresh, app resume).
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// Actions shown in the feed.
final actionsFeedControllerProvider =
    StreamNotifierProvider<ActionsFeedController, List<ActionItem>>(
  ActionsFeedController.new,
);

/// Number of actions awaiting a decision (drives the header and nav badge).
final pendingCountProvider = Provider<int>((ref) {
  final items = ref.watch(actionsFeedControllerProvider).value ?? const [];
  return items.where((item) => item.isPending).length;
});
