import 'package:flutter/foundation.dart';

/// Les trois saveurs (flavors) générées par Very Good CLI.
/// Chaque point d'entrée `main_<saveur>.dart` choisit la sienne.
enum AppEnvironment {
  development,
  staging,
  production;

  /// Surcharge possible au lancement :
  /// `flutter run --dart-define=API_URL=http://192.168.1.10:8080`
  static const _apiUrlOverride = String.fromEnvironment('API_URL');

  String get apiBaseUrl {
    if (_apiUrlOverride.isNotEmpty) return _apiUrlOverride;
    return switch (this) {
      // Depuis l'émulateur Android, 10.0.2.2 désigne le poste hôte.
      AppEnvironment.development =>
        defaultTargetPlatform == TargetPlatform.android
            ? 'http://10.0.2.2:8080'
            : 'http://localhost:8080',
      // À remplacer par les vraies adresses une fois l'API déployée.
      AppEnvironment.staging => 'https://staging-api.likelemba.example',
      AppEnvironment.production => 'https://api.likelemba.example',
    };
  }

  Duration get networkTimeout => const Duration(seconds: 10);
}
