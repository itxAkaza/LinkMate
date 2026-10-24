import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utiles/app_haptic.dart';
import '../../data/repositories/link_repository.dart';
// TODO: Update this import to point to your main BottomNav / MainScreen widget
import '../../resources/route/routes_names.dart';

class OnBoardingController extends GetxController {
  final LinkRepository _repository = LinkRepository();
  final PageController pageController = PageController();

  final RxInt currentPage = 0.obs;
  final RxBool isLast = false.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
    isLast.value = (index == 2);
  }

  void nextPage() {
    AppHaptics.lightTap();
    if (isLast.value) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void skipOnboarding() {
    AppHaptics.lightTap();
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    AppHaptics.mediumTap();
    await _repository.setOnboardingCompleted();
    Get.offAllNamed(RoutesNames.mainHome);
  }
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}