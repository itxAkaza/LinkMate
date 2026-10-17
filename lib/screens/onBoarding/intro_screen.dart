// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:texops/controllers/onBoarding/onBoarding_controller.dart';
// import 'package:texops/resources/colors/app_colors.dart';
// import 'package:texops/screens/lab_engineer/dashboard/lab_enigneer_dashboard.dart';
// import 'package:texops/screens/onBoarding/onBoarding_Screens/onBoarding2.dart';
// import 'package:texops/screens/onBoarding/onBoarding_Screens/onBoarding3.dart';
// import 'package:texops/screens/onBoarding/widgets/my_button.dart';
//
// import '../auth/login_screen.dart';
// import 'onBoarding_Screens/onBoarding1.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// class IntroScreen extends StatelessWidget {
//    IntroScreen({super.key});
//
//   final introController=Get.put(onBoradingController());
//
//   @override
//   Widget build(BuildContext context) {
//
//     final height =MediaQuery.of(context).size.height;
//     final width =MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           PageView(
//             controller:introController.controller ,
//             onPageChanged: (value){
//               !(value==2)?introController.makeLast(false):introController.makeLast(true) ;
//
//             },
//
//             children: [
//               OnBoarding1(),
//               OnBoarding2(),
//               OnBoarding3(),
//
//
//             ],
//
//           ),
//
//
//           Container(
//             alignment: Alignment(0,0.65),
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: SmoothPageIndicator(
//               controller: introController.controller,
//               count: 3,
//               effect: ExpandingDotsEffect(
//                   dotColor: AppColors.pageIndicator,
//                   activeDotColor: AppColors.primaryDarkTeal,
//                   dotWidth: 13,
//                   dotHeight: 13,
//                   paintStyle: PaintingStyle.fill
//               ),
//
//             ),
//           ),
//
//           Container(
//             alignment: Alignment(0,0.9),
//             child: Obx((){
//               return introController.isLast.value
//                   ?
//
//               MYButton(text: "Get Started", height: height*0.07,width: width*0.85,
//                   onTap:
//                       (){
//                     Get.offAll(()=>LoginScreen());
//                     Get.delete<onBoradingController>();
//
//                   }
//               ) :
//
//               MYButton(text: "Next",height: height*0.07,width: width*0.85,
//                   onTap:
//                       ()=>introController.controller.nextPage(
//                       duration: Duration(milliseconds: 500),
//                       curve: Curves.easeIn)
//               );
//
//             }),
//           )
//
//
//
//
//         ],
//       ),
//     );
//   }
// }
