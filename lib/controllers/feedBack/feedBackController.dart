import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utiles/app_haptic.dart';
import '../../Utiles/utiles.dart';

enum FeedbackType {
  bugReport(
    label: "Bug Report",
    subtitle: "Something isn't working right",
    icon: LucideIcons.bug,
    color: Color(0xFFEF4444),
  ),
  featureRequest(
    label: "Feature Idea",
    subtitle: "Request a new tool or improvement",
    icon: LucideIcons.sparkles,
    color: Color(0xFF3B82F6),
  ),
  generalFeedback(
    label: "General Review",
    subtitle: "Share your thoughts on LinkMate",
    icon: LucideIcons.messageSquareHeart,
    color: Color(0xFF10B981),
  );

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const FeedbackType({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class FeedbackController extends GetxController {
  static const String supportEmail = 'pixelplot.app@gmail.com';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();

  final Rx<FeedbackType> selectedType = FeedbackType.featureRequest.obs;
  final RxBool isSending = false.obs;

  void selectType(FeedbackType type) {
    AppHaptics.lightTap();
    selectedType.value = type;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a brief description of your feedback";
    }
    if (value.trim().length < 8) {
      return "Please provide a little more detail (at least 8 characters)";
    }
    return null;
  }

  Future<void> sendFeedbackEmail() async {
    if (!formKey.currentState!.validate()) {
      AppHaptics.errorVibrate();
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isSending.value = true;
    AppHaptics.mediumTap();

    final typeLabel = selectedType.value.label;
    final description = descriptionController.text.trim();

    final String subject = "[LinkMate - $typeLabel] User Feedback";
    final String body =
        "Feedback Type: $typeLabel\n"
        "App: LinkMate (v1.0.0)\n"
        "----------------------------------------\n\n"
        "$description\n\n"
        "----------------------------------------";

    // Encode with %20 instead of '+' so Gmail & Apple Mail format spaces cleanly
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: _encodeQueryParameters({
        'subject': subject,
        'body': body,
      }),
    );

    try {
      final bool launched = await launchUrl(
        emailLaunchUri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        descriptionController.clear();
        Utils.showSuccessToast("Opening email draft...");
      } else {
        await _copyFallback();
      }
    } catch (_) {
      await _copyFallback();
    } finally {
      isSending.value = false;
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _copyFallback() async {
    await Clipboard.setData(const ClipboardData(text: supportEmail));
    Utils.showInAppToast(
      "No Email App Found",
      "Copied $supportEmail to your clipboard!",
    );
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}