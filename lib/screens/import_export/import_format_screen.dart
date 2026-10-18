import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


import '../../controllers/impExp/impExpController.dart';
import '../../resources/colors/app_colors.dart';

class ImportFormatScreen extends StatelessWidget {
  const ImportFormatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ImportExportController>()
        ? Get.find<ImportExportController>()
        : Get.put(ImportExportController());

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.iconBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      LucideIcons.fileSpreadsheet,
                      color: AppColors.iconBlue,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Import Your Links",
                          style: GoogleFonts.manrope(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColorBlack,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Make sure your CSV or Excel (.xlsx) file follows this format",
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.subTitleColorGary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // 2. Format Specification Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormatField(
                      columnName: "LinkName",
                      isRequired: true,
                      description: "The title or label you give the link",
                      example: "Best Figma Tutorial 2026",
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: Colors.black12, height: 1),
                    ),
                    _buildFormatField(
                      columnName: "Link",
                      isRequired: true,
                      description: "The full URL including https://",
                      example: "https://youtube.com/watch?v=...",
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: Colors.black12, height: 1),
                    ),
                    _buildFormatField(
                      columnName: "Category",
                      isRequired: false,
                      description: "Category name (e.g. Work, Videos, Web)",
                      example: "Videos",
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(color: Colors.black12, height: 1),
                    ),
                    _buildFormatField(
                      columnName: "IsFavorite",
                      isRequired: false,
                      description: "Mark as favorite — TRUE or FALSE",
                      example: "TRUE",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Info Note Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        LucideIcons.info,
                        size: 17,
                        color: AppColors.subTitleColorGary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Column order doesn't matter, and duplicate links are automatically skipped so your existing vault stays safe.",
                        style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.subTitleColorGary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 4. GENERIC SELECT FILE BUTTON (Supports both CSV and Excel)
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryButtonGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.buttonGradientMiddle.withOpacity(0.32),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: controller.importLinksFromFile,
                  child: Obx(
                        () => controller.isProcessing.value
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.8,
                      ),
                    )
                        : Text(
                      "Select File (.CSV or .XLSX)",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
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

  Widget _buildFormatField({
    required String columnName,
    required bool isRequired,
    required String description,
    required String example,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              columnName,
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.iconBlue,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isRequired
                    ? AppColors.iconBlue.withOpacity(0.1)
                    : AppColors.overlayFieldGray,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isRequired ? "Required" : "Optional",
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isRequired ? AppColors.iconBlue : AppColors.textGray,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: GoogleFonts.manrope(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textColorBlack,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "e.g.",
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.subTitleColorGary,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.overlayFieldGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  example,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColorBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}