import '../entities/auth_session.dart';

abstract class IAuthRepository {
  /// Loads the stored session (refreshing it if needed).
  /// Returns null when there is no valid session.
  Future<AuthSession?> restoreSession();

  /// Throws [AuthException] on failure.
  Future<AuthSession> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Throws [AuthException] on failure.
  Future<AuthSession> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  /// Exchanges the refresh token for new tokens. Returns false on failure.
  /// Stored tokens are only cleared when the server rejects the refresh token.
  Future<bool> refreshTokens();
}