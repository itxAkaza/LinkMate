import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../controllers/impExp/impExpController.dart';

import '../../model/link_model.dart';
import '../../resources/colors/app_colors.dart';
import '../../services/link/linkImportExport_service.dart';
import 'import_format_screen.dart';


class ImportExportScreen extends StatelessWidget {
  const ImportExportScreen({super.key});

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
        title: Text(
          "Import / Export",
          style: GoogleFonts.manrope(
            color: AppColors.textColorBlack,
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<LinkItem>>(
        valueListenable: controller.listenableLinks,
        builder: (context, box, _) {
          final totalLinks = box.values.where((l) => !l.isPrivate).length;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),

                // 1. GLOWING CIRCULAR TOTAL LINKS COUNTER
                Container(
                  width: 148,
                  height: 148,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.iconBlue.withOpacity(0.10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.iconBlue.withOpacity(0.18),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Container(
                    width: 112,
                    height: 112,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryButtonGradient,
                    ),
                    child: Text(
                      "$totalLinks",
                      style: GoogleFonts.manrope(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Text(
                  "Links are available",
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textColorBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ready to back up or transfer",
                  style: GoogleFonts.manrope(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.subTitleColorGary,
                  ),
                ),
                const SizedBox(height: 22),

                // 2. SELECT EXPORT FILE TYPE (CSV vs EXCEL .XLSX)
                Text(
                  "SELECT EXPORT FILE TYPE",
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final isCsv = controller.selectedExportType.value == ExportFileType.csv;
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildFormatSegment(
                            label: "CSV File (.csv)",
                            icon: LucideIcons.fileText,
                            isSelected: isCsv,
                            onTap: () => controller.setExportType(ExportFileType.csv),
                          ),
                        ),
                        Expanded(
                          child: _buildFormatSegment(
                            label: "Excel (.xlsx)",
                            icon: LucideIcons.fileSpreadsheet,
                            isSelected: !isCsv,
                            onTap: () => controller.setExportType(ExportFileType.xlsx),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 26),

                // 3. EXPORT LINKS CARD
                Obx(
                      () => _buildActionOptionCard(
                    icon: LucideIcons.upload,
                    title: "Export Links",
                    subtitle: controller.selectedExportType.value == ExportFileType.csv
                        ? "Instantly save all your links as a CSV backup"
                        : "Instantly save all your links as an Excel (.xlsx) workbook",
                    isLoading: controller.isProcessing.value,
                    onTap: controller.exportAllLinks,
                  ),
                ),
                const SizedBox(height: 14),

                // 4. IMPORT LINKS CARD
                _buildActionOptionCard(
                  icon: LucideIcons.download,
                  title: "Import Links",
                  subtitle: "Bring in links from a CSV or Excel (.xlsx) file",
                  isLoading: false,
                  onTap: () => Get.to(() => const ImportFormatScreen()),
                ),
                const SizedBox(height: 20),

                // 5. LAST EXPORT TIMESTAMP
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                        () => RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Last export: ",
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.subTitleColorGary,
                            ),
                          ),
                          TextSpan(
                            text: controller.lastExportTime.value,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textColorBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormatSegment({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.iconBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textGray,
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.overlayFieldGray,
                borderRadius: BorderRadius.circular(14),
              ),
              child: isLoading
                  ? const Padding(
                padding: EdgeInsets.all(13),
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.iconBlue,
                ),
              )
                  : Icon(icon, color: AppColors.textColorBlack, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.subTitleColorGary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: AppColors.subTitleColorGary,
            ),
          ],
        ),
      ),
    );
  }
}