import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Utiles/category_helper.dart';
import '../../../resources/colors/app_colors.dart';

class CategoryItemCard extends StatelessWidget {
  final String categoryName;
  final int linkCount;
  final bool isGridMode;
  final VoidCallback onTap;

  const CategoryItemCard({
    super.key,
    required this.categoryName,
    required this.linkCount,
    required this.isGridMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyleHelper.getStyle(categoryName);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isGridMode ? _buildGridCard(style) : _buildListCard(style),
      ),
    );
  }

  Widget _buildListCard(CategoryStyle style) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Left Colored Accent Strip
          Container(
            width: 4.5,
            margin: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: style.iconColor,
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: style.bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(style.icon, color: style.iconColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textColorBlack,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "$linkCount ${linkCount == 1 ? 'link' : 'links'}",
                          style: GoogleFonts.manrope(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.subTitleColorGary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: style.bgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      linkCount.toString(),
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: style.iconColor,
                      ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(CategoryStyle style) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: style.bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(style.icon, color: style.iconColor, size: 22),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: style.bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  linkCount.toString(),
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: style.iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColorBlack,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "$linkCount ${linkCount == 1 ? 'link' : 'links'}",
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subTitleColorGary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}