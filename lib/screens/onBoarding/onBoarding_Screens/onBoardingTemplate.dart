


import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../resources/colors/app_colors.dart';

class OnBoardingPageTemplate extends StatelessWidget {
  final String lottieAsset;
  final IconData badgeIcon;
  final String badgeText;
  final String title;
  final String description;

  const OnBoardingPageTemplate({
    super.key,
    required this.lottieAsset,
    required this.badgeIcon,
    required this.badgeText,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      // LANDSCAPE MODE: Side-by-side layout (Lottie on Left, Text on Right)
      return Padding(
        padding: const EdgeInsets.fromLTRB(28, 8, 28, 90),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: Lottie.asset(
                  lottieAsset,
                  fit: BoxFit.contain,
                  height: size.height * 0.62,
                ),
              ),
            ),
            const SizedBox(width: 28),
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _buildTextContent(isLandscape: true),
              ),
            ),
          ],
        ),
      );
    }

    // PORTRAIT MODE: Vertical layout
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          SizedBox(
            height: size.height * 0.38,
            child: Lottie.asset(
              lottieAsset,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 28),
          _buildTextContent(isLandscape: false),
          SizedBox(height: size.height * 0.16), // Space for bottom indicator + button
        ],
      ),
    );
  }

  Widget _buildTextContent({required bool isLandscape}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isLandscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Top Feature Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.iconBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.iconBlue.withOpacity(0.22)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(badgeIcon, size: 14, color: AppColors.iconBlue),
              const SizedBox(width: 6),
              Text(
                badgeText,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                  color: AppColors.iconBlue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Main Title (#111111 Bold)
        Text(
          title,
          textAlign: isLandscape ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.manrope(
            color: const Color(0xFF111111),
            fontSize: isLandscape ? 24 : 26,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          description,
          textAlign: isLandscape ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.manrope(
            color: AppColors.subTitleColorGary,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}