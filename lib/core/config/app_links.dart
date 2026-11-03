// Fixed external links (not secrets, not per-environment).

/// Store links.
abstract final class AppLinks {
  /// The Play listing, opened by "Update the app" (release application id).
  static final Uri playStoreListing =
      Uri.parse('https://play.google.com/store/apps/details?id=app.aicockpit.aicockpit');
}
