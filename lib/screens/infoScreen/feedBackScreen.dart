import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../controllers/feedBack/feedBackController.dart';

import '../../resources/colors/app_colors.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FeedbackController>()
        ? Get.find<FeedbackController>()
        : Get.put(FeedbackController());

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

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
          "Feedback",
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
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Intro Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.iconBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          LucideIcons.mailPlus,
                          color: AppColors.iconBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "We'd love to hear from you",
                              style: GoogleFonts.manrope(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textColorBlack,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "Select a feedback type below and we'll prepare an email draft to PixelPlot support.",
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
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // 2. Feedback Type Selector (3 Types)
                Text(
                  "SELECT FEEDBACK TYPE",
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 10),

                Obx(() {
                  final selected = controller.selectedType.value;

                  if (isLandscape) {
                    return Row(
                      children: FeedbackType.values.map((type) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: type != FeedbackType.values.last ? 10 : 0,
                            ),
                            child: _buildTypeCard(
                              type: type,
                              isSelected: selected == type,
                              onTap: () => controller.selectType(type),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }

                  return Column(
                    children: FeedbackType.values.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildTypeCard(
                          type: type,
                          isSelected: selected == type,
                          onTap: () => controller.selectType(type),
                        ),
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 14),

                // 3. Description Input Field
                Text(
                  "YOUR MESSAGE",
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.descriptionController,
                  validator: controller.validateDescription,
                  maxLines: isLandscape ? 4 : 6,
                  minLines: isLandscape ? 3 : 5,
                  onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                  style: GoogleFonts.manrope(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorBlack,
                    height: 1.45,
                  ),
                  decoration: InputDecoration(
                    hintText:
                    "Tell us what happened, what feature you'd love to see, or how we can make LinkMate better...",
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.subTitleColorGary,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundWhite,
                    contentPadding: const EdgeInsets.all(16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: AppColors.iconBlue, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: AppColors.dangerRed),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Recipient Info Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.send, size: 15, color: AppColors.iconBlue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Sending draft to: ",
                                style: GoogleFonts.manrope(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subTitleColorGary,
                                ),
                              ),
                              TextSpan(
                                text: FeedbackController.supportEmail,
                                style: GoogleFonts.manrope(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textColorBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // 5. Send Review Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryButtonGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonGradientMiddle.withOpacity(0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: controller.sendFeedbackEmail,
                    icon: const Icon(LucideIcons.mailCheck, color: Colors.white, size: 19),
                    label: Obx(
                          () => Text(
                        controller.isSending.value ? "Opening Email App..." : "Send Review",
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
      ),
    );
  }

  Widget _buildTypeCard({
    required FeedbackType type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected
              ? type.color.withOpacity(0.08)
              : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? type.color : Colors.black12,
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: type.color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(type.icon, color: type.color, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.subTitleColorGary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? type.color : Colors.black26,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}