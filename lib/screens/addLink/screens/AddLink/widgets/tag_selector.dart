import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../controllers/addLink/addLinkController.dart';
import '../../../../../resources/colors/app_colors.dart';


class TagsSelectorSection extends StatelessWidget {
  final AddLinkViewModel controller;

  const TagsSelectorSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Tag Input + Plus Button
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.customTagController,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: "Add custom tag...",
                    hintStyle: GoogleFonts.manrope(
                      color: AppColors.subTitleColorGary,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      LucideIcons.tag,
                      color: AppColors.textGray,
                      size: 18,
                    ),
                    filled: true,
                    fillColor: AppColors.overlayFieldGray,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.iconBlue, width: 1.5),
                    ),
                  ),
                  onFieldSubmitted: (_) => controller.addCustomTag(),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: controller.addCustomTag,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppColors.iconBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.plus, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.018),

          Text(
            "Suggested tags:",
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textGray,
            ),
          ),
          SizedBox(height: height * 0.012),

          // Interactive Tag Chips
          Obx(
                () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.suggestedTags.map((tag) {
                final isSelected = controller.selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => controller.toggleTag(tag),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.iconBlue
                          : AppColors.overlayFieldGray.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.iconBlue : Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? LucideIcons.check : LucideIcons.plus,
                          size: 14,
                          color: isSelected ? Colors.white : AppColors.textGray,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tag,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.textColorBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}