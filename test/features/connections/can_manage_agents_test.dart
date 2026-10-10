// canManageAgentsFrom: the role read → whether "Connect" entry points show.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';

class _User extends Notifier<String> {
  @override
  String build() => 'approver';

  void switchTo(String id) => state = id;
}

void main() {
  test('known owner shows, known approver hides, unknown shows', () {
    expect(canManageAgentsFrom(const AsyncData(true)), isTrue);
    expect(canManageAgentsFrom(const AsyncData(false)), isFalse);
    expect(canManageAgentsFrom(const AsyncData(null)), isTrue);
    expect(canManageAgentsFrom(const AsyncLoading()), isTrue);
    expect(canManageAgentsFrom(AsyncError(Exception('x'), StackTrace.empty)), isTrue);
  });

  test("a user switch doesn't inherit the previous user's hidden entry points", () async {
    // Mirrors the real provider: the role is re-read when the signed-in user
    // changes, and Riverpod keeps the previous value while it reloads.
    final user = NotifierProvider<_User, String>(_User.new);
    final pending = <String, Completer<bool?>>{};
    final role = FutureProvider<bool?>((ref) {
      final id = ref.watch(user);
      return (pending[id] = Completer<bool?>()).future;
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(role, (_, _) {});

    await Future<void>.delayed(Duration.zero);
    pending['approver']!.complete(false);
    await container.read(role.future);
    expect(canManageAgentsFrom(container.read(role)), isFalse, reason: 'approver: hidden');

    container.read(user.notifier).switchTo('owner');
    await Future<void>.delayed(Duration.zero);
    final reloading = container.read(role);
    expect(reloading.isLoading, isTrue);
    expect(reloading.value, isFalse, reason: 'Riverpod still holds the approver value');
    expect(canManageAgentsFrom(reloading), isTrue, reason: 'stale approver value ignored');

    pending['owner']!.complete(true);
    await container.read(role.future);
    expect(canManageAgentsFrom(container.read(role)), isTrue, reason: 'owner: shown');
  });
}
