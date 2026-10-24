import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../resources/assets/image_assets.dart';
import 'onBoardingTemplate.dart';

class OnBoarding1 extends StatelessWidget {
  const OnBoarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnBoardingPageTemplate(
      lottieAsset: ImageAssets.on1,
      badgeIcon: LucideIcons.share2,
      badgeText: "SHARE FROM ANY APP",
      title: "Tired of Scattered Links?",
      description:
      "Save links in one tap directly from YouTube, Chrome, Instagram, or any app. LinkMate auto-fetches titles, previews, and categories so nothing ever gets lost.",
    );
  }
}

class OnBoarding2 extends StatelessWidget {
  const OnBoarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnBoardingPageTemplate(
      lottieAsset: ImageAssets.on2,
      badgeIcon: LucideIcons.bellRing,
      badgeText: "SMART REMINDERS & TAGS",
      title: "Never Forget What You Saved",
      description:
      "Found an awesome UI design to try later or an article you didn't have time to read? Schedule a smart reminder and organize with custom categories & tags.",
    );
  }
}

class OnBoarding3 extends StatelessWidget {
  const OnBoarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnBoardingPageTemplate(
      lottieAsset: ImageAssets.on3,
      badgeIcon: LucideIcons.shieldCheck,
      badgeText: "PRIVATE VAULT & OFFLINE",
      title: "Lock Your Private Links",
      description:
      "Keep confidential links hidden behind a 4-digit PIN inside your Private Vault. 100% offline-first with instant QR sharing and CSV/Excel backups.",
    );
  }
}

