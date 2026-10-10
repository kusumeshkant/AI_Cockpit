// Feature: auth · Layer: domain
// The email-address rule for sign-in (F27): one place for the screen's inline
// check and the SignIn use case.

/// Email address validation.
abstract final class EmailAddress {
  static final RegExp _pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// [value] without surrounding whitespace.
  static String normalize(String value) => value.trim();

  /// Whether [value] looks like a deliverable email address.
  static bool isValid(String value) => _pattern.hasMatch(normalize(value));
}
