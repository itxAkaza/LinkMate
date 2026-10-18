import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Utiles/app_haptic.dart';
import '../../../Utiles/utiles.dart';

import '../../../resources/colors/app_colors.dart';
import '../../controllers/home/homeController.dart';
import '../import_export/import_export_screen.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController(), permanent: true);

    return Drawer(
      backgroundColor: AppColors.backgroundWhite,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. BRAND HEADER
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.iconBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            LucideIcons.link2,
                            color: AppColors.iconBlue,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "LinkVault",
                          style: GoogleFonts.manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColorBlack,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Your personal link vault",
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.subTitleColorGary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(color: Colors.black12, height: 1),
                        const SizedBox(height: 18),

                        // 2. FEATURES SECTION (Sync to Online omitted as requested)
                        _buildSectionHeader("FEATURES"),
                        const SizedBox(height: 10),

                        _buildDrawerItem(
                          icon: LucideIcons.house,
                          title: "Home",
                          onTap: () {
                            AppHaptics.lightTap();
                            Get.back();
                          },
                        ),
                        _buildDrawerItem(
                          icon: LucideIcons.lock,
                          title: "Private Vault",
                          onTap: () {
                            AppHaptics.lightTap();
                            Get.back();
                            Utils.showInAppToast("Private Vault", "Coming next!");
                          },
                        ),
                        _buildDrawerItem(
                          icon: LucideIcons.settings,
                          title: "Settings",
                          onTap: () {
                            AppHaptics.lightTap();
                            Get.back();
                            Utils.showInAppToast("Settings", "Coming next!");
                          },
                        ),
                        _buildDrawerItem(
                          icon: LucideIcons.scanLine,
                          title: "QR Code Scan",
                          isHighlighted: true,
                          onTap: () {
                            AppHaptics.lightTap();
                            Get.back();
                            homeController.openTopScanner();
                          },
                        ),
                        _buildDrawerItem(
                          icon: LucideIcons.fileSpreadsheet,
                          title: "Import / Export Links",
                          onTap: () {
                            AppHaptics.lightTap();
                            Get.back();
                            Get.to(() => const ImportExportScreen());
                          },
                        ),

                        const SizedBox(height: 16),
                        const Divider(color: Colors.black12, height: 1),
                        const SizedBox(height: 16),

                        // 3. MORE INFO SECTION
                        _buildSectionHeader("MORE INFO"),
                        const SizedBox(height: 10),

                        _buildDrawerItem(
                          icon: LucideIcons.shieldCheck,
                          title: "Privacy Policy",
                          isBlueIcon: true,
                          onTap: () {
                            AppHaptics.lightTap();
                            Get.back();
                          },
                        ),
                        _buildDrawerItem(
                          icon: LucideIcons.circleHelp,
                          title: "Feedback",
                          isBlueIcon: true,
                          onTap: () {
                            AppHaptics.lightTap();
                            Get.back();
                          },
                        ),
                        _buildDrawerItem(
                          icon: LucideIcons.circleUser,
                          title: "About",
                          isBlueIcon: true,
                          onTap: () {
                            AppHaptics.lightTap();
                            Get.back();
                          },
                        ),

                        const Spacer(),
                        const SizedBox(height: 20),

                        // 4. FOOTER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "v1.0.0",
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.subTitleColorGary,
                              ),
                            ),
                            Text(
                              "© 2026 LinkVault",
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.subTitleColorGary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: AppColors.iconBlue,
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isHighlighted = false,
    bool isBlueIcon = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColors.iconBlue.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: isHighlighted || isBlueIcon
                      ? AppColors.iconBlue.withOpacity(0.12)
                      : AppColors.overlayFieldGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: isHighlighted || isBlueIcon
                      ? AppColors.iconBlue
                      : AppColors.textColorBlack,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: isHighlighted
                        ? AppColors.iconBlue
                        : AppColors.textColorBlack,
                  ),
                ),
              ),
              if (isHighlighted)
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.iconBlue,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: AppColors.subTitleColorGary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}