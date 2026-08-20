import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────
  static const Color primary = Color(0xFF2F6FED);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textDark = Color(0xFF16192C);
  static const Color textGrey = Color(0xFF6B7280);

  // ── Surfaces ─────────────────────────────────────────────────
  static const Color background     = Color(0xFFFFFFFF);
  static const Color homeBackground = Color(0xFFF8FAFF);
  static const Color fieldFill      = Color(0xFFF3F4F6);
  static const Color fieldBorder    = Color(0xFFE5E7EB);

  // ── Shadows ──────────────────────────────────────────────────
  static const Color shadowCard    = Color(0x0F000000); // cards, list items
  static const Color shadowMedium  = Color(0x14000000); // nav bar, icon buttons
  static const Color shadowLight   = Color(0x0A000000); // search bar
  static const Color shadowPrimary = Color(0x612F6FED); // FAB glow

  // ── Status / Alerts ──────────────────────────────────────────
  static const Color danger  = Color(0xFFFF3B30); // notification dot, errors
  static const Color success = Color(0xFF43A047); // snackbar success
  static const Color warning = Color(0xFFF57C00); // snackbar warning

  // ── Role badge ───────────────────────────────────────────────
  static const Color roleAdminText = Color(0xFF2F6FED); // = primary
  static const Color roleAdminBg   = Color(0xFFE8F0FF);
  static const Color roleUserText  = Color(0xFF43A047);
  static const Color roleUserBg    = Color(0xFFE8F5E9);

  // ── Avatar palette (index by user.id % 4) ────────────────────
  static const List<Color> avatarBg = [
    Color(0xFFE8F0FF),
    Color(0xFFFFEBEB),
    Color(0xFFE8F5E9),
    Color(0xFFFFF3E0),
  ];

  static const List<Color> avatarFg = [
    Color(0xFF2F6FED),
    Color(0xFFE53935),
    Color(0xFF43A047),
    Color(0xFFF57C00),
  ];
}
