import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Utiles/category_helper.dart';
import '../../../controllers/home/homeController.dart';
import '../../../model/link_model.dart';
import '../../../resources/colors/app_colors.dart';
import '../../addLink/screens/AddLink/addLink.dart';
import '../share/quickQRShare_screen.dart';

class LinkActionsBottomSheet extends StatelessWidget {
  final LinkItem link;
  final HomeController controller;

  const LinkActionsBottomSheet({
    super.key,
    required this.link,
    required this.controller,
  });

  static void show(BuildContext context, LinkItem link, HomeController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LinkActionsBottomSheet(link: link, controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyleHelper.getStyle(link.category!);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 18),
        
            // Header Preview
            Row(
              children: [
                _buildSmallThumbnail(style),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        link.displayDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textColorBlack,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        link.url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.subTitleColorGary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 16),
        
            // 1. Copy URL
            _buildActionTile(
              icon: LucideIcons.copy,
              title: "Copy URL",
              onTap: () {
                Get.back();
                controller.copyLink(link.url);
              },
            ),
            const SizedBox(height: 10),
        
            // 2. Edit Link (Passes LinkItem reference to AddLinkScreen)
            _buildActionTile(
              icon: LucideIcons.pencil,
              title: "Edit",
              onTap: () {
                Get.back();
                Get.to(() => AddLinkScreen(editingLink: link));
              },
            ),
            const SizedBox(height: 10),
        
            // 3. Split Share Row (Cut in Half: Simple Share & Quick QR)
            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    icon: LucideIcons.share2,
                    title: "Share URL",
                    onTap: () {
                      Get.back();
                      controller.shareLinkNative(link);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionTile(
                    icon: LucideIcons.qrCode,
                    title: "Quick QR",
                    iconColor: AppColors.iconBlue,
                    bgColor: AppColors.iconBlue.withOpacity(0.08),
                    onTap: () {
                      Get.back();
                      Get.to(() => QuickShareQrScreen(link: link));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
        
            // 4. Delete Link
            _buildActionTile(
              icon: LucideIcons.trash2,
              title: "Delete",
              textColor: AppColors.dangerRed,
              iconColor: AppColors.dangerRed,
              bgColor: AppColors.dangerRed.withOpacity(0.08),
              tileColor: AppColors.dangerRed.withOpacity(0.06),
              onTap: () {
                Get.back();
                controller.deleteLink(link);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallThumbnail(CategoryStyle style) {
    final hasImage = link.metaImage != null && link.metaImage!.trim().isNotEmpty;
    if (hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          link.metaImage!,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackIcon(style),
        ),
      );
    }
    return _buildFallbackIcon(style);
  }

  Widget _buildFallbackIcon(CategoryStyle style) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(style.icon, color: style.iconColor, size: 22),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = AppColors.textColorBlack,
    Color iconColor = AppColors.textColorBlack,
    Color? bgColor,
    Color tileColor = AppColors.overlayFieldGray,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor ?? Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}