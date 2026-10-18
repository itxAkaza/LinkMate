import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Utiles/app_haptic.dart';
import '../../../Utiles/category_helper.dart';
import '../../../controllers/category/categoryController.dart';
import '../../../controllers/home/homeController.dart';

import '../../../model/link_model.dart';
import '../../../resources/colors/app_colors.dart';
import '../../home/detail/linkDetail_screen.dart';

import '../../home/widgets/linkBottomSheet.dart';
import '../../home/widgets/linkCard.dart';

class CategoryLinksScreen extends StatelessWidget {
  final String categoryName;
  const CategoryLinksScreen({super.key, required this.categoryName});


  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    final catController = Get.isRegistered<CategoryController>()
        ? Get.find<CategoryController>()
        : Get.put(CategoryController(), permanent: true);



    final style = CategoryStyleHelper.getStyle(categoryName);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textColorBlack),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: style.bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(style.icon, color: style.iconColor, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              categoryName,
              style: GoogleFonts.manrope(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),
          ],
        ),
        actions: [
          Obx(
                () => IconButton(
              icon: Icon(
                catController.isCategoryLinksGrid.value ? LucideIcons.layoutList : LucideIcons.layoutGrid,
                color: AppColors.iconBlue,
                size: 20,
              ),
              onPressed: () {
                AppHaptics.lightTap();
                catController.toggleCategoryLinksGrid;
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ValueListenableBuilder<Box<LinkItem>>(
        valueListenable: homeController.listenableBox,
        builder: (context, box, _) {
          final categoryLinks = box.values
              .where((item) =>
          !item.isPrivate &&
              (item.category ?? 'Web').toLowerCase() == categoryName.toLowerCase())
              .toList()
              .reversed
              .toList();

          if (categoryLinks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: style.bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(style.icon, size: 36, color: style.iconColor),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "No links in $categoryName",
                    style: GoogleFonts.manrope(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Links saved under $categoryName will appear here.",
                    style: GoogleFonts.manrope(
                      fontSize: 13.5,
                      color: AppColors.subTitleColorGary,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Obx(() {
              if (catController.isCategoryLinksGrid.value) {
                return MasonryGridView.count(
                  crossAxisCount: isLandscape ? 3 : 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  padding: const EdgeInsets.only(bottom: 40),
                  physics: const BouncingScrollPhysics(),
                  itemCount: categoryLinks.length,
                  itemBuilder: (context, index) {
                    final link = categoryLinks[index];
                    return LinkCardWidget(
                      link: link,
                      isGridMode: true,
                      onTap: () => Get.to(() => LinkDetailScreen(link: link)),
                      onMoreTap: () =>
                          LinkActionsBottomSheet.show(context, link, homeController),
                      onFavouriteTap: () => homeController.toggleFavourite(link),
                    );
                  },
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 40),
                physics: const BouncingScrollPhysics(),
                itemCount: categoryLinks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final link = categoryLinks[index];
                  return LinkCardWidget(
                    link: link,
                    isGridMode: false,
                    onTap: () => Get.to(() => LinkDetailScreen(link: link)),
                    onMoreTap: () =>
                        LinkActionsBottomSheet.show(context, link, homeController),
                    onFavouriteTap: () => homeController.toggleFavourite(link),
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }
}