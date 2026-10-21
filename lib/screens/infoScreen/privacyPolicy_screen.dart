import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../resources/colors/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Privacy Policy",
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
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPolicySection(
                  "1. 100% On-Device Local Storage",
                  "LinkVault is an offline-first application. All of your saved links, notes, categories, tags, reminders, and Private Vault PIN codes are stored strictly locally on your device using Hive database storage. We do not transmit or upload your saved links to any external servers.",
                ),
                _buildPolicySection(
                  "2. Private Vault Security",
                  "Links stored in your Private Vault are protected by your custom 4-digit PIN code. Because we do not store your PIN on any cloud server, resetting a forgotten PIN requires permanently wiping existing Private Vault links to protect your privacy.",
                ),
                _buildPolicySection(
                  "3. OpenGraph Link Previews",
                  "When you save a URL, LinkVault fetches public OpenGraph metadata (page title, description, and thumbnail image) directly from the target website so your cards display rich previews.",
                ),
                _buildPolicySection(
                  "4. Device Permissions",
                  "• Camera: Used solely for scanning QR codes when adding links.\n"
                      "• Notifications: Used strictly to trigger local scheduled reminders you set.\n"
                      "• Storage / File Picker: Used only when you manually import or export backup files (.CSV or .XLSX).",
                ),
                _buildPolicySection(
                  "5. Your Control",
                  "You retain complete ownership of your data at all times. You can export your links to CSV or Excel backups, or delete your links permanently from your device whenever you choose.",
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String body, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textColorBlack,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.manrope(
              fontSize: 13.5,
              height: 1.55,
              fontWeight: FontWeight.w500,
              color: AppColors.subTitleColorGary,
            ),
          ),
        ],
      ),
    );
  }
}

