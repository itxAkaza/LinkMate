import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../resources/colors/app_colors.dart';



class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          "About LinkVault",
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryButtonGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(LucideIcons.link2, color: Colors.white, size: 34),
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
                    const SizedBox(height: 4),
                    Text(
                      "Version 1.0.0",
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.iconBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "LinkVault is your smart, offline-first personal link manager. Save articles, videos, and resources from any app, organize them with custom categories and tags, schedule reminders, and lock sensitive links inside your PIN-protected Private Vault.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 13.5,
                        height: 1.55,
                        fontWeight: FontWeight.w500,
                        color: AppColors.subTitleColorGary,
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