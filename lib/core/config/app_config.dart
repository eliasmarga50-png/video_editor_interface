import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  /// Override at build/run time:
  /// flutter run --dart-define=API_BASE_URL=http://localhost:8080
  static String get apiBaseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;

    // 10.0.2.2 is host loopback from the Android emulator
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }

    // Windows desktop, macOS, Linux, Web, and iOS simulator use localhost
    return 'http://127.0.0.1:8080';
  }
}