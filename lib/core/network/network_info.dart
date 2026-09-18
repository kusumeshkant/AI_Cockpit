// Connectivity check used before network calls and for the offline banner.
import 'package:injectable/injectable.dart';

/// Reports whether the device currently has connectivity.
abstract interface class NetworkInfo {
  /// True when a network connection is available.
  Future<bool> get isConnected;
}

/// Default implementation.
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  /// Creates the implementation.
  const NetworkInfoImpl();

  @override
  Future<bool> get isConnected async {
    // TODO(feature/actions): implement with a connectivity package (needs ADR).
    return true;
  }
}
