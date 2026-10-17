// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class NotificationController extends GetxController {
//   // Observable list of notifications
//   var notificationsList = <Map<String, dynamic>>[].obs;
//   var isLoading = true.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchNotifications();
//   }
//
//   // Real-time listener for the user's inbox
//   void fetchNotifications() {
//     String? uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) {
//       isLoading.value = false;
//       return;
//     }
//
//     // Set up a live stream to the exact folder Python writes to
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('notifications')
//         .orderBy('timestamp', descending: true) // Newest first
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//
//       notificationsList.value = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['docId'] = doc.id; // Keep the document ID so we can delete it later
//         return data;
//       }).toList();
//
//       isLoading.value = false;
//     });
//   }
//
//   // Logic to clear the inbox instantly
//   Future<void> markAllAsRead() async {
//     String? uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null || notificationsList.isEmpty) return;
//
//     try {
//       var collection = FirebaseFirestore.instance.collection('users').doc(uid).collection('notifications');
//       var snapshots = await collection.get();
//
//       // WriteBatch deletes everything simultaneously, saving database read/write costs!
//       WriteBatch batch = FirebaseFirestore.instance.batch();
//       for (var doc in snapshots.docs) {
//         batch.delete(doc.reference);
//       }
//       await batch.commit();
//
//       Get.snackbar(
//           "Inbox Cleared",
//           "All notifications marked as read.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.black87,
//           colorText: Colors.white,
//           margin: const EdgeInsets.all(20)
//       );
//     } catch (e) {
//       Get.snackbar("Error", "Could not clear notifications.", backgroundColor: Colors.redAccent, colorText: Colors.white);
//     }
//   }
// }