import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../controllers/home/homeController.dart';
import '../../model/link_model.dart';
import '../../resources/colors/app_colors.dart';
import '../drawer/appDrawer.dart';
import 'detail/linkDetail_screen.dart';
import 'widgets/linkBottomSheet.dart';
import 'widgets/linkCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      drawer: const AppDrawer(),
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
            onPressed: controller.onExportPressed,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ValueListenableBuilder<Box<LinkItem>>(
        valueListenable: controller.listenableBox,
        builder: (context, box, _) {
          return Obx(() {
            final links = controller.getFilteredLinks(box);

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. TOP FIXED ELEMENTS (Search, Tags, Header)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar
                        TextField(
                          controller: controller.searchController,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
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
                            suffixIcon: controller.searchQuery.value.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.cancel, color: AppColors.subTitleColorGary, size: 18),
                              onPressed: () => controller.searchController.clear(),
                            )
                                : const SizedBox.shrink(),
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
                        const SizedBox(height: 18),

                        // Tags Filter Bar
                        SizedBox(
                          height: 38,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.filterTags.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final tag = controller.filterTags[index];
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
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Header Row
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
                            InkWell(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. SCROLLABLE CONTENT (Empty State, Grid, or List)
                if (links.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(),
                  )
                else if (controller.isGridView.value)
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: isLandscape ? 3 : 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childCount: links.length,
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
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                    sliver: SliverList.separated(
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
                    ),
                  ),
              ],
            );
          });
        },
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