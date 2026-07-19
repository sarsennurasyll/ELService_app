import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadows.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

final class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.surface,
      primaryContainer: AppColors.primary10,
      onPrimaryContainer: AppColors.foreground,
      secondary: AppColors.secondary,
      onSecondary: AppColors.surface,
      secondaryContainer: AppColors.muted,
      onSecondaryContainer: AppColors.foreground,
      tertiary: AppColors.info,
      onTertiary: AppColors.surface,
      tertiaryContainer: AppColors.muted,
      onTertiaryContainer: AppColors.foreground,
      error: AppColors.error,
      onError: AppColors.surface,
      errorContainer: AppColors.error,
      onErrorContainer: AppColors.surface,
      surface: AppColors.surface,
      onSurface: AppColors.foreground,
      surfaceContainerHighest: AppColors.muted,
      onSurfaceVariant: AppColors.mutedForeground,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
      shadow: AppColors.scrim,
      scrim: AppColors.scrim,
      inverseSurface: AppColors.foreground,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.primary,
      surfaceTint: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.foreground,
      titleTextStyle: AppTextStyles.titleMedium.copyWith(
        color: AppColors.foreground,
      ),
      iconTheme: const IconThemeData(color: AppColors.foreground),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      shadowColor: AppShadows.md.first.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
        foregroundColor: const WidgetStatePropertyAll(AppColors.surface),
        minimumSize: const WidgetStatePropertyAll(
          Size.fromHeight(AppSpacing.space48),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpacing.space20),
        ),
        textStyle: const WidgetStatePropertyAll(AppTextStyles.labelLarge),
        shadowColor: WidgetStatePropertyAll(AppShadows.primary.first.color),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(AppColors.foreground),
        minimumSize: const WidgetStatePropertyAll(
          Size.fromHeight(AppSpacing.space48),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpacing.space20),
        ),
        textStyle: const WidgetStatePropertyAll(AppTextStyles.labelLarge),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppColors.border),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space12,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.mutedForeground,
      ),
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: AppColors.mutedForeground,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.divider),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),
  );
}
