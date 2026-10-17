// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:texops/services/userPrefrence.dart';
//
// import '../screens/admin/dashboard/admin_dashboard.dart';
// import '../screens/lab_engineer/dashboard/lab_enigneer_dashboard.dart';
// import '../screens/onBoarding/intro_screen.dart';
// import '../screens/qualityPerson/quality_personDashBoard.dart';
// import '../user_prefernce/user_preference.dart';
//
//
//
// class SplashServices {
//   final userPref = UserPreference();
//
//   void checkLoginAndRoute() async {
//     // Wait half a second so Flutter can finish building the UI
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     User? currentUser = FirebaseAuth.instance.currentUser;
//
//     if (currentUser == null) {
//       // SCENARIO 1: Not logged in (or logged out).
//       // THE FIX: Do absolutely nothing! Just stay on the Intro Screen.
//       // (Removing Get.offAll here stops the infinite flashing loop).
//       return;
//     } else {
//       // SCENARIO 2: They are logged in. Let's check SharedPreferences!
//       String? localRole = await userPref.getUserRole();
//
//       if (localRole != null) {
//         // Route them INSTANTLY
//         _routeBasedOnRole(localRole);
//       } else {
//         try {
//           DocumentSnapshot doc = await FirebaseFirestore.instance
//               .collection('users')
//               .doc(currentUser.uid)
//               .get();
//
//           if (doc.exists) {
//             String role = doc.get('role');
//             await userPref.saveUserRole(role);
//             _routeBasedOnRole(role);
//           } else {
//             // Profile missing: Force logout, but don't re-route to avoid loops
//             await FirebaseAuth.instance.signOut();
//             await userPref.clearUserData();
//           }
//         } catch (e) {
//           // Error: Force logout, but don't re-route
//           await FirebaseAuth.instance.signOut();
//           await userPref.clearUserData();
//         }
//       }
//     }
//   }
//
//   // The Traffic Cop
//   void _routeBasedOnRole(String role) {
//     if (role == 'admin') {
//       Get.offAll(() => AdminDashboard());
//     } else if (role == 'Lab Engineer') {
//       Get.offAll(() => LabEnigneerDashboard());
//     } else if (role == 'Quality Engineer') {
//       Get.offAll(() => QualityPersondashboard());
//     } else {
//       logoutAndGoToIntro(); // Unknown role fallback
//     }
//   }
//
//   // Use this method anywhere in your app when a user taps "Log Out"
//   void logoutAndGoToIntro() async {
//     await FirebaseAuth.instance.signOut();
//     await userPref.clearUserData(); // Wipe the local role
//     Get.offAll(() => IntroScreen()); // Send back to intro
//   }
// }