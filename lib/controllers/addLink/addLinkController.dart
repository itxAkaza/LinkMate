import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

import '../../Utiles/app_haptic.dart';
import '../../Utiles/linkUtils.dart';
import '../../Utiles/utiles.dart';
import '../../data/repositories/link_repository.dart';
import '../../model/link_model.dart';
import '../../main.dart';
import '../../screens/addLink/screens/scanner/link_scanner_screen.dart';
import '../../screens/privateVault/vault_pin_screen.dart';
import '../home/homeController.dart';
import '../navController/navigationController.dart';

class AddLinkViewModel extends GetxController {
  final LinkRepository _repository = LinkRepository();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController urlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController newCategoryController = TextEditingController();
  final TextEditingController customTagController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // --- Edit Mode Reference ---
  LinkItem? editingLink;
  RxBool isEditMode = false.obs;

  // --- Reactive State ---
  RxString selectedCategory = 'Articles'.obs;
  RxBool isReminderEnabled = false.obs;
  RxBool isPrivate = false.obs;
  RxString urlText = ''.obs;
  RxBool isSaving = false.obs;

  Rx<DateTime> reminderDateTime = DateTime.now().add(const Duration(hours: 1)).obs;

  RxList<String> selectedTags = <String>[].obs;
  RxList<String> categories = <String>[].obs;
  RxList<String> suggestedTags = <String>[
    'Study',
    'Work',
    'Entertainment',
    'Kids',
    'AI',
    'Programming',
    'News',
    'Shopping',
    'Recipe',
    'Travel',
    'Finance',
    'Health'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    urlController.addListener(() {
      urlText.value = urlController.text;
    });
    _initCategories();
  }

  // --- Category Persistence via Repository ---
  void _initCategories() {
    categories.assignAll(_repository.getCategories());
    if (categories.isNotEmpty && !categories.contains(selectedCategory.value)) {
      selectedCategory.value = categories.first;
    }
  }

  /// Configures screen for either Add Mode or Edit Mode
  void configureMode({LinkItem? linkToEdit, String? initialSharedUrl}) {
    _initCategories();

    if (linkToEdit != null) {
      // --- EDIT MODE ---
      editingLink = linkToEdit;
      isEditMode.value = true;

      urlController.text = linkToEdit.url;
      descriptionController.text = linkToEdit.description ?? '';

      if (!categories.contains(linkToEdit.category!)) {
        categories.insert(0, linkToEdit.category!);
      }
      selectedCategory.value = linkToEdit.category!;

      selectedTags.assignAll(linkToEdit.tags);
      for (final tag in linkToEdit.tags) {
        if (!suggestedTags.any((t) => t.toLowerCase() == tag.toLowerCase())) {
          suggestedTags.insert(0, tag);
        }
      }

      isPrivate.value = linkToEdit.isPrivate;
      if (linkToEdit.reminder != null) {
        isReminderEnabled.value = true;
        reminderDateTime.value = linkToEdit.reminder!;
      } else {
        isReminderEnabled.value = false;
      }
    } else {
      // --- ADD MODE ---
      _resetFields();

      if (initialSharedUrl != null && initialSharedUrl.trim().isNotEmpty) {
        populateLink(initialSharedUrl);
      } else {
        checkClipboard();
      }
    }
  }

  void _resetFields() {
    editingLink = null;
    isEditMode.value = false;
    urlController.clear();
    descriptionController.clear();
    selectedTags.clear();
    isReminderEnabled.value = false;
    isPrivate.value = false;
    reminderDateTime.value = DateTime.now().add(const Duration(hours: 1));
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
    if (isEditMode.value || urlController.text.trim().isNotEmpty) return;
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

  void populateLink(String rawUrl) {
    final cleanUrl = LinkUtils.normalizeUrl(rawUrl);
    urlController.text = cleanUrl;
    final detectedCategory = LinkUtils.detectCategory(cleanUrl);

    if (categories.contains(detectedCategory)) {
      selectedCategory.value = detectedCategory;
    }
  }

  // --- Updated Board DateTime Picker ---
  Future<void> pickReminderDateTime(BuildContext context) async {
    final initial = reminderDateTime.value.isBefore(DateTime.now())
        ? DateTime.now().add(const Duration(minutes: 15))
        : reminderDateTime.value;

    reminderDateTime.value = initial;

    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: initial,
      minimumDate: DateTime.now(),
      maximumDate: DateTime(2035),
      onChanged: (DateTime val) {
        reminderDateTime.value = val;
      },
      options: const BoardDateTimeOptions(
        languages: BoardPickerLanguages.en(),
        startDayOfWeek: DateTime.monday,
        pickerFormat: PickerFormat.dmy,
        boardTitle: 'Select Date (DD/MM/YYYY) & Time',
        boardTitleTextStyle: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2B7FFF),
        ),
        showDateButton: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFFF5F5F7),
        textColor: Color(0xFF101828),
        activeColor: Color(0xFF2B7FFF),
        activeTextColor: Colors.white,
        backgroundDecoration: BoxDecoration(
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
    AppHaptics.lightTap();
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

  Future<void> togglePrivateVault(bool value) async {
    AppHaptics.lightTap();
    if (!value) {
      isPrivate.value = false;
      return;
    }

    if (_repository.hasVaultPin()) {
      isPrivate.value = true;
    } else {
      final bool? pinCreated = await Get.to<bool>(
            () => const VaultPinScreen(mode: PinScreenMode.setup),
      );
      if (pinCreated == true && _repository.hasVaultPin()) {
        isPrivate.value = true;
      } else {
        isPrivate.value = false;
      }
    }
  }

  // --- Validation & Save / Update ---
  String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      Utils.showErrorToast("Please enter a link URL");
      return "Please enter a link URL";
    }
    if (!LinkUtils.isValidUrl(value)) {
      Utils.showErrorToast("Please enter a valid link");
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

    // Check duplicate (ignores current link if editing)
    if (_repository.isDuplicate(url, ignoreKey: editingLink?.key)) {
      Utils.showErrorToast("This link is already saved in LinkMate!");
      AppHaptics.errorVibrate();
      return;
    }

    if (isReminderEnabled.value && reminderDateTime.value.isBefore(DateTime.now())) {
      Utils.showErrorToast("Please select a future time for the reminder.");
      AppHaptics.errorVibrate();
      return;
    }

    isSaving.value = true;
    final bool wasEditing = isEditMode.value;

    try {
      String? fetchedTitle = editingLink?.metaTitle;
      String? fetchedDesc = editingLink?.metaDescription;
      String? fetchedImage = editingLink?.metaImage;

      final bool shouldFetchMeta = editingLink == null ||
          LinkUtils.normalizeUrl(editingLink!.url).toLowerCase() != url.toLowerCase();

      if (shouldFetchMeta) {
        try {
          final data = await MetadataFetch.extract(url).timeout(
            const Duration(seconds: 4),
          );
          if (data != null) {
            fetchedTitle = data.title;
            fetchedDesc = data.description;
            fetchedImage = data.image;
          }
        } catch (e) {
          debugPrint("Metadata fetch failed or timed out, saving without it: $e");
        }
      }

      late final int notificationId;

      if (isEditMode.value && editingLink != null) {
        // --- UPDATE EXISTING HIVE OBJECT ---
        editingLink!
          ..url = url
          ..description = desc.isEmpty ? null : desc
          ..category = selectedCategory.value
          ..tags = selectedTags.toList()
          ..reminder = isReminderEnabled.value ? reminderDateTime.value : null
          ..isPrivate = isPrivate.value
          ..metaTitle = fetchedTitle
          ..metaDescription = fetchedDesc
          ..metaImage = fetchedImage;

        await _repository.updateLink(editingLink!);
        notificationId = (editingLink!.key is int) ? editingLink!.key as int : editingLink.hashCode;
      } else {
        // --- SAVE NEW HIVE OBJECT ---
        final newLink = LinkItem(
          url: url,
          description: desc.isEmpty ? null : desc,
          category: selectedCategory.value,
          tags: selectedTags.toList(),
          reminder: isReminderEnabled.value ? reminderDateTime.value : null,
          isPrivate: isPrivate.value,
          isFavourite: false,
          status: 'pending',
          metaTitle: fetchedTitle,
          metaDescription: fetchedDesc,
          metaImage: fetchedImage,
        );

        notificationId = await _repository.saveLink(newLink);
      }

      // --- SCHEDULE OR CANCEL NOTIFICATION ---
      if (isReminderEnabled.value && _repository.areNotificationsEnabled()) {
        await notificationService.initNotification(true);
        await notificationService.showScheduleNotification(
          id: notificationId,
          title: "LinkMate Reminder (${selectedCategory.value})",
          body: desc.isNotEmpty ? desc : (fetchedTitle ?? "Time to revisit: $url"),
          scheduledDate: reminderDateTime.value,
        );
      } else if (!isReminderEnabled.value && wasEditing) {
        await notificationService.cancelNotification(notificationId);
      }

      AppHaptics.mediumTap();
      _resetFields();

      // Force HomeController to refresh its list immediately
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().refreshLinks();
      }

      // Close any active snackbar before popping route
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }

      // Navigate back properly whether opened as a pushed route or via the Bottom Navigation Bar
      if (Get.context != null && Navigator.of(Get.context!).canPop()) {
        Get.back(result: true);
      } else if (Get.isRegistered<MainHomeViewModel>()) {
        Get.find<MainHomeViewModel>().setIndex(0);
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        Utils.showInAppToast(
          "LinkMate",
          wasEditing ? "Link updated successfully!" : "Link saved successfully!",
        );
      });
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    urlController.dispose();
    descriptionController.dispose();
    newCategoryController.dispose();
    customTagController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}