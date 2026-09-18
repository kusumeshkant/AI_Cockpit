// Route names and paths. Navigate by name (`context.goNamed(RouteNames.x)`)
// so paths can change without touching call sites.

/// Named routes.
abstract final class RouteNames {
  /// Pending actions feed (home).
  static const String feed = 'feed';

  /// Action detail; path parameter `id`.
  static const String actionDetail = 'actionDetail';

  /// Connected agents list.
  static const String connections = 'connections';

  /// Connect a new agent.
  static const String connectAgent = 'connectAgent';

  /// Audit log.
  static const String audit = 'audit';

  /// Settings.
  static const String settings = 'settings';

  /// Sign in.
  static const String signIn = 'signIn';
}

/// Route path templates.
abstract final class RoutePaths {
  /// Home feed.
  static const String feed = '/';

  /// Child of [feed].
  static const String actionDetail = 'actions/:id';

  /// Connections list.
  static const String connections = '/connections';

  /// Child of [connections].
  static const String connectAgent = 'new';

  /// Audit log.
  static const String audit = '/audit';

  /// Settings.
  static const String settings = '/settings';

  /// Sign in.
  static const String signIn = '/sign-in';
}
