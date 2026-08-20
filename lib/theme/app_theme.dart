import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Turns the design tokens in [AppColors] into a Flutter [ThemeData].
///
/// This is the piece that saves you from repeating the same
/// BoxDecoration / TextStyle / ButtonStyle on every screen: define the
/// look once, then every TextField, ElevatedButton, etc. picks it up
/// automatically because MaterialApp(theme: ...) applies it globally.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
      ),
      // Swap 'Inter' for whatever family your Figma file actually uses
      // (Inspect > Typography on any text layer). Add the .ttf files to
      // assets/fonts and register them below under `flutter: fonts:`
      // in pubspec.yaml, or delete this line to use the OS default.
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
          height: 1.25,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textGrey,
          height: 1.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
      ),
    );
  }
}
