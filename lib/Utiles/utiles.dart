import 'package:flutter/material.dart';

import 'package:get/get.dart';

class Utils {
  static void fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode nextFocus,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /// Helper to clear any active toast/snackbar so they never stack
  static void _clearActiveNotifications() {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
  }

  // 2. In-app Error Toast (Never lingers outside the app & never stacks)
  static void showErrorToast(String message) {
    _clearActiveNotifications();

    if (Get.overlayContext != null) {
      Get.rawSnackbar(
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.redAccent,
        borderRadius: 13,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 250),
        isDismissible: true,
      );
    }
  }

  // 3. In-app Success Toast (Never lingers outside the app & never stacks)
  static void showSuccessToast(String message) {
    _clearActiveNotifications();

    if (Get.overlayContext != null) {
      Get.rawSnackbar(
        messageText: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green.shade600,
        borderRadius: 13,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 250),
        isDismissible: true,
      );
    }
  }

  // 4. WhatsApp-style custom toast (Prevents stacking when toggling settings repeatedly)
  static void showInAppToast(
    String title,
    String message, {
    VoidCallback? onTap,
  }) {
    _clearActiveNotifications();

    Get.snackbar(
      title,
      message,
      onTap: (snack) {
        if (onTap != null) onTap();
      },
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 250),
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
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // 5. Generic Action Dialog
  static void showActionDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
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
          Get.back();
          onConfirm();
        },
        child: Text(confirmText, style: const TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          cancelText,
          style: const TextStyle(color: Colors.redAccent),
        ),
      ),
      backgroundColor: Colors.white,
      radius: 12,
    );
  }
}
