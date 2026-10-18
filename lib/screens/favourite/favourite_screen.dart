import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../Utiles/app_haptic.dart';
import '../../controllers/fvt/fvtController.dart';
import '../../controllers/home/homeController.dart';

import '../../model/link_model.dart';
import '../../resources/colors/app_colors.dart';
import '../home/detail/linkDetail_screen.dart';

import '../home/widgets/linkBottomSheet.dart';
import '../home/widgets/linkCard.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    final favController = Get.isRegistered<FavouriteController>()
        ? Get.find<FavouriteController>()
        : Get.put(FavouriteController(), permanent: true);


    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Favorites",
          style: GoogleFonts.manrope(
            color: AppColors.textColorBlack,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          Obx(
                () => IconButton(
              icon: Icon(
                favController.isGridView.value ? LucideIcons.layoutList : LucideIcons.layoutGrid,
                color: AppColors.iconBlue,
                size: 20,
              ),
              onPressed: () {
                AppHaptics.lightTap();
                favController.toggleViewMode();
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ValueListenableBuilder<Box<LinkItem>>(
        valueListenable: homeController.listenableBox,
        builder: (context, box, _) {
          final favLinks = box.values
              .where((item) => !item.isPrivate && item.isFavourite)
              .toList()
              .reversed
              .toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 8),

                // Top Row: "Saved links" + Red Count Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Saved links",
                      style: GoogleFonts.manrope(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColorBlack,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.dangerRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${favLinks.length} ${favLinks.length == 1 ? 'link' : 'links'}",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.dangerRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Expanded(
                  child: favLinks.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.dangerRed.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.heart,
                            size: 36,
                            color: AppColors.dangerRed,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "No favorite links yet",
                          style: GoogleFonts.manrope(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColorBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tap the heart icon on any link to save it here.",
                          style: GoogleFonts.manrope(
                            fontSize: 13.5,
                            color: AppColors.subTitleColorGary,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Obx(() {
                    if (favController.isGridView.value) {
                      return MasonryGridView.count(
                        crossAxisCount: isLandscape ? 3 : 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        padding: const EdgeInsets.only(bottom: 100),
                        physics: const BouncingScrollPhysics(),
                        itemCount: favLinks.length,
                        itemBuilder: (context, index) {
                          final link = favLinks[index];
                          return LinkCardWidget(
                            link: link,
                            isGridMode: true,
                            onTap: () => Get.to(() => LinkDetailScreen(link: link)),
                            onMoreTap: () => LinkActionsBottomSheet.show(
                              context,
                              link,
                              homeController,
                            ),
                            onFavouriteTap: () => homeController.toggleFavourite(link),
                          );
                        },
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: favLinks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final link = favLinks[index];
                        return LinkCardWidget(
                          link: link,
                          isGridMode: false,
                          onTap: () => Get.to(() => LinkDetailScreen(link: link)),
                          onMoreTap: () => LinkActionsBottomSheet.show(
                            context,
                            link,
                            homeController,
                          ),
                          onFavouriteTap: () => homeController.toggleFavourite(link),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}