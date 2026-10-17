import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CategoryStyle {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  CategoryStyle({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

class CategoryStyleHelper {
  static CategoryStyle getStyle(String categoryName) {
    switch (categoryName.trim().toLowerCase()) {
      case 'articles':
        return CategoryStyle(
          icon: LucideIcons.fileText,
          iconColor: const Color(0xFFF59E0B), // Amber/Orange
          bgColor: const Color(0xFFFEF3C7),
        );
      case 'videos':
      case 'youtube':
      case 'tiktok':
        return CategoryStyle(
          icon: LucideIcons.play,
          iconColor: const Color(0xFFEF4444), // Red
          bgColor: const Color(0xFFFEE2E2),
        );
      case 'work':
      case 'linkedin':
        return CategoryStyle(
          icon: LucideIcons.briefcase,
          iconColor: const Color(0xFF3B82F6), // Blue
          bgColor: const Color(0xFFDBEAFE),
        );
      case 'bookmarks':
        return CategoryStyle(
          icon: LucideIcons.bookmark,
          iconColor: const Color(0xFF6366F1), // Indigo
          bgColor: const Color(0xFFE0E7FF),
        );
      case 'study':
      case 'code':
        return CategoryStyle(
          icon: LucideIcons.bookOpen,
          iconColor: const Color(0xFF10B981), // Emerald Green
          bgColor: const Color(0xFFD1FAE5),
        );
      case 'social':
      case 'instagram':
        return CategoryStyle(
          icon: LucideIcons.share2,
          iconColor: const Color(0xFFA855F7), // Purple
          bgColor: const Color(0xFFF3E8FF),
        );
      case 'web':
      case 'websites':
        return CategoryStyle(
          icon: LucideIcons.globe,
          iconColor: const Color(0xFF06B6D4), // Cyan
          bgColor: const Color(0xFFCFFAFE),
        );
      case 'sports':
        return CategoryStyle(
          icon: LucideIcons.trophy,
          iconColor: const Color(0xFFF97316), // Orange
          bgColor: const Color(0xFFFFEDD5),
        );
      default:
      // Default colored icon for any custom category added by the user
        return CategoryStyle(
          icon: LucideIcons.folderHeart,
          iconColor: const Color(0xFFEC4899), // Pink/Rose
          bgColor: const Color(0xFFFCE7F3),
        );
    }
  }
}