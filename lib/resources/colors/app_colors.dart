import 'package:flutter/material.dart';

class AppColors {
  // --- Original Colors ---
  static const Color iconBlue = Color(0xFF2B7FFF);
  static const Color textColorBlack = Color(0xFF101828);
  static const Color subTitleColorGary = Color(0xFF99A1AF);
  static const Color textColorBlue = Color(0xFF51A2FF);
  static const Color overlayFieldGray = Color(0xFFF5F5F7);
  static const Color readOnlyBg = Color(0xFFF0F0F0);

  // --- Button Gradient Colors ---
  // Extracted from the Figma linear gradient stops[cite: 1]
  static const Color buttonGradientStart = Color(0xFF60A5FA); // 0% stop[cite: 1]
  static const Color buttonGradientMiddle = Color(0xFF3B82F6); // 50% stop[cite: 1]
  static const Color buttonGradientEnd = Color(0xFF2563EB); // 100% stop[cite: 1]

  // --- General UI Colors ---
  // Based on the overall light theme in your app screens[cite: 2]
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Main background[cite: 2]
  static const Color textGray = Color(0xFF6B7280); // Subtitles and unselected icons[cite: 2]
  static const Color dangerRed = Color(0xFFEF4444); // For delete/warning actions[cite: 2]

  // --- Pre-built Button Gradient ---
  // You can use this directly in your BoxDecoration for the button[cite: 1]
  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [
      buttonGradientStart,
      buttonGradientMiddle,
      buttonGradientEnd,
    ],
    stops: [0.0, 0.5, 1.0], // Matches the 0%, 50%, 100% in Figma[cite: 1]
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}