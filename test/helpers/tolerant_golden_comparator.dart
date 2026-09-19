import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Goldens are rendered and checked on the dev machine only. CI runs Linux
/// with an unpinned stable Flutter, which rasterizes shadows / anti-aliasing
/// differently (1.7–2.5% of pixels) — so golden tests are skipped there
/// (`CI=true`, set by GitHub Actions). Every other test still runs on CI.
final bool skipGoldensOnCi = Platform.environment['CI'] == 'true';

/// Golden comparator tolerating tiny rasterization differences between
/// platforms: goldens are generated on the dev machine, CI runs on Linux.
class TolerantGoldenComparator extends LocalFileComparator {
  /// Creates the comparator for goldens next to [testFile].
  TolerantGoldenComparator(super.testFile, {this.tolerance = 0.005});

  /// Fraction of pixels allowed to differ (0.5% by default).
  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(imageBytes, await getGoldenBytes(golden));
    if (result.passed || result.diffPercent <= tolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

/// Installs a [TolerantGoldenComparator] for the test file [fileName]
/// (resolved next to the default comparator's base directory).
void useTolerantGoldens(String fileName) {
  final base = goldenFileComparator as LocalFileComparator;
  goldenFileComparator = TolerantGoldenComparator(base.basedir.resolve(fileName));
}
