// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:texops/resources/colors/app_colors.dart';
//
// class OnBoarding1 extends StatelessWidget {
//   const OnBoarding1({super.key});
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
//                 height: height * 0.4, // Takes up 40% of screen height
//                 child: Lottie.asset(
//                   'assets/lottie/ecommerceautomation.json',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const SizedBox(height: 30),
//
//               // Title
//               const Text(
//                 "Smart Bale Tracking",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.primaryDarkTeal,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 15),
//
//               // Description
//               const Text(
//                 "Digitize your gate passes and track every cotton bale from entry to consumption seamlessly.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black87,
//                   fontSize: 15,
//                   height: 1.5, // Improves line spacing for readability
//                 ),
//               ),
//
//               // Bottom spacing to ensure content doesn't hide behind the page indicator
//               SizedBox(height: height * 0.2),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }