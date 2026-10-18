import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:linkvault/screens/categories/widgets/categoaryItems.dart';
import 'package:linkvault/screens/categories/widgets/cateogoryLink_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../Utiles/app_haptic.dart';
import '../../data/repositories/link_repository.dart';
import '../../model/link_model.dart';
import '../../resources/colors/app_colors.dart';


class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = LinkRepository();
    final RxBool isGridView = false.obs;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Category",
          style: GoogleFonts.manrope(
            color: AppColors.textColorBlack,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          Obx(
                () => IconButton(
              tooltip: "Toggle List/Grid",
              icon: Icon(
                isGridView.value ? LucideIcons.layoutList : LucideIcons.layoutGrid,
                color: AppColors.iconBlue,
                size: 20,
              ),
              onPressed: () {
                AppHaptics.lightTap();
                isGridView.value = !isGridView.value;
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ValueListenableBuilder<Box<List<String>>>(
        valueListenable: repository.listenableCategories,
        builder: (context, catBox, _) {
          final categories = repository.getCategories();

          return ValueListenableBuilder<Box<LinkItem>>(
            valueListenable: repository.listenableLinks,
            builder: (context, linkBox, _) {
              final publicLinks = linkBox.values.where((l) => !l.isPrivate).toList();

              // Ensure any category present on a link is also included
              final allCategories = <String>{...categories};
              for (final link in publicLinks) {
                if (link.category != null && link.category!.trim().isNotEmpty) {
                  allCategories.add(link.category!.trim());
                }
              }
              final categoryList = allCategories.toList();

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.iconBlue.withOpacity(0.14),
                              AppColors.iconBlue.withOpacity(0.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.iconBlue.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left: Total Saved
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "TOTAL SAVED",
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: AppColors.iconBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${publicLinks.length} ",
                                        style: GoogleFonts.manrope(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textColorBlack,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "links",
                                        style: GoogleFonts.manrope(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.subTitleColorGary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Right: Categories Count
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "CATEGORIES",
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: AppColors.iconBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${categoryList.length}",
                                  style: GoogleFonts.manrope(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textColorBlack,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Category List or Grid
                  Obx(() {
                    if (isGridView.value) {
                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isLandscape ? 3 : 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.25,
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final catName = categoryList[index];
                              final count = publicLinks
                                  .where((l) =>
                              (l.category ?? 'Web').toLowerCase() ==
                                  catName.toLowerCase())
                                  .length;

                              return CategoryItemCard(
                                categoryName: catName,
                                linkCount: count,
                                isGridMode: true,
                                onTap: () {
                                  AppHaptics.lightTap();
                                  Get.to(() => CategoryLinksScreen(categoryName: catName));
                                },
                              );
                            },
                            childCount: categoryList.length,
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                      sliver: SliverList.separated(
                        itemCount: categoryList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final catName = categoryList[index];
                          final count = publicLinks
                              .where((l) =>
                          (l.category ?? 'Web').toLowerCase() ==
                              catName.toLowerCase())
                              .length;

                          return CategoryItemCard(
                            categoryName: catName,
                            linkCount: count,
                            isGridMode: false,
                            onTap: () {
                              AppHaptics.lightTap();
                              Get.to(() => CategoryLinksScreen(categoryName: catName));
                            },
                          );
                        },
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}