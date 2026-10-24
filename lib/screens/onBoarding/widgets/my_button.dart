import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';

import '../../../resources/colors/app_colors.dart';

class ShimmerGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLastPage;
  final double height;
  final double width;

  const ShimmerGradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLastPage = false,
    this.height = 56,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: AppColors.primaryButtonGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonGradientMiddle.withOpacity(0.32),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Diagonal Shimmer Glow Sweep Overlay
            Positioned.fill(
              child: Shimmer.fromColors(
                baseColor: Colors.white.withOpacity(0.0),
                highlightColor: Colors.white.withOpacity(0.26),
                period: const Duration(milliseconds: 2400),
                direction: ShimmerDirection.ltr,
                child: Transform.rotate(
                  angle: -0.35, // Diagonal angle
                  child: Container(
                    width: width * 1.5,
                    height: height * 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.45),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: const [0.35, 0.5, 0.65],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Crisp Foreground Button Label & Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isLastPage ? LucideIcons.sparkles : LucideIcons.arrowRight,
                  color: Colors.white,
                  size: 19,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}