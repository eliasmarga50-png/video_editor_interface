class Validators {
  Validators._();

  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _letter = RegExp(r'[A-Za-z]');
  static final RegExp _digit = RegExp(r'\d');

  static String? name(String? value) {
    if ((value ?? '').trim().length < 2) return 'Enter your name';
    return null;
  }

  static String? email(String? value) {
    final String v = (value ?? '').trim();
    if (v.isEmpty) return 'Enter your email';
    if (!_email.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  /// Used on sign-in: only checks that something was typed.
  static String? required(String? value) {
    if ((value ?? '').isEmpty) return 'Enter your password';
    return null;
  }

  /// Used on sign-up: same rule the server enforces.
  static String? newPassword(String? value) {
    final String v = value ?? '';
    if (v.length < 8) return 'Use at least 8 characters';
    if (!_letter.hasMatch(v) || !_digit.hasMatch(v)) {
      return 'Include a letter and a number';
    }
    return null;
  }

  static String? Function(String?) confirm(
    String Function() original,
  ) {
    return (value) => value == original() ? null : 'Passwords do not match';
  }
}