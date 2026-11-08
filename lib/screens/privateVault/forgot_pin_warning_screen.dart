import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../Utiles/app_haptic.dart';
import '../../Utiles/utiles.dart';
import '../../data/repositories/link_repository.dart';
import '../../main.dart';
import '../../resources/colors/app_colors.dart';
import 'vault_pin_screen.dart';

class ForgotPinWarningScreen extends StatelessWidget {
  final bool openVaultAfterReset;

  const ForgotPinWarningScreen({
    super.key,
    this.openVaultAfterReset = false,
  });

  Future<void> _confirmResetPin() async {
    AppHaptics.errorVibrate();
    final repo = LinkRepository();

    // Cancel scheduled notifications for any private links before wiping
    final privateLinks = repo.listenableLinks.value.values.where((l) => l.isPrivate).toList();
    for (final link in privateLinks) {
      final int id = (link.key is int) ? link.key as int : link.hashCode;
      await notificationService.cancelNotification(id);
    }

    await repo.deleteAllPrivateLinks();

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    if (openVaultAfterReset) {
      // Replace warning screen with Setup screen (which will then open PrivateVaultScreen)
      Get.off(() => const VaultPinScreen(
        mode: PinScreenMode.setup,
        openVaultOnSuccess: true,
      ));
      Future.delayed(const Duration(milliseconds: 100), () {
        Utils.showInAppToast("Vault Reset", "All private links have been permanently deleted.");
      });
    } else {
      // Show reset toast and wait for user to finish creating their new PIN
      Future.delayed(const Duration(milliseconds: 100), () {
        Utils.showInAppToast("Vault Reset", "Create a new 4-digit PIN.");
      });

      final bool? result = await Get.to<bool>(
            () => const VaultPinScreen(
          mode: PinScreenMode.setup,
          openVaultOnSuccess: false,
        ),
      );

      // Immediately close ForgotPinWarningScreen and return to Settings / caller!
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.back(result: result ?? false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textColorBlack),
          onPressed: () {
            if (Get.isSnackbarOpen) Get.closeAllSnackbars();
            Get.back(result: false);
          },
        ),
        title: Text(
          "Reset Vault PIN",
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.dangerRed.withOpacity(0.3), width: 1.5),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.dangerRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.triangleAlert,
                        color: AppColors.dangerRed,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Warning: Data Loss",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textColorBlack,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Because your Private Vault is locally protected on your device, resetting a forgotten PIN requires permanently deleting all existing private links.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.subTitleColorGary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.dangerRed.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.trash2, color: AppColors.dangerRed, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Your public links, categories, and favorites will NOT be affected.",
                              style: GoogleFonts.manrope(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.dangerRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Continue & Wipe Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dangerRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _confirmResetPin,
                  child: Text(
                    "Continue & Delete Private Links",
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                    Get.back(result: false);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColorBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}