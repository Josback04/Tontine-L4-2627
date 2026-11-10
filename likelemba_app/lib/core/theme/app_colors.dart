import 'package:material_ui/material_ui.dart';

/// Palette de Likelemba.
///
/// Vert : la confiance et l'argent mis en commun.
/// Or : l'épargne, la cagnotte remise au bénéficiaire du tour.
/// Les widgets ne lisent jamais ces constantes directement : ils passent par
/// `Theme.of(context).colorScheme`, construit dans app_theme.dart.
abstract final class AppColors {
  static const green = Color(0xFF0B6E4F);
  static const greenLight = Color(0xFF4FB286);
  static const greenDark = Color(0xFF08543C);
  static const gold = Color(0xFFF2A900);
  static const goldDark = Color(0xFFB37D00);

  static const ink = Color(0xFF1B1F1D);
  static const inkMuted = Color(0xFF5C6661);
  static const surfaceLight = Color(0xFFF6F8F7);
  static const cardLight = Color(0xFFFFFFFF);
  static const outlineLight = Color(0xFFDCE3DF);

  static const surfaceDark = Color(0xFF101413);
  static const cardDark = Color(0xFF1A201E);
  static const outlineDark = Color(0xFF2E3833);
  static const textDark = Color(0xFFE6ECE9);

  static const success = Color(0xFF1E8E3E);
  static const error = Color(0xFFC62828);
  static const errorDark = Color(0xFFFF8A80);
}
