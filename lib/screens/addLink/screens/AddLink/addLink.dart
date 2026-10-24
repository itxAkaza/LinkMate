import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:linkvault/screens/addLink/screens/AddLink/widgets/category_sheet.dart';
import 'package:linkvault/screens/addLink/screens/AddLink/widgets/scrool_bar.dart';
import 'package:linkvault/screens/addLink/screens/AddLink/widgets/tag_selector.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Utiles/category_helper.dart';
import '../../../../controllers/addLink/addLinkController.dart';
import '../../../../model/link_model.dart';
import '../../../../resources/colors/app_colors.dart';

class AddLinkScreen extends StatefulWidget {
  final LinkItem? editingLink;
  final String? initialSharedUrl;

  const AddLinkScreen({
    super.key,
    this.editingLink,
    this.initialSharedUrl,
  });

  @override
  State<AddLinkScreen> createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends State<AddLinkScreen> {
  late final AddLinkViewModel controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<AddLinkViewModel>()
        ? Get.find<AddLinkViewModel>()
        : Get.put(AddLinkViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.configureMode(
        linkToEdit: widget.editingLink,
        initialSharedUrl: widget.initialSharedUrl,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
        title: Obx(
              () => Text(
            controller.isEditMode.value ? "Edit Link" : "Add Link",
            style: GoogleFonts.manrope(
              color: AppColors.textColorBlack,
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black12),
                ),
                child: const Icon(LucideIcons.x, color: AppColors.textGray, size: 18),
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: LiquidGlassScrollbar(
          controller: controller.scrollController,
          child: SingleChildScrollView(
            controller: controller.scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. URL FIELD
                _buildSectionLabel("URL"),
                TextFormField(
                  controller: controller.urlController,
                  validator: controller.validateUrl,
                  keyboardType: TextInputType.url,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: "https://example.com",
                    hintStyle: GoogleFonts.manrope(
                      color: AppColors.subTitleColorGary,
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundWhite,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    prefixIcon: const Icon(LucideIcons.link, color: AppColors.iconBlue, size: 20),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() => controller.urlText.value.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.cancel, color: Colors.grey.shade400, size: 20),
                          onPressed: () => controller.urlController.clear(),
                        )
                            : const SizedBox.shrink()),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: controller.openScanner,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.iconBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                LucideIcons.scanLine,
                                color: AppColors.iconBlue,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black12, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.iconBlue, width: 1.8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.dangerRed, width: 1.8),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.022),

                // 2. DESCRIPTION FIELD (Optional)
                _buildSectionLabel("DESCRIPTION"),
                TextFormField(
                  controller: controller.descriptionController,
                  maxLines: 3,
                  minLines: 2,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: "Add notes or description for this link (optional)...",
                    hintStyle: GoogleFonts.manrope(
                      color: AppColors.subTitleColorGary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundWhite,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black12, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.iconBlue, width: 1.8),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.022),

                // 3. CATEGORY SELECTOR (With Colored Icon)
                _buildSectionLabel("CATEGORY"),
                GestureDetector(
                  onTap: () => CategoryBottomSheet.show(context, controller),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12, width: 1),
                    ),
                    child: Obx(() {
                      final catName = controller.selectedCategory.value;
                      final style = CategoryStyleHelper.getStyle(catName);

                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: style.bgColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(style.icon, color: style.iconColor, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              catName,
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColorBlack,
                              ),
                            ),
                          ),
                          const Icon(LucideIcons.chevronDown, color: AppColors.textGray, size: 20),
                        ],
                      );
                    }),
                  ),
                ),
                SizedBox(height: height * 0.022),

                // 4. SET REMINDER CARD (Uses board_datetime_picker)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          PhysicalModel(
                            color: AppColors.iconBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(LucideIcons.clock, color: AppColors.iconBlue, size: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Set Reminder",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.textColorBlack,
                                  ),
                                ),
                                Text(
                                  "Get notified to revisit this link",
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: AppColors.subTitleColorGary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                                () => Switch(
                              value: controller.isReminderEnabled.value,
                              activeThumbColor: Colors.white,
                              activeTrackColor: AppColors.iconBlue,
                              onChanged: (val) => controller.toggleReminder(val, context),
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        if (!controller.isReminderEnabled.value) {
                          return const SizedBox.shrink();
                        }
                        final dt = controller.reminderDateTime.value;
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.pickReminderDateTime(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.overlayFieldGray,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(LucideIcons.calendar, size: 16, color: AppColors.iconBlue),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('dd/MM/yyyy').format(dt),
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textColorBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.pickReminderDateTime(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.overlayFieldGray,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(LucideIcons.clock4, size: 16, color: AppColors.iconBlue),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('hh:mm a').format(dt),
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textColorBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.015),

                // 5. SAVE TO PRIVATE VAULT CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: Row(
                    children: [
                      PhysicalModel(
                        color: AppColors.overlayFieldGray,
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(LucideIcons.lock, color: AppColors.textGray, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Save to Private Vault",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.textColorBlack,
                              ),
                            ),
                            Text(
                              "Requires 4-digit PIN to view later",
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AppColors.subTitleColorGary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                            () => Switch(
                          value: controller.isPrivate.value,
                          activeThumbColor: Colors.white,
                          activeTrackColor: AppColors.iconBlue,
                          onChanged: (val) => controller.togglePrivateVault(val),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.022),

                // 6. TAGS SECTION COMPONENT
                _buildSectionLabel("TAGS"),
                TagsSelectorSection(controller: controller),
                SizedBox(height: height * 0.035),

                // 7. GRADIENT SAVE / UPDATE BUTTON WITH LOADING STATE
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryButtonGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonGradientMiddle.withOpacity(0.35),
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      if (!controller.isSaving.value) {
                        controller.saveLink();
                      }
                    },
                    child: Obx(() => controller.isSaving.value
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                        : Text(
                      controller.isEditMode.value ? "Update Link" : "Save Link",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    )),
                  ),
                ),
                SizedBox(height: height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: AppColors.textGray,
        ),
      ),
    );
  }
}