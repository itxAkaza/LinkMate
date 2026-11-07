import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkvault/resources/colors/app_colors.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import '../../controllers/navController/navigationController.dart';
import '../drawer/appDrawer.dart'; // Ensure this path matches your AppDrawer location

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  // GlobalKey so HomeScreen can open the root drawer above the bottom navigation bar
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final mainViewModel = Get.put(MainHomeViewModel());

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.readOnlyBg,
      drawer: const AppDrawer(), // Drawer now sits at the top-most layer!
      body: Obx(() {
        final currentIndex = mainViewModel.viewIndex.value;

        return GlassScaffold(
          body: mainViewModel.screens[currentIndex],
          bottomBar: GlassTabBar.bottom(
            selectedLabelColor: AppColors.iconBlue,
            selectedIconColor: AppColors.iconBlue,
            labelFontSize: 10,
            barHeight: 70,
            selectedIndex: currentIndex,
            onTabSelected: mainViewModel.setIndex,
            indicatorColor: Colors.blueAccent.withOpacity(0.08),
            tabs: const [
              GlassTab(
                icon: Icon(Icons.home_outlined),
                label: "Home",
              ),
              GlassTab(
                icon: Icon(Icons.grid_view_outlined),
                label: "Categories",
              ),
              GlassTab(
                icon: Icon(Icons.add),
                label: "Add",
              ),
              GlassTab(
                icon: Icon(Icons.notifications_none_rounded),
                label: "Alerts",
              ),
              GlassTab(
                icon: Icon(CupertinoIcons.heart),
                label: "Favorites",
              ),
            ],
          ),
        );
      }),
    );
  }
}