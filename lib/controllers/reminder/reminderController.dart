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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isLinkDone(LinkItem link) {
    return link.status == 'done' || link.status == 'watched';
  }

  bool isLinkOverdue(LinkItem link) {
    if (link.reminder == null || isLinkDone(link)) return false;
    return link.reminder!.isBefore(DateTime.now());
  }

  bool isLinkDueToday(LinkItem link) {
    if (link.reminder == null || isLinkDone(link)) return false;
    final now = DateTime.now();
    return _isSameDay(link.reminder!, now) && !link.reminder!.isBefore(now);
  }

  Map<ReminderFilter, int> getCounts(Box<LinkItem> box) {
    final allWithReminders = box.values
        .where((l) => !l.isPrivate && l.reminder != null)
        .toList();

    int allActiveCount = 0;
    int doneCount = 0;
    int todayCount = 0;
    int overdueCount = 0;

    final now = DateTime.now();

    for (final link in allWithReminders) {
      if (isLinkDone(link)) {
        doneCount++;
      } else {
        allActiveCount++;
        if (link.reminder!.isBefore(now)) {
          overdueCount++;
        } else if (_isSameDay(link.reminder!, now)) {
          todayCount++;
        }
      }
    }

    return {
      ReminderFilter.all: allActiveCount,
      ReminderFilter.done: doneCount,
      ReminderFilter.today: todayCount,
      ReminderFilter.overdue: overdueCount,
    };
  }

  List<LinkItem> getFilteredReminders(Box<LinkItem> box) {
    final query = searchQuery.value.toLowerCase();
    final filter = activeFilter.value;

    final items = box.values
        .where((l) => !l.isPrivate && l.reminder != null)
        .toList();

    // Sort by closest reminder time
    items.sort((a, b) => a.reminder!.compareTo(b.reminder!));

    return items.where((link) {
      bool matchesFilter = false;
      switch (filter) {
        case ReminderFilter.all:
          matchesFilter = !isLinkDone(link);
          break;
        case ReminderFilter.done:
          matchesFilter = isLinkDone(link);
          break;
        case ReminderFilter.today:
          matchesFilter = isLinkDueToday(link);
          break;
        case ReminderFilter.overdue:
          matchesFilter = isLinkOverdue(link);
          break;
      }

      if (!matchesFilter) return false;
      if (query.isEmpty) return true;

      return link.displayDescription.toLowerCase().contains(query) ||
          link.url.toLowerCase().contains(query) ||
          (link.category ?? '').toLowerCase().contains(query);
    }).toList();
  }

  /// Marks reminder as read/done when tapping the bell or check circle
  Future<void> markAsRead(LinkItem link) async {
    AppHaptics.mediumTap();
    if (isLinkDone(link)) {
      link.status = 'pending';
      await link.save();
      Utils.showInAppToast("Restored", "Moved back to active reminders");
    } else {
      link.status = 'done';
      await link.save();
      Utils.showSuccessToast("Reminder marked as read!");
    }
  }

  String formatReminderTime(DateTime dt) {
    final now = DateTime.now();
    if (_isSameDay(dt, now)) {
      return "Today, ${DateFormat('h:mm a').format(dt)}";
    }
    return DateFormat('dd MMM, h:mm a').format(dt);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}