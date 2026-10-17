import 'package:get/get.dart';
import '../../screens/home/main_home_screen.dart';
import 'routes_names.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(
      name: RoutesNames.mainHome,
      page: () => const MainHomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
  ];
}