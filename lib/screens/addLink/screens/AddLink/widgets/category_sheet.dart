import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../Utiles/category_helper.dart';
import '../../../../../controllers/addLink/addLinkController.dart';
import '../../../../../resources/colors/app_colors.dart';


class CategoryBottomSheet extends StatelessWidget {
  final AddLinkViewModel controller;

  const CategoryBottomSheet({super.key, required this.controller});

  static void show(BuildContext context, AddLinkViewModel controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryBottomSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: height * 0.78),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 14,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: height * 0.02),

          Text(
            "Select Category",
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textColorBlack,
            ),
          ),
          SizedBox(height: height * 0.018),

          // Add New Category TextFormField
          TextFormField(
            controller: controller.newCategoryController,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textColorBlack,
            ),
            decoration: InputDecoration(
              hintText: "Create new category...",
              hintStyle: GoogleFonts.manrope(
                color: AppColors.subTitleColorGary,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.overlayFieldGray,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixIcon: const Icon(LucideIcons.folderPlus, color: AppColors.textGray, size: 20),
              suffixIcon: IconButton(
                icon: const Icon(LucideIcons.circlePlus, color: AppColors.iconBlue, size: 22),
                onPressed: () {
                  if (controller.newCategoryController.text.trim().isNotEmpty) {
                    controller.addNewCategory(controller.newCategoryController.text);
                    Get.back();
                  }
                },
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.black12, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.iconBlue, width: 1.5),
              ),
            ),
            onFieldSubmitted: (val) {
              if (val.trim().isNotEmpty) {
                controller.addNewCategory(val);
                Get.back();
              }
            },
          ),
          SizedBox(height: height * 0.02),

          // Categories List
          Flexible(
            child: Obx(
                  () => ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.categories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final catName = controller.categories[index];
                  final style = CategoryStyleHelper.getStyle(catName);

                  return Obx(() {
                    final isSelected = controller.selectedCategory.value == catName;

                    return GestureDetector(
                      onTap: () {
                        controller.selectedCategory.value = catName;
                        Get.back();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.iconBlue.withOpacity(0.08)
                              : AppColors.overlayFieldGray.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.iconBlue.withOpacity(0.5)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Colored Pastel Icon Circle
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: style.bgColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                style.icon,
                                color: style.iconColor,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                catName,
                                style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: isSelected ? AppColors.iconBlue : AppColors.textColorBlack,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                LucideIcons.check,
                                color: AppColors.iconBlue,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}