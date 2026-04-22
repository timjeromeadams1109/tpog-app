import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2741E8);
  static const Color primaryDark = Color(0xFF1A3CE0);
  static const Color primaryLight = Color(0xFFE8EDFD);

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF0F1F5);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEDEEF1);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // Legacy names retained so existing widget code compiles without a sweep.
  static const Color tpogDark = surface;
  static const Color tpogBlue = primary;
  static const Color tpogBlueDark = primaryDark;
  static const Color tpogBlueLight = primary;
  static const Color tpogLight = background;
  static const Color tpogWhite = surface;
}
