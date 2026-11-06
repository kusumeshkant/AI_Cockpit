// Request ids for agent-service calls: a random UUID v4 per user action, kept
// and reused when that same action is retried (the gateway forwards it as the
// agent's idempotency key). No package: 16 bytes from Random.secure().
import 'dart:math';

final Random _random = Random.secure();

/// A new random UUID v4, e.g. `3f2b8c1e-9a4d-4e7b-8c21-5d6e7f8a9b0c`.
String newRequestId() {
  final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // RFC 4122 variant
  final hex = [for (final b in bytes) b.toRadixString(16).padLeft(2, '0')].join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}

/// Whether [value] is a lowercase UUID v4 as produced by [newRequestId].
bool isRequestId(String value) =>
    RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$').hasMatch(value);
