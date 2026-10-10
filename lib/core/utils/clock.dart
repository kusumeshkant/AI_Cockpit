// The current time, behind a provider so countdowns can be tested with a
// controllable clock.
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns "now".
typedef Clock = DateTime Function();

/// Wall clock; override in tests.
final clockProvider = Provider<Clock>((ref) => DateTime.now);
