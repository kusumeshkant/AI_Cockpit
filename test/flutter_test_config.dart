import 'dart:async';

import 'package:cockpit/core/theme/app_text_styles.dart';

/// Global test setup: google_fonts fetches fonts over HTTP, which widget tests
/// block, so tests render with plain family names instead.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  AppFonts.useGoogleFonts = false;
  await testMain();
}
