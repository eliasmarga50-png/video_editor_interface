import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keeps tokens in the platform keystore (Android Keystore / iOS Keychain).
class TokenStorage {
  static const String _accessKey = 'access_token';
  static const String _refreshKey = 'refresh_token';

  final FlutterSecureStorage _storage;

  const TokenStorage([this._storage = const FlutterSecureStorage()]);

  Future<String?> readAccess() => _storage.read(key: _accessKey);

  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  Future<void> save({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}