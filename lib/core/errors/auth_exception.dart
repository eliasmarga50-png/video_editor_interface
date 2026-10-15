enum AuthErrorCode {
  invalidCredentials,
  emailInUse,
  validation,
  network,
  server,
}

class AuthException implements Exception {
  final AuthErrorCode code;
  final String message;

  const AuthException(this.code, this.message);

  @override
  String toString() => message;
}