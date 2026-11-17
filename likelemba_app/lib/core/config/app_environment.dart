import 'package:flutter/foundation.dart';

// Nos 3 environnements de développement
enum AppEnvironment {
  development,
  staging,
  production;

  /// `flutter run --dart-define=API_URL=http://192.168.1.10:8080`
  static const _apiUrlOverride = String.fromEnvironment('API_URL');

  String get apiBaseUrl {
    if (_apiUrlOverride.isNotEmpty) return _apiUrlOverride;
    return switch (this) {
      AppEnvironment.development =>
        defaultTargetPlatform == TargetPlatform.android
            ? 'http://10.0.2.2:8080'
            : 'http://localhost:8080',

      AppEnvironment.staging => 'https://staging-api.likelemba.example',
      AppEnvironment.production => 'https://api.likelemba.example',
    };
  }

  Duration get networkTimeout => const Duration(seconds: 10);
}
