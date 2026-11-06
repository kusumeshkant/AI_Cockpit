// The running app's version (ADR-012): read from the installed package
// (package_info_plus), so `min_app_version` checks and the gateway's
// X-App-Version header see the real build. Falls back to the APP_VERSION
// define (AppConfig.appVersion) when the platform can't tell. Demo mode uses
// a fixed value.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/di/injection.dart';

/// Where the version comes from.
abstract interface class AppVersionSource {
  /// The app version, `x.y.z` (never throws; falls back to the define).
  Future<String> version();
}

/// Installed package version (live builds).
@LazySingleton(as: AppVersionSource, env: [AppEnvironments.live])
class PackageAppVersionSource implements AppVersionSource {
  /// Creates the source.
  PackageAppVersionSource();

  String? _cached;

  @override
  Future<String> version() async {
    if (_cached != null) return _cached!;
    try {
      final info = await PackageInfo.fromPlatform();
      final value = info.version.trim();
      return _cached = value.isEmpty ? AppConfig.appVersion : value;
    } on Object {
      return AppConfig.appVersion;
    }
  }
}

/// Fixed version (demo mode).
@LazySingleton(as: AppVersionSource, env: [AppEnvironments.demo])
class DemoAppVersionSource implements AppVersionSource {
  /// Creates the source.
  const DemoAppVersionSource();

  /// The value demo builds report.
  static const String demoVersion = '1.0.0';

  @override
  Future<String> version() async => demoVersion;
}

/// The installed version once read (`null` while unknown or without DI).
final installedAppVersionProvider = FutureProvider<String?>((ref) async {
  try {
    return await getIt<AppVersionSource>().version();
  } on Object {
    return null;
  }
});

/// The running app's version, compared with `min_app_version` (overridable in
/// tests). Uses the APP_VERSION define until / unless the package is read.
final appVersionProvider = Provider<String>(
  (ref) => ref.watch(installedAppVersionProvider).value ?? AppConfig.appVersion,
);
