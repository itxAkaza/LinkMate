import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkvault/screens/setting/widgets/settings_tile_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../controllers/setting/settingController.dart';

import '../../resources/colors/app_colors.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : Get.put(SettingsController());

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
        title: Text(
          "Settings",
          style: GoogleFonts.manrope(
            color: AppColors.textColorBlack,
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SECURITY & NOTIFICATIONS",
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    // 1. Set or Change Vault PIN
                    Obx(
                          () => SettingsTileWidget(
                        icon: LucideIcons.keyRound,
                        title: controller.hasPinConfigured.value
                            ? "Change Private Vault PIN"
                            : "Set Up Private Vault PIN",
                        subtitle: controller.hasPinConfigured.value
                            ? "Update your 4-digit security code"
                            : "Create a 4-digit code to lock private links",
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                        onTap: controller.manageVaultPin,
                      ),
                    ),

                    // 2. Reset Forgotten PIN (Only visible when PIN is set)
                    Obx(() {
                      if (!controller.hasPinConfigured.value) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          const Divider(color: Colors.black12, height: 1),
                          SettingsTileWidget(
                            icon: LucideIcons.rotateCcw,
                            accentColor: AppColors.dangerRed,
                            title: "Reset Forgotten Vault PIN",
                            subtitle: "Wipes private links and sets a new 4-digit PIN",
                            onTap: controller.openResetPinFlow,
                          ),
                        ],
                      );
                    }),

                    const Divider(color: Colors.black12, height: 1),

                    // 3. Allow Notifications Toggle
                    SettingsTileWidget(
                      icon: LucideIcons.bell,
                      title: "Allow Notifications",
                      subtitle: "Get notified for scheduled link reminders",
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
                      trailing: Obx(
                            () => Switch(
                          value: controller.notificationsEnabled.value,
                          activeThumbColor: Colors.white,
                          activeTrackColor: AppColors.iconBlue,
                          onChanged: controller.toggleNotifications,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}