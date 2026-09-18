// Feature: actions · Layer: data
// Supabase Realtime notifications for the `action` table. Emits a tick on any
// insert/update the signed-in user can see (RLS applies to Realtime); the
// datasource then refetches. Kept separate so the datasource is unit-testable.
import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';

/// Source of "actions changed" ticks.
abstract interface class ActionChangeSource {
  /// Emits whenever a visible `action` row changes. Cancel to unsubscribe.
  Stream<void> changes();
}

/// Realtime implementation (postgres_changes on `public.action`).
@LazySingleton(as: ActionChangeSource, env: [AppEnvironments.live])
class RealtimeActionChangeSource implements ActionChangeSource {
  /// Creates the source.
  RealtimeActionChangeSource(this._client);

  final SupabaseClient _client;
  int _channelSeq = 0;

  @override
  Stream<void> changes() {
    RealtimeChannel? channel;
    late final StreamController<void> controller;
    controller = StreamController<void>(
      onListen: () {
        channel = _client
            .channel('cockpit-actions-${_channelSeq++}')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: DbTables.action,
              callback: (_) {
                if (!controller.isClosed) controller.add(null);
              },
            )
            .subscribe();
      },
      onCancel: () async {
        final current = channel;
        if (current != null) await _client.removeChannel(current);
      },
    );
    return controller.stream;
  }
}
