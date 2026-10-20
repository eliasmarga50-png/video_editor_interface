import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/errors/auth_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../services/token_storage.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final http.Client _client;
  final TokenStorage _tokens;
  final String _baseUrl;

  AuthRepositoryImpl({
    required http.Client client,
    required TokenStorage tokens,
    String? baseUrl,
  })  : _client = client,
        _tokens = tokens,
        _baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  @override
  Future<AuthSession?> restoreSession() async {
    final String? accessToken = await _tokens.readAccess();
    final String? refreshToken = await _tokens.readRefresh();

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    // Validate the token against the server
    try {
      final res = await _client.get(
        _uri('/api/v1/auth/me'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
        return AuthSession(
          accessToken: accessToken,
          refreshToken: refreshToken,
          user: user,
        );
      }

      if (res.statusCode == 401) {
        // Access token might be expired; attempt token refresh
        final refreshed = await refreshTokens();
        if (!refreshed) return null;

        final newAccess = await _tokens.readAccess();
        final newRefresh = await _tokens.readRefresh();
        if (newAccess == null || newRefresh == null) return null;

        final retryRes = await _client.get(
          _uri('/api/v1/auth/me'),
          headers: {'Authorization': 'Bearer $newAccess'},
        );

        if (retryRes.statusCode == 200) {
          final data = jsonDecode(retryRes.body) as Map<String, dynamic>;
          final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
          return AuthSession(
            accessToken: newAccess,
            refreshToken: newRefresh,
            user: user,
          );
        }
      }
    } catch (_) {
      // Network issues during restore session; fail gracefully
      return null;
    }

    return null;
  }

  @override
  Future<AuthSession> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final http.Response res;
    try {
      res = await _client.post(
        _uri('/api/v1/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );
    } catch (e) {
      throw const AuthException(
        AuthErrorCode.network,
        'Could not connect to CineAI server. Check your connection.',
      );
    }

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw const AuthException(AuthErrorCode.server, 'Invalid server response');
    }

    if (res.statusCode == 201) {
      final String accessToken = body['accessToken'] as String;
      final String refreshToken = body['refreshToken'] as String;
      final user = AuthUser.fromJson(body['user'] as Map<String, dynamic>);

      await _tokens.save(access: accessToken, refresh: refreshToken);

      return AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
      );
    }

    final String message = body['message']?.toString() ?? 'Failed to create account.';
    if (res.statusCode == 409) {
      throw AuthException(AuthErrorCode.emailInUse, message);
    } else if (res.statusCode == 400) {
      throw AuthException(AuthErrorCode.validation, message);
    }

    throw AuthException(AuthErrorCode.server, message);
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final http.Response res;
    try {
      res = await _client.post(
        _uri('/api/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );
    } catch (e) {
      throw const AuthException(
        AuthErrorCode.network,
        'Could not connect to CineAI server. Check your connection.',
      );
    }

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw const AuthException(AuthErrorCode.server, 'Invalid server response');
    }

    if (res.statusCode == 200) {
      final String accessToken = body['accessToken'] as String;
      final String refreshToken = body['refreshToken'] as String;
      final user = AuthUser.fromJson(body['user'] as Map<String, dynamic>);

      await _tokens.save(access: accessToken, refresh: refreshToken);

      return AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
      );
    }

    final String message = body['message']?.toString() ?? 'Invalid email or password.';
    if (res.statusCode == 401) {
      throw AuthException(AuthErrorCode.invalidCredentials, message);
    }

    throw AuthException(AuthErrorCode.server, message);
  }

  @override
  Future<void> signOut() async {
    final String? refreshToken = await _tokens.readRefresh();
    if (refreshToken != null) {
      try {
        await _client.post(
          _uri('/api/v1/auth/logout'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        );
      } catch (_) {
        // Ignore logout errors
      }
    }
    await _tokens.clear();
  }

  @override
  Future<bool> refreshTokens() async {
    final String? refreshToken = await _tokens.readRefresh();
    if (refreshToken == null) return false;

    try {
      final res = await _client.post(
        _uri('/api/v1/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final String newAccess = data['accessToken'] as String;
        final String newRefresh = data['refreshToken'] as String;
        await _tokens.save(access: newAccess, refresh: newRefresh);
        return true;
      }

      if (res.statusCode == 401) {
        // Refresh token was rejected by server; invalidate stored credentials
        await _tokens.clear();
        return false;
      }
    } catch (_) {
      // Offline or temporary network glitch: do not clear tokens
      return false;
    }

    return false;
  }
}
