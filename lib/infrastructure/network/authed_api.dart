import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../services/token_storage.dart';

/// HTTP client for every protected backend call (video-gen, transcribe, broll).
///
/// - Adds `Authorization: Bearer <access token>` to each request.
/// - On a 401 it refreshes the tokens once and retries the request.
/// - If the refresh token is rejected it calls [onSessionExpired].
///
/// Usage: ref.read(authedApiProvider).post('/video-gen', json: {...})
class AuthedApi {
  AuthedApi({
    required http.Client client,
    required TokenStorage tokens,
    required Future<bool> Function() refresh,
    required void Function() onSessionExpired,
    String? baseUrl,
  })  : _client = client,
        _tokens = tokens,
        _refresh = refresh,
        _onSessionExpired = onSessionExpired,
        _base = baseUrl ?? AppConfig.apiBaseUrl;

  final http.Client _client;
  final TokenStorage _tokens;
  final Future<bool> Function() _refresh;
  final void Function() _onSessionExpired;
  final String _base;

  Uri _uri(String path) => Uri.parse('$_base$path');

  Future<http.Response> get(String path, {Map<String, String>? headers}) {
    return _send((h) => _client.get(_uri(path), headers: h), headers);
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? json,
    Map<String, String>? headers,
  }) {
    return _send(
      (h) => _client.post(
        _uri(path),
        headers: {'Content-Type': 'application/json', ...h},
        body: json == null ? null : jsonEncode(json),
      ),
      headers,
    );
  }

  Future<http.Response> _send(
    Future<http.Response> Function(Map<String, String> headers) call,
    Map<String, String>? extra,
  ) async {
    Future<http.Response> attempt() async {
      final String? token = await _tokens.readAccess();
      return call({
        ...?extra,
        if (token != null) 'Authorization': 'Bearer $token',
      });
    }

    http.Response res = await attempt();
    if (res.statusCode != 401) return res;

    final bool refreshed = await _refresh();
    if (!refreshed) {
      // Only sign out if the refresh token is gone (server rejected it).
      // A failed refresh while offline must not log the user out.
      if (await _tokens.readRefresh() == null) _onSessionExpired();
      return res;
    }

    res = await attempt();
    if (res.statusCode == 401) _onSessionExpired();
    return res;
  }
}