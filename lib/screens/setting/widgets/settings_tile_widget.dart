import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../resources/colors/app_colors.dart';

class SettingsTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final BorderRadius? borderRadius;

  const SettingsTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.accentColor = AppColors.iconBlue,
    this.onTap,
    this.trailing,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: accentColor == AppColors.dangerRed
                          ? AppColors.dangerRed
                          : AppColors.textColorBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.subTitleColorGary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.subTitleColorGary,
                ),
          ],
        ),
      ),
    );
  }
}