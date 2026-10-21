import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Utiles/category_helper.dart';
import '../../../model/link_model.dart';
import '../../../resources/colors/app_colors.dart';

class QuickShareQrScreen extends StatelessWidget {
  final LinkItem link;

  const QuickShareQrScreen({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final style = CategoryStyleHelper.getStyle(link.category!);

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
          "Quick Share QR",
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: isLandscape
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildInfoAndShareBtn(style)),
              const SizedBox(width: 24),
              Expanded(child: _buildQrCodeContainer()),
            ],
          )
              : Column(
            children: [
              _buildInfoAndShareBtn(style, includeQrCode: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoAndShareBtn(CategoryStyle style, {bool includeQrCode = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: style.bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(style.icon, size: 15, color: style.iconColor),
                    const SizedBox(width: 6),
                    Text(
                      link.category!,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: style.iconColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                link.displayDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColorBlack,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                link.url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subTitleColorGary,
                ),
              ),

              if (includeQrCode) ...[
                const SizedBox(height: 24),
                _buildQrCodeContainer(),
              ],

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.scanLine, size: 16, color: AppColors.iconBlue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Point any camera to open this link",
                        style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGray,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: AppColors.primaryButtonGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.buttonGradientMiddle.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => Share.share(link.url, subject: link.displayDescription),
            icon: const Icon(LucideIcons.share2, color: Colors.white, size: 18),
            label: Text(
              "Share Link Directly",
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrCodeContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.iconBlue.withOpacity(0.25),
          width: 2,
        ),
      ),
      child: QrImageView(
        data: link.url,
        version: QrVersions.auto,
        backgroundColor: Colors.white,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: AppColors.textColorBlack,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.circle,
          color: AppColors.textColorBlack,
        ),
      ),
    );
  }
}