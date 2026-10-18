import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../Utiles/app_haptic.dart';
import '../../Utiles/utiles.dart';
import '../../data/repositories/link_repository.dart';
import '../../main.dart';
import '../../model/link_model.dart';

enum ReminderFilter { all, done, today, overdue }

class ReminderController extends GetxController {
  final LinkRepository repository = LinkRepository();
  final TextEditingController searchController = TextEditingController();

  final RxString searchQuery = ''.obs;
  final Rx<ReminderFilter> activeFilter = ReminderFilter.all.obs;

  ValueListenable<Box<LinkItem>> get listenableBox => repository.listenableLinks;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
  }

  void setFilter(ReminderFilter filter) {
    AppHaptics.lightTap();
    activeFilter.value = filter;
  }

  // --- Date & Status Helpers ---
  bool isDone(LinkItem link) => link.status == 'done';

  bool isOverdue(LinkItem link) {
    if (link.reminder == null || isDone(link)) return false;
    return link.reminder!.isBefore(DateTime.now());
  }

  bool isDueToday(LinkItem link) {
    if (link.reminder == null || isDone(link)) return false;
    final now = DateTime.now();
    final r = link.reminder!;
    return r.year == now.year &&
        r.month == now.month &&
        r.day == now.day &&
        !r.isBefore(now);
  }

  List<LinkItem> _getAllReminderLinks(Box<LinkItem> box) {
    return box.values
        .where((link) => !link.isPrivate && link.reminder != null)
        .toList()
      ..sort((a, b) => a.reminder!.compareTo(b.reminder!));
  }

  // --- Live Counts for the 4 Top Summary Cards ---
  int getAllCount(Box<LinkItem> box) =>
      _getAllReminderLinks(box).where((l) => !isDone(l)).length;

  int getDoneCount(Box<LinkItem> box) =>
      _getAllReminderLinks(box).where((l) => isDone(l)).length;

  int getTodayCount(Box<LinkItem> box) =>
      _getAllReminderLinks(box).where((l) => isDueToday(l)).length;

  int getOverdueCount(Box<LinkItem> box) =>
      _getAllReminderLinks(box).where((l) => isOverdue(l)).length;

  // --- Filtered List Based on Selected Top Card & Search ---
  List<LinkItem> getFilteredReminders(Box<LinkItem> box) {
    final all = _getAllReminderLinks(box);
    final query = searchQuery.value.toLowerCase();

    final byTab = all.where((link) {
      switch (activeFilter.value) {
        case ReminderFilter.all:
        // Shows active reminders; once marked as read (done), it leaves this screen!
          return !isDone(link);
        case ReminderFilter.done:
          return isDone(link);
        case ReminderFilter.today:
          return isDueToday(link);
        case ReminderFilter.overdue:
          return isOverdue(link);
      }
    }).toList();

    if (query.isEmpty) return byTab;

    return byTab.where((link) {
      final inUrl = link.url.toLowerCase().contains(query);
      final inDesc = link.displayDescription.toLowerCase().contains(query);
      final inCat = (link.category ?? '').toLowerCase().contains(query);
      return inUrl || inDesc || inCat;
    }).toList();
  }

  String getSectionHeaderTitle() {
    switch (activeFilter.value) {
      case ReminderFilter.all:
        return "All Reminders";
      case ReminderFilter.done:
        return "Completed Reminders";
      case ReminderFilter.today:
        return "Today's Reminders";
      case ReminderFilter.overdue:
        return "Overdue Reminders";
    }
  }

  String formatReminderTime(DateTime dt) {
    final now = DateTime.now();
    final isSameDay = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final timeStr = DateFormat('h:mm a').format(dt);

    if (isSameDay) {
      return "Today, $timeStr";
    }
    return "${DateFormat('d MMM').format(dt)}, $timeStr";
  }

  /// Marks reminder as read/done when tapping the bell or radio circle
  Future<void> markAsRead(LinkItem link) async {
    AppHaptics.mediumTap();
    final wasDone = isDone(link);
    await repository.markReminderDone(link);

    // Cancel scheduled notification if marked done
    if (!wasDone && link.key is int) {
      try {
        await notificationService.cancelNotification(link.key as int);
      } catch (_) {}
    }

    Utils.showSuccessToast(
      !wasDone ? "Reminder marked as read!" : "Moved back to active reminders",
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}