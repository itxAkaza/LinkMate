import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:linkvault/screens/home/widgets/linkBottomSheet.dart';
import 'package:linkvault/screens/home/widgets/linkCard.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../controllers/home/homeController.dart';

import '../../model/link_model.dart';
import '../../resources/colors/app_colors.dart';
import '../drawer/appDrawer.dart';
import 'detail/linkDetail_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      // Empty Drawer for now as requested
      drawer:const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(LucideIcons.menu, color: AppColors.iconBlue, size: 24),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          "Home",
          style: GoogleFonts.manrope(
            color: AppColors.textColorBlack,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Scan QR",
            icon: const Icon(LucideIcons.scanLine, color: AppColors.textColorBlack, size: 22),
            onPressed: controller.openTopScanner,
          ),
          IconButton(
            tooltip: "Export Links",
            icon: const Icon(LucideIcons.share, color: AppColors.textColorBlack, size: 22),
            onPressed: controller.onExportPressed, // Empty callback for now
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.01),

            // 1. SEARCH BAR
            TextField(
              controller: controller.searchController,
              style: GoogleFonts.manrope(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textColorBlack,
              ),
              decoration: InputDecoration(
                hintText: "Search here...",
                hintStyle: GoogleFonts.manrope(
                  color: AppColors.subTitleColorGary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(LucideIcons.search, color: AppColors.subTitleColorGary, size: 20),
                suffixIcon: Obx(
                      () => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.cancel, color: AppColors.subTitleColorGary, size: 18),
                    onPressed: () => controller.searchController.clear(),
                  )
                      : const SizedBox.shrink(),
                ),
                filled: true,
                fillColor: AppColors.backgroundWhite,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black12, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.iconBlue, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: height * 0.018),

            // 2. HORIZONTAL TAGS FILTER BAR
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.filterTags.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tag = controller.filterTags[index];
                  return Obx(() {
                    final isSelected = controller.selectedTag.value == tag;
                    return GestureDetector(
                      onTap: () => controller.selectTag(tag),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.textColorBlack : AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.textColorBlack : Colors.black12,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : AppColors.textGray,
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            SizedBox(height: height * 0.02),

            // 3. HEADER ROW: "Recent Links" + Rearrange (List / Staggered Grid) Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Links",
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColorBlack,
                  ),
                ),
                Obx(
                      () => InkWell(
                    onTap: controller.toggleViewMode,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            controller.isGridView.value
                                ? LucideIcons.layoutList
                                : LucideIcons.layoutGrid,
                            size: 16,
                            color: AppColors.iconBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            controller.isGridView.value ? "List" : "Grid",
                            style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColorBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.012),

            // 4. REACTIVE HIVE LISTENABLE LINKS LIST / STAGGERED GRID
            Expanded(
              child: ValueListenableBuilder<Box<LinkItem>>(
                valueListenable: controller.listenableBox,
                builder: (context, box, _) {
                  return Obx(() {
                    final links = controller.getFilteredLinks(box);

                    if (links.isEmpty) {
                      return _buildEmptyState();
                    }

                    // Staggered Grid View Mode
                    if (controller.isGridView.value) {
                      return MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        padding: const EdgeInsets.only(bottom: 100),
                        physics: const BouncingScrollPhysics(),
                        itemCount: links.length,
                        itemBuilder: (context, index) {
                          final link = links[index];
                          return LinkCardWidget(
                            link: link,
                            isGridMode: true,
                            onTap: () => Get.to(() => LinkDetailScreen(link: link)),
                            onMoreTap: () => LinkActionsBottomSheet.show(context, link, controller),
                            onFavouriteTap: () => controller.toggleFavourite(link),
                          );
                        },
                      );
                    }

                    // Standard Vertical List View Mode
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: links.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final link = links[index];
                        return LinkCardWidget(
                          link: link,
                          isGridMode: false,
                          onTap: () => Get.to(() => LinkDetailScreen(link: link)),
                          onMoreTap: () => LinkActionsBottomSheet.show(context, link, controller),
                          onFavouriteTap: () => controller.toggleFavourite(link),
                        );
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.iconBlue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.link2Off, size: 36, color: AppColors.iconBlue),
          ),
          const SizedBox(height: 14),
          Text(
            "No links found",
            style: GoogleFonts.manrope(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textColorBlack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Add a new link or adjust your search filters.",
            style: GoogleFonts.manrope(
              fontSize: 13.5,
              color: AppColors.subTitleColorGary,
            ),
          ),
        ],
      ),
    );
  }
}