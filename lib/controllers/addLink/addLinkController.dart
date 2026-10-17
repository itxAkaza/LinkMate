import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';

import '../../Utiles/app_haptic.dart';
import '../../Utiles/linkUtils.dart';
import '../../Utiles/utiles.dart';
import '../../data/repositories/link_repository.dart';
import '../../model/link_model.dart';
import '../../main.dart';
import '../../screens/addLink/screens/scanner/link_scanner_screen.dart';

class AddLinkViewModel extends GetxController {
  final LinkRepository _repository = LinkRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController urlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController newCategoryController = TextEditingController();
  final TextEditingController customTagController = TextEditingController();

  // --- Reactive State ---
  RxString selectedCategory = 'Articles'.obs;
  RxBool isReminderEnabled = false.obs;
  RxBool isPrivate = false.obs;
  RxString urlText = ''.obs;

  Rx<DateTime> reminderDateTime = DateTime.now().add(const Duration(hours: 1)).obs;

  RxList<String> selectedTags = <String>[].obs;
  RxList<String> categories = <String>[].obs;
  RxList<String> suggestedTags = <String>[
    'Study', 'Work', 'Entertainment', 'Kids', 'AI', 'Programming', 'News', 'Shopping', 'Recipe', 'Travel', 'Finance', 'Health'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    urlController.addListener(() {
      urlText.value = urlController.text;
    });
    _initCategories();
    checkClipboard();
  }

  // --- Category Persistence via Repository ---
  void _initCategories() {
    categories.assignAll(_repository.getCategories());
    if (categories.isNotEmpty) {
      selectedCategory.value = categories.first;
    }
  }

  void addNewCategory(String newCategory) {
    final cleanCategory = newCategory.trim();
    if (cleanCategory.isEmpty) {
      Utils.showErrorToast("Category name cannot be empty");
      return;
    }

    final existingIndex = categories.indexWhere(
          (c) => c.toLowerCase() == cleanCategory.toLowerCase(),
    );

    if (existingIndex == -1) {
      categories.insert(0, cleanCategory);
      _repository.saveCategories(categories.toList());
      selectedCategory.value = cleanCategory;
    } else {
      selectedCategory.value = categories[existingIndex];
    }

    newCategoryController.clear();
  }

  // --- Clipboard & QR Scanner ---
  Future<void> checkClipboard() async {
    if (urlController.text.trim().isNotEmpty) return;
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text;

    if (text != null && text.isNotEmpty) {
      final detectedUrl = LinkUtils.extractUrl(text);
      if (detectedUrl != null && LinkUtils.isValidUrl(detectedUrl)) {
        populateLink(detectedUrl);
        Utils.showInAppToast("Clipboard Detected", "Auto-filled link from your clipboard!");
      }
    }
  }

  Future<void> openScanner() async {
    final result = await Get.to(() => const ScanLinkScreen());
    if (result != null && result is String) {
      populateLink(result);
      Utils.showInAppToast("QR Scanned", "Link captured successfully!");
    }
  }

  // Clean & dynamic — no hardcoded if/else chains!
  void populateLink(String rawUrl) {
    final cleanUrl = LinkUtils.normalizeUrl(rawUrl);
    urlController.text = cleanUrl;
    final detectedCategory = LinkUtils.detectCategory(cleanUrl);

    if (categories.contains(detectedCategory)) {
      selectedCategory.value = detectedCategory;
    }
  }

  // --- Board DateTime Picker (Fixed Dark Mode / Invisible Numbers) ---
  Future<void> pickReminderDateTime(BuildContext context) async {
    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: reminderDateTime.value.isBefore(DateTime.now())
          ? DateTime.now().add(const Duration(minutes: 15))
          : reminderDateTime.value,
      minimumDate: DateTime.now(),
      maximumDate: DateTime(2035),
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages.en(),
        startDayOfWeek: DateTime.monday,
        pickerFormat: PickerFormat.dmy,
        // Explicit colors so System Dark Mode never turns unselected digits white!
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFF5F5F7), // Soft grey wheel highlight
        textColor: const Color(0xFF101828),       // Dark black digits on scroll wheel
        activeColor: const Color(0xFF2B7FFF),     // AppColors.iconBlue
        activeTextColor: Colors.white,
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );

    if (result != null) {
      HapticFeedback.selectionClick();
      reminderDateTime.value = result;
    }
  }

  // --- Stronger Haptics for Tags & Save ---
  void toggleTag(String tag) {
    AppHaptics.lightTap(); // Uses Android VIBRATE permission directly
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  void addCustomTag() {
    final rawTag = customTagController.text.trim();
    if (rawTag.isEmpty) return;

    if (!suggestedTags.any((t) => t.toLowerCase() == rawTag.toLowerCase())) {
      suggestedTags.insert(0, rawTag);
    }
    if (!selectedTags.contains(rawTag)) {
      selectedTags.add(rawTag);
    }
    customTagController.clear();
    AppHaptics.lightTap();
  }

  void toggleReminder(bool value, BuildContext context) {
    isReminderEnabled.value = value;
    if (value) {
      pickReminderDateTime(context);
    }
  }


  // --- Validation & Save ---
  String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter a link URL";
    }
    if (!LinkUtils.isValidUrl(value)) {
      return "Please enter a valid web link (e.g., https://google.com)";
    }
    return null;
  }

  Future<void> saveLink() async {
    if (!formKey.currentState!.validate()) {
      AppHaptics.errorVibrate();
      return;
    }

    final String url = LinkUtils.normalizeUrl(urlController.text);
    final String desc = descriptionController.text.trim();

    if (_repository.isDuplicate(url)) {
      Utils.showErrorToast("This link is already saved in LinkVault!");
      AppHaptics.errorVibrate();
      return;
    }

    if (isReminderEnabled.value && reminderDateTime.value.isBefore(DateTime.now())) {
      Utils.showErrorToast("Please select a future time for the reminder.");
      AppHaptics.errorVibrate();
      return;
    }

    final newLink = LinkItem(
      url: url,
      description: desc.isEmpty ? null : desc,
      category: selectedCategory.value,
      tags: selectedTags.toList(),
      reminder: isReminderEnabled.value ? reminderDateTime.value : null,
      isPrivate: isPrivate.value,
      isFavourite: false,
      status: 'pending',
    );

    final hiveKey = await _repository.saveLink(newLink);

    if (isReminderEnabled.value) {
      await notificationService.showScheduleNotification(
        id: hiveKey,
        title: "LinkVault Reminder (${selectedCategory.value})",
        body: desc.isNotEmpty ? desc : "Time to revisit: $url",
        scheduledDate: reminderDateTime.value,
      );
    }

    AppHaptics.mediumTap();
    Utils.showSuccessToast("Link saved successfully!");

    urlController.clear();
    descriptionController.clear();
    selectedTags.clear();
    isReminderEnabled.value = false;
    isPrivate.value = false;

    Get.back();
  }

  @override
  void onClose() {
    urlController.dispose();
    descriptionController.dispose();
    newCategoryController.dispose();
    customTagController.dispose();
    super.onClose();
  }
}