import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../Utiles/app_haptic.dart';
import '../../Utiles/utiles.dart';
import '../../data/repositories/link_repository.dart';
import '../../model/link_model.dart';
import '../../screens/addLink/screens/AddLink/addLink.dart';
import '../../screens/addLink/screens/scanner/link_scanner_screen.dart';

class HomeController extends GetxController {
  final LinkRepository repository = LinkRepository();
  final TextEditingController searchController = TextEditingController();

  // Reactive UI state
  final RxString searchQuery = ''.obs;
  final RxString selectedTag = 'All Links'.obs;
  final RxBool isGridView = false.obs;

  // Important Tags filter list matching AddLinkScreen
  final List<String> filterTags = [
    'All Links',
    'Study',
    'Work',
    'Entertainment',
    'AI',
    'Programming',
    'News',
    'Shopping',
    'Recipe',
    'Travel',
    'Finance',
    'Health',
    'Kids',
  ];

  ValueListenable<Box<LinkItem>> get listenableBox => repository.listenableLinks;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
  }

  void selectTag(String tag) {
    AppHaptics.lightTap();
    selectedTag.value = tag;
  }

  void toggleViewMode() {
    AppHaptics.lightTap();
    isGridView.value = !isGridView.value;
  }

  /// Filters links from Hive Box based on Search Query & Selected Tag
  List<LinkItem> getFilteredLinks(Box<LinkItem> box) {
    final query = searchQuery.value.toLowerCase();
    final activeTag = selectedTag.value;

    // Reverse so newest links appear at the top
    final allPublicLinks = box.values
        .where((link) => !link.isPrivate)
        .toList()
        .reversed
        .toList();

    return allPublicLinks.where((link) {
      // 1. Tag Filter (Checks both link.tags and link.category for convenience)
      final matchesTag = activeTag == 'All Links' ||
          link.tags.any((t) => t.toLowerCase() == activeTag.toLowerCase()) ||
          link.category!.toLowerCase() == activeTag.toLowerCase();

      if (!matchesTag) return false;

      // 2. Search Filter
      if (query.isEmpty) return true;

      final inUrl = link.url.toLowerCase().contains(query);
      final inDesc = (link.description ?? '').toLowerCase().contains(query);
      final inMetaTitle = (link.metaTitle ?? '').toLowerCase().contains(query);
      final inMetaDesc = (link.metaDescription ?? '').toLowerCase().contains(query);
      final inCategory = link.category!.toLowerCase().contains(query);
      final inTags = link.tags.any((t) => t.toLowerCase().contains(query));

      return inUrl || inDesc || inMetaTitle || inMetaDesc || inCategory || inTags;
    }).toList();
  }

  // --- Card & BottomSheet Actions ---

  Future<void> toggleFavourite(LinkItem link) async {
    AppHaptics.lightTap();
    await repository.toggleFavourite(link);
  }

  Future<void> copyLink(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    AppHaptics.lightTap();
    Utils.showInAppToast("Copied", "Link copied to clipboard!");
  }

  Future<void> shareLinkNative(LinkItem link) async {
    AppHaptics.lightTap();
    await Share.share(
      link.url,
      subject: link.displayDescription,
    );
  }

  Future<void> deleteLink(LinkItem link) async {
    AppHaptics.mediumTap();
    await repository.deleteLinkObject(link);
    Utils.showSuccessToast("Link deleted from LinkVault");
  }

  /// Top AppBar QR Scanner -> Scans QR and opens AddLinkScreen pre-filled
  Future<void> openTopScanner() async {
    final result = await Get.to(() => const ScanLinkScreen());
    if (result != null && result is String) {
      Get.to(() => AddLinkScreen(initialSharedUrl: result));
    }
  }

  /// Placeholder for Export CSV button
  void onExportPressed() {
    AppHaptics.lightTap();
    // Will be implemented later as requested
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}