import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkvault/screens/onBoarding/widgets/my_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controllers/onBoarding/onBoarding_controller.dart';

import '../../resources/assets/image_assets.dart';
import '../../resources/colors/app_colors.dart';
import 'onBoarding_Screens/onBoardingScreens.dart';



class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final introController = Get.isRegistered<OnBoardingController>()
        ? Get.find<OnBoardingController>()
        : Get.put(OnBoardingController());

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. 3 ONBOARDING PAGES
            PageView(
              controller: introController.pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: introController.onPageChanged,
              children: const [
                OnBoarding1(),
                OnBoarding2(),
                OnBoarding3(),
              ],
            ),

            // 2. TOP HEADER: LinkMate Logo + "Skip" Button
            Positioned(
              top: 12,
              left: 24,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          ImageAssets.logo,
                          width: 34,
                          height: 34,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "LinkMate",
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111111),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                        () => introController.isLast.value
                        ? const SizedBox.shrink()
                        : TextButton(
                      onPressed: introController.skipOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.subTitleColorGary,
                      ),
                      child: Text(
                        "Skip",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.subTitleColorGary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. BOTTOM CONTROLS: SmoothPageIndicator + ShimmerGradientButton
            Positioned(
              left: 28,
              right: 28,
              bottom: isLandscape ? 16 : 28,
              child: isLandscape
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: introController.pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 3,
                      dotColor: AppColors.iconBlue.withOpacity(0.2),
                      activeDotColor: AppColors.iconBlue,
                      dotWidth: 9,
                      dotHeight: 9,
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: Obx(
                          () => ShimmerGradientButton(
                        text: introController.isLast.value
                            ? "Get Started"
                            : "Next",
                        isLastPage: introController.isLast.value,
                        height: 48,
                        onTap: introController.nextPage,
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: introController.pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 3.2,
                      dotColor: AppColors.iconBlue.withOpacity(0.2),
                      activeDotColor: AppColors.iconBlue,
                      dotWidth: 10,
                      dotHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                        () => ShimmerGradientButton(
                      text: introController.isLast.value
                          ? "Get Started"
                          : "Next",
                      isLastPage: introController.isLast.value,
                      height: 56,
                      onTap: introController.nextPage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}