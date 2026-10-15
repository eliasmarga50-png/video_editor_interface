import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/errors/auth_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../infrastructure/network/authed_api.dart';
import '../../infrastructure/repositories/auth_repository_impl.dart';
import '../../infrastructure/services/token_storage.dart';

// -----------------------------------------------------------------------------
// Infrastructure providers
// -----------------------------------------------------------------------------
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return const TokenStorage();
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    client: ref.watch(httpClientProvider),
    tokens: ref.watch(tokenStorageProvider),
  );
});

/// Use this for every protected backend call.
final authedApiProvider = Provider<AuthedApi>((ref) {
  final repo = ref.watch(authRepositoryProvider);

  return AuthedApi(
    client: ref.watch(httpClientProvider),
    tokens: ref.watch(tokenStorageProvider),
    refresh: repo.refreshTokens,
    onSessionExpired: () =>
        ref.read(authControllerProvider.notifier).sessionExpired(),
  );
});

// -----------------------------------------------------------------------------
// Auth state
// -----------------------------------------------------------------------------
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final AuthUser? user;
  final bool busy;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.busy = false,
    this.error,
  });

  AuthState copyWith({bool? busy, String? error, bool clearError = false}) {
    return AuthState(
      status: status,
      user: user,
      busy: busy ?? this.busy,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthController extends Notifier<AuthState> {
  IAuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    Future.microtask(_restore);
    return const AuthState();
  }

  Future<void> _restore() async {
    try {
      final AuthSession? session = await _repo.restoreSession();
      state = session == null
          ? const AuthState(status: AuthStatus.unauthenticated)
          : AuthState(status: AuthStatus.authenticated, user: session.user);
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> signIn({required String email, required String password}) {
    return _run(() => _repo.signIn(email: email, password: password));
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _run(
      () => _repo.signUp(name: name, email: email, password: password),
    );
  }

  Future<bool> _run(Future<AuthSession> Function() action) async {
    state = state.copyWith(busy: true, clearError: true);

    try {
      final AuthSession session = await action();
      state = AuthState(
        status: AuthStatus.authenticated,
        user: session.user,
      );
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(busy: false, error: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        busy: false,
        error: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Called by [AuthedApi] when the server rejects the refresh token.
  void sessionExpired() {
    if (state.status != AuthStatus.authenticated) return;
    state = const AuthState(
      status: AuthStatus.unauthenticated,
      error: 'Your session expired. Please sign in again.',
    );
  }

  void clearError() {
    if (state.error != null) state = state.copyWith(clearError: true);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);