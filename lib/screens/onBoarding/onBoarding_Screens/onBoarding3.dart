// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:texops/resources/colors/app_colors.dart';
//
// class OnBoarding3 extends StatelessWidget {
//   const OnBoarding3({super.key});
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
//                   'assets/lottie/DataAnalytics.json',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const SizedBox(height: 30),
//
//               // Title
//               const Text(
//                 "Real-Time Mill Insights",
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
//                 "Monitor yarn market trends and aggregate loom capacity to maximize your mill's profitability.",
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