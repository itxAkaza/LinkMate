// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:texops/resources/colors/app_colors.dart';
//
// class MYButton extends StatelessWidget {
//   final String text;
//   final double height;
//   final double width;
//   final VoidCallback? onTap;
//
//   const MYButton({super.key ,
//     required this.text,
//     required this.height,
//     required this.width,
//     required this.onTap
//   } );
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//           color: AppColors.primaryDarkTeal,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Center(
//           child: Text(text,style: GoogleFonts.poppins(
//             textStyle: TextStyle(
//               color: AppColors.readOnlyBg,
//               fontSize: 17,
//               fontWeight: .w500
//             )
//           ),),
//         ),
//       ),
//     );
//   }
// }
