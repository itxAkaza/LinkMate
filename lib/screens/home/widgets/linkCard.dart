import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utiles/category_helper.dart';
import '../../../model/link_model.dart';
import '../../../resources/colors/app_colors.dart';

class LinkCardWidget extends StatelessWidget {
  final LinkItem link;
  final bool isGridMode;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;
  final VoidCallback onFavouriteTap;

  const LinkCardWidget({
    super.key,
    required this.link,
    required this.isGridMode,
    required this.onTap,
    required this.onMoreTap,
    required this.onFavouriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName = link.category ?? 'Web';
    final style = CategoryStyleHelper.getStyle(categoryName);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: isGridMode
            ? _buildGridLayout(style, categoryName)
            : _buildListLayout(style, categoryName),
      ),
    );
  }

  Widget _buildListLayout(CategoryStyle style, String categoryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(style, size: 62),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    link.displayDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColorBlack,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    link.url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.subTitleColorGary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onMoreTap,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.more_vert, size: 20, color: AppColors.textGray),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: onFavouriteTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      link.isFavourite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: link.isFavourite ? AppColors.dangerRed : AppColors.subTitleColorGary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildCategoryBadge(style, categoryName),
            ...link.tags.map((tag) => _buildTagChip(tag)),
          ],
        ),
      ],
    );
  }

  Widget _buildGridLayout(CategoryStyle style, String categoryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(style, size: 48),
            Row(
              children: [
                InkWell(
                  onTap: onFavouriteTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      link.isFavourite ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: link.isFavourite ? AppColors.dangerRed : AppColors.subTitleColorGary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onMoreTap,
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.more_vert, size: 18, color: AppColors.textGray),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          link.displayDescription,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textColorBlack,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          link.url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.subTitleColorGary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            _buildCategoryBadge(style, categoryName),
            ...link.tags.take(3).map((tag) => _buildTagChip(tag)),
          ],
        ),
      ],
    );
  }

  Widget _buildThumbnail(CategoryStyle style, {required double size}) {
    final hasMetaImg = link.metaImage != null && link.metaImage!.trim().isNotEmpty;

    if (hasMetaImg) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          link.metaImage!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildFallbackBox(style, size),
        ),
      );
    }
    return _buildFallbackBox(style, size);
  }

  Widget _buildFallbackBox(CategoryStyle style, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(style.icon, color: style.iconColor, size: size * 0.44),
    );
  }

  // UPDATED: Clean Category Pill without the dot!
  Widget _buildCategoryBadge(CategoryStyle style, String categoryName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: style.bgColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        categoryName,
        style: GoogleFonts.manrope(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: style.iconColor,
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.overlayFieldGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "#$tag",
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textGray,
        ),
      ),
    );
  }
}