

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Utiles/category_helper.dart';
import '../../../controllers/reminder/reminderController.dart';
import '../../../model/link_model.dart';
import '../../../resources/colors/app_colors.dart';

class ReminderLinkCard extends StatelessWidget {
  final LinkItem link;
  final ReminderController controller;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;
  final VoidCallback onBellTap;

  const ReminderLinkCard({
    super.key,
    required this.link,
    required this.controller,
    required this.onTap,
    required this.onMoreTap,
    required this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryName = link.category ?? 'Web';
    final catStyle = CategoryStyleHelper.getStyle(categoryName);

    final bool done = controller.isDone(link);
    final bool overdue = controller.isOverdue(link);
    final bool today = controller.isDueToday(link);

    // Status Accent Colors
    final Color statusColor = done
        ? const Color(0xFF10B981)
        : overdue
        ? const Color(0xFFEF4444)
        : today
        ? const Color(0xFFF59E0B)
        : AppColors.iconBlue;

    final Color statusBg = done
        ? const Color(0xFFD1FAE5)
        : overdue
        ? const Color(0xFFFEE2E2)
        : today
        ? const Color(0xFFFEF3C7)
        : const Color(0xFFDBEAFE);

    final String statusText = done
        ? "Done"
        : overdue
        ? "Overdue"
        : today
        ? "Due today"
        : "Scheduled";

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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Colored Vertical Accent Strip
              Container(
                width: 4.5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Check Circle (Also marks as read)
                      GestureDetector(
                        onTap: onBellTap,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, right: 10),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done ? const Color(0xFF10B981) : Colors.transparent,
                              border: Border.all(
                                color: done ? const Color(0xFF10B981) : Colors.grey.shade400,
                                width: 1.6,
                              ),
                            ),
                            child: done
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                : null,
                          ),
                        ),
                      ),

                      // Thumbnail or Colored Category Icon
                      _buildThumbnail(catStyle, 46),
                      const SizedBox(width: 12),

                      // Center Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              link.displayDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textColorBlack,
                                decoration: done ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  LucideIcons.calendar,
                                  size: 13,
                                  color: AppColors.subTitleColorGary,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    link.reminder != null
                                        ? controller.formatReminderTime(link.reminder!)
                                        : '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.manrope(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.subTitleColorGary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                // Clean Category Pill (NO DOT)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: catStyle.bgColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    categoryName,
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: catStyle.iconColor,
                                    ),
                                  ),
                                ),
                                // Due Status Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusBg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Right Actions: Bell (Mark as Read) + 3 Dots
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: onBellTap,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: done
                                    ? const Color(0xFFD1FAE5)
                                    : AppColors.iconBlue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                done ? LucideIcons.bellOff : LucideIcons.bellRing,
                                size: 16,
                                color: done ? const Color(0xFF10B981) : AppColors.iconBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: onMoreTap,
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.more_vert, size: 19, color: AppColors.textGray),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(CategoryStyle style, double size) {
    final hasImage = link.metaImage != null && link.metaImage!.trim().isNotEmpty;
    if (hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          link.metaImage!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackIcon(style, size),
        ),
      );
    }
    return _fallbackIcon(style, size);
  }

  Widget _fallbackIcon(CategoryStyle style, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(style.icon, color: style.iconColor, size: size * 0.45),
    );
  }
}