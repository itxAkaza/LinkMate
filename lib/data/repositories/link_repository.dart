import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../Utiles/linkUtils.dart';
import '../../model/link_model.dart';

class LinkRepository {
  static const String boxName = 'links_box';
  static const String categoriesBoxName = 'categories_box';
  static const String userCategoriesKey = 'user_categories';
  static const String settingsBoxName = 'settings_box';

  static const List<String> defaultCategories = [
    'Articles',
    'Videos',
    'Work',
    'Bookmarks',
    'Study',
    'Social',
    'Web',
    'Sports',
  ];

  Box<LinkItem> get _box => Hive.box<LinkItem>(boxName);
  Box<List<String>> get _categoriesBox => Hive.box<List<String>>(categoriesBoxName);
  Box get _settingsBox => Hive.box(settingsBoxName);
  /// Expose ValueListenables so Home, Reminders, Favorites, and Category screens auto-update
  ValueListenable<Box<LinkItem>> get listenableLinks => _box.listenable();
  ValueListenable<Box<List<String>>> get listenableCategories => _categoriesBox.listenable();

  // --- PERSISTENT GRID / LIST VIEW STATE PER PAGE ---
  bool getGridViewState(String pageKey) {
    return _settingsBox.get('${pageKey}_is_grid', defaultValue: false) as bool;
  }

  Future<void> saveGridViewState(String pageKey, bool isGrid) async {
    await _settingsBox.put('${pageKey}_is_grid', isGrid);
  }

  bool isDuplicate(String url, {dynamic ignoreKey}) {
    final normalizedInput = LinkUtils.normalizeUrl(url).toLowerCase();
    return _box.values.any((item) {
      if (ignoreKey != null && item.key == ignoreKey) return false;
      return LinkUtils.normalizeUrl(item.url).toLowerCase() == normalizedInput;
    });
  }

  Future<int> saveLink(LinkItem link) async {
    return await _box.add(link);
  }

  Future<void> updateLink(LinkItem link) async {
    await link.save();
  }

  Future<void> toggleFavourite(LinkItem link) async {
    link.isFavourite = !link.isFavourite;
    await link.save();
  }

  /// Marks a reminder as read/done so it moves out of active reminders into Done
  Future<void> markReminderDone(LinkItem link) async {
    link.status = link.status == 'done' ? 'pending' : 'done';
    await link.save();
  }

  Future<void> deleteLinkObject(LinkItem link) async {
    await link.delete();
  }

  List<String> getCategories() {
    final saved = _categoriesBox.get(userCategoriesKey);
    if (saved == null || saved.isEmpty) {
      _categoriesBox.put(userCategoriesKey, defaultCategories);
      return List<String>.from(defaultCategories);
    }
    return List<String>.from(saved);
  }

  Future<void> saveCategories(List<String> categories) async {
    await _categoriesBox.put(userCategoriesKey, categories);
  }
}