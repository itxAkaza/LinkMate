import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Utils {

  // 1. Fixed typo in method name
  static void fieldFocusChange(BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // 2. Standardized name and fixed typo for general errors
  static void showErrorToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  // 3. Standardized name and fixed typo for general success
  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  // 4. WhatsApp-style custom toast (Replaced ShowSnackbar)
  static void showInAppToast(String title, String message, {VoidCallback? onTap}) {
    Get.snackbar(
      title,
      message,
      onTap: (snack) {
        if (onTap != null) onTap();
      },
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      borderRadius: 16,

      icon: Container(
        margin: const EdgeInsets.only(left: 8),
        child: CircleAvatar(
          backgroundColor: const Color(0xFF2B7FFF).withOpacity(0.1),
          child: const Icon(Icons.link, color: Color(0xFF2B7FFF)),
        ),
      ),
      shouldIconPulse: false,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      titleText: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
      ),
      messageText: Text(
        message,
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // 5. Made Dialog generic (Removed hardcoded "Log out" text)
  static void showActionDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 20, bottom: 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black54),
      ),

      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2B7FFF),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Get.back(); // Close dialog automatically
          onConfirm(); // Execute action
        },
        child: Text(confirmText, style: const TextStyle(color: Colors.white)),
      ),

      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(cancelText, style: const TextStyle(color: Colors.redAccent)),
      ),

      backgroundColor: Colors.white,
      radius: 12,
    );
  }
}