import 'package:likelemba_app/core/theme/app_colors.dart';
import 'package:likelemba_app/core/theme/app_spacing.dart';
import 'package:material_ui/material_ui.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.green,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD3EFE3),
      onPrimaryContainer: AppColors.greenDark,
      secondary: AppColors.gold,
      onSecondary: AppColors.ink,
      secondaryContainer: Color(0xFFFFEDC2),
      onSecondaryContainer: AppColors.goldDark,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkMuted,
      surfaceContainer: AppColors.cardLight,
      outline: AppColors.outlineLight,
    ),
  );

  static ThemeData get dark => _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.greenLight,
      onPrimary: AppColors.surfaceDark,
      primaryContainer: AppColors.greenDark,
      onPrimaryContainer: Color(0xFFD3EFE3),
      secondary: AppColors.gold,
      onSecondary: AppColors.ink,
      secondaryContainer: AppColors.goldDark,
      onSecondaryContainer: Color(0xFFFFEDC2),
      error: AppColors.errorDark,
      onError: AppColors.surfaceDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textDark,
      onSurfaceVariant: Color(0xFFA9B5AF),
      surfaceContainer: AppColors.cardDark,
      outline: AppColors.outlineDark,
    ),
  );

  static ThemeData _build(ColorScheme scheme) {
    final radius = BorderRadius.circular(AppSpacing.radius);
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: base.textTheme.copyWith(
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.primary),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
