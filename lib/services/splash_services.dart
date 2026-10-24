import 'package:get/get.dart';
import '../data/repositories/link_repository.dart';
import '../screens/home/main_home_screen.dart';
import '../screens/onBoarding/intro_screen.dart';


class SplashServices {
  final LinkRepository _repository = LinkRepository();

  void checkOnboardingAndRoute() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_repository.isOnboardingCompleted()) {
        Get.offAll(() => const MainHomeScreen()); // Or your BottomNav screen
      } else {
        Get.offAll(() => const IntroScreen());
      }
    });
  }
}