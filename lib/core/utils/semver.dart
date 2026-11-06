// Numeric `x.y.z` version comparison (a `+build` / `-pre` suffix is ignored).
// Used for `min_app_version` gates. Pure Dart.

/// [x, y, z] of [version], or `null` when it isn't `x.y.z`.
List<int>? parseVersion(String? version) {
  final match = RegExp(r'^(\d+)\.(\d+)\.(\d+)(?:[+-].*)?$').firstMatch((version ?? '').trim());
  if (match == null) return null;
  return [for (var i = 1; i <= 3; i++) int.parse(match.group(i)!)];
}

/// Whether [appVersion] is below [minVersion]. No minimum → `false`; an
/// unreadable app version with a minimum set → `true` (fail closed).
bool isVersionBelow(String appVersion, String? minVersion) {
  final min = parseVersion(minVersion);
  if (min == null) return false;
  final have = parseVersion(appVersion);
  if (have == null) return true;
  for (var i = 0; i < 3; i++) {
    if (have[i] != min[i]) return have[i] < min[i];
  }
  return false;
}
