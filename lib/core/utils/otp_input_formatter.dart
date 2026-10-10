// Formats a one-time-code field: keeps digits only (so a pasted "123 456" or
// "123-456" becomes "123456") and cuts at the code length.
import 'package:flutter/services.dart';

/// Digits-only, length-capped input for a one-time code.
class OtpInputFormatter extends TextInputFormatter {
  /// Creates a formatter for codes of [length] digits.
  const OtpInputFormatter(this.length);

  /// Code length.
  final int length;

  static final RegExp _nonDigits = RegExp(r'\D');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(_nonDigits, '');
    if (digits.length > length) digits = digits.substring(0, length);
    if (digits == newValue.text) return newValue;
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}
