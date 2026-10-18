import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utiles/utiles.dart';
import '../../screens/addLink/add_link_screen.dart';
import '../../screens/categories/categories_screen.dart';
import '../../screens/favourite/favourite_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/reminders/reminder_screen.dart';
// Import your global notification service instance
import '../../main.dart';
import '../../services/share/share_handler_service.dart';

class MainHomeViewModel extends GetxController {
  RxInt viewIndex = 0.obs;

  final List<Widget> screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const LinkScreen(),
    const ReminderScreen(),
    const FavouriteScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
    _checkPermissions(); // Your existing notification check
    ShareHandlerService.init(); // Start listening for shared links!
  }

  Future<void> _checkPermissions() async {
    // Use your global notixclficationService instance here
    bool granted = await notificationService.requestAndCheckPermissions();

    if (!granted) {
      debugPrint("User denied notification permissions.");

      // Show the custom toast using your Utils class
      Utils.showInAppToast(
        "Notifications Disabled",
        "Link reminders won't work until you enable notifications in your phone's settings.",
      );
    }
  }
  void setIndex(int index) {
    viewIndex.value = index;
  }
}