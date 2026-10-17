import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../model/link_model.dart';
import '../../../resources/colors/app_colors.dart';

class LinkDetailScreen extends StatelessWidget {
  final LinkItem link;

  const LinkDetailScreen({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.readOnlyBg,
      appBar: AppBar(
        backgroundColor: AppColors.readOnlyBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textColorBlack),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Link Details",
          style: GoogleFonts.manrope(
            color: AppColors.textColorBlack,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Link Detail Screen — Coming Next"),
      ),
    );
  }
}