import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:linkvault/screens/reminders/widgets/reminderLinkCard.dart';
import 'package:linkvault/screens/reminders/widgets/reminderSummery.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


import '../../controllers/home/homeController.dart';
import '../../controllers/reminder/reminderController.dart';
import '../../model/link_model.dart';
import '../../resources/colors/app_colors.dart';
import '../home/detail/linkDetail_screen.dart';
import '../home/widgets/linkBottomSheet.dart';


class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReminderController());
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Reminders",
              style: GoogleFonts.manrope(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            Text(
              "Stay on track with what matters",
              style: GoogleFonts.manrope(
                color: AppColors.subTitleColorGary,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<Box<LinkItem>>(
        valueListenable: controller.listenableBox,
        builder: (context, box, _) {
          return Obx(() {
            final reminders = controller.getFilteredReminders(box);
            final activeTab = controller.activeFilter.value;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Search Bar
                        TextField(
                          controller: controller.searchController,
                          style: GoogleFonts.manrope(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColorBlack,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search reminders...",
                            hintStyle: GoogleFonts.manrope(
                              color: AppColors.subTitleColorGary,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: const Icon(
                              LucideIcons.search,
                              color: AppColors.subTitleColorGary,
                              size: 20,
                            ),
                            suffixIcon: controller.searchQuery.value.isNotEmpty
                                ? IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: AppColors.subTitleColorGary,
                                size: 18,
                              ),
                              onPressed: () => controller.searchController.clear(),
                            )
                                : null,
                            filled: true,
                            fillColor: AppColors.backgroundWhite,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
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

                        // 2. Responsive 4 Summary Filter Cards (2x2 in Portrait, 4x1 in Landscape)
                        GridView.count(
                          crossAxisCount: isLandscape ? 4 : 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: isLandscape ? 1.45 : 1.35,
                          children: [
                            ReminderSummaryCard(
                              label: "All",
                              count: controller.getAllCount(box),
                              icon: LucideIcons.calendar,
                              primaryColor: const Color(0xFF4F46E5),
                              bgColor: const Color(0xFFEEF2FF),
                              isSelected: activeTab == ReminderFilter.all,
                              onTap: () => controller.setFilter(ReminderFilter.all),
                            ),
                            ReminderSummaryCard(
                              label: "Done",
                              count: controller.getDoneCount(box),
                              icon: LucideIcons.check,
                              primaryColor: const Color(0xFF10B981),
                              bgColor: const Color(0xFFECFDF5),
                              isSelected: activeTab == ReminderFilter.done,
                              onTap: () => controller.setFilter(ReminderFilter.done),
                            ),
                            ReminderSummaryCard(
                              label: "Today",
                              count: controller.getTodayCount(box),
                              icon: LucideIcons.clock,
                              primaryColor: const Color(0xFFF59E0B),
                              bgColor: const Color(0xFFFFFBEB),
                              isSelected: activeTab == ReminderFilter.today,
                              onTap: () => controller.setFilter(ReminderFilter.today),
                            ),
                            ReminderSummaryCard(
                              label: "Overdue",
                              count: controller.getOverdueCount(box),
                              icon: LucideIcons.bellRing,
                              primaryColor: const Color(0xFFEF4444),
                              bgColor: const Color(0xFFFEF2F2),
                              isSelected: activeTab == ReminderFilter.overdue,
                              onTap: () => controller.setFilter(ReminderFilter.overdue),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        // 3. Section Header
                        Text(
                          controller.getSectionHeaderTitle(),
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColorBlack,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // 4. Reminders List or Empty State
                if (reminders.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.iconBlue.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.bellOff,
                              size: 32,
                              color: AppColors.iconBlue,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No reminders here",
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textColorBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "You're all caught up for this category!",
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: AppColors.subTitleColorGary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                    sliver: SliverList.separated(
                      itemCount: reminders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final link = reminders[index];
                        return ReminderLinkCard(
                          link: link,
                          controller: controller,
                          onTap: () => Get.to(() => LinkDetailScreen(link: link)),
                          onMoreTap: () =>
                              LinkActionsBottomSheet.show(context, link, homeController),
                          onBellTap: () => controller.markAsRead(link),
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
}