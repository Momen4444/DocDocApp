import 'package:flutter/material.dart';

/// Central color palette.
///
/// The hex values below are close approximations read off the Figma
/// screenshot. Open the real file, select a layer, and check the
/// Inspect panel (right sidebar) for the exact hex codes, then swap
/// them in here — everything else in the app references these
/// constants, so you only ever need to change them in one place.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2F6FED);
  static const Color primaryDark = Color(0xFF1E4FC4);
  static const Color textDark = Color(0xFF16192C);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color fieldFill = Color(0xFFF3F4F6);
  static const Color fieldBorder = Color(0xFFE5E7EB);
  static const Color background = Color(0xFFFFFFFF);
}
