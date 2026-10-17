import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkvault/resources/colors/app_colors.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../controllers/navController/navigationController.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainViewModel = Get.put(MainHomeViewModel());

    return Obx(() {
      final currentIndex = mainViewModel.viewIndex.value;

      return Material(
        color: AppColors.readOnlyBg,
        child: GlassScaffold(
          body: mainViewModel.screens[currentIndex],

          bottomBar: GlassTabBar.bottom(
            selectedLabelColor: AppColors.iconBlue,
            selectedIconColor: AppColors.iconBlue,
            labelFontSize: 10,
            barHeight: 70,

            selectedIndex: currentIndex,
            onTabSelected: mainViewModel.setIndex,
            // This tints the actual sliding liquid bubble
            indicatorColor: Colors.blueAccent.withOpacity(0.08),

            tabs: [
              GlassTab(
                icon: Icon(
                  Icons.home_outlined,

                ),
                label: "Home",
              ),
              GlassTab(
                icon: Icon(
                  Icons.grid_view_outlined,

                ),
                label: "Categories",
              ),
              GlassTab(
                icon: Icon(
                  Icons.add,

                ),
                label: "Add",
              ),
              GlassTab(
                icon: Icon(
                  Icons.notifications_none_rounded,

                ),
                label: "Alerts",
              ),
              GlassTab(
                icon: Icon(
                  CupertinoIcons.heart,

                ),
                label: "Favorites",
              ),
            ],
          ),
        ),
      );
    });
  }
}