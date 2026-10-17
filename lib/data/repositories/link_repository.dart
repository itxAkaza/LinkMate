import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../Utiles/linkUtils.dart';
import '../../model/link_model.dart';

class LinkRepository {
  static const String boxName = 'links_box';
  static const String categoriesBoxName = 'categories_box';
  static const String userCategoriesKey = 'user_categories';

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

  /// Expose ValueListenable so Home Screen auto-updates whenever Hive changes
  ValueListenable<Box<LinkItem>> get listenableLinks => _box.listenable();

  /// Check duplicate URL, optionally ignoring the link currently being edited
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
    await link.save(); // Saves directly via HiveObject reference!
  }

  Future<void> toggleFavourite(LinkItem link) async {
    link.isFavourite = !link.isFavourite;
    await link.save();
  }

  Future<void> deleteLinkObject(LinkItem link) async {
    await link.delete(); // Deletes directly via HiveObject reference!
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