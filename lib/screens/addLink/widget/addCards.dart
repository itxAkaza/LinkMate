import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../resources/colors/app_colors.dart';

class AddCards extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback onTap;
  const AddCards({super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: AppColors.overlayFieldGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 9),
            child: Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: PhysicalModel(
                    color: Colors.blueAccent.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(14),
                    child:  Padding(
                      padding: EdgeInsets.all(13),
                      child: Icon(icon,
                          color: AppColors.iconBlue
                      ),
                    ),
                  ),
                ),

                ListTile(
                  title: Text(title,
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.textColorBlack
                    ),
                  ),
                  subtitle: Text(subTitle,
                    style: GoogleFonts.manrope(
                        color: AppColors.subTitleColorGary
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
}
