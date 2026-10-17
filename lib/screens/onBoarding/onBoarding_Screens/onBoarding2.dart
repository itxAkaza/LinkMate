// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:texops/resources/colors/app_colors.dart';
//
// class OnBoarding2 extends StatelessWidget {
//   const OnBoarding2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: AppColors.backgroundLightPeach,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Lottie Animation
//               SizedBox(
//                 height: height * 0.4,
//                 child: Lottie.asset(
//                   'assets/lottie/Aitoolsabstract.json',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const SizedBox(height: 30),
//
//               // Title
//               const Text(
//                 "Automated Quality\nControl",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.primaryDarkTeal,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   height: 1.2,
//                 ),
//               ),
//               const SizedBox(height: 15),
//
//               // Description
//               const Text(
//                 "Log lab tests instantly and leverage AI to detect fabric defects before they hit the market.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontSize: 15,
//                   height: 1.5,
//                 ),
//               ),
//
//               SizedBox(height: height * 0.2),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }