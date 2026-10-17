import 'package:hive_ce/hive_ce.dart';
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

  // --- Link Operations ---

  // 1. Check for duplicates (Normalized)
  bool isDuplicate(String url) {
    final normalizedInput = LinkUtils.normalizeUrl(url).toLowerCase();
    return _box.values.any(
          (item) => LinkUtils.normalizeUrl(item.url).toLowerCase() == normalizedInput,
    );
  }

  // 2. Save a new link
  Future<int> saveLink(LinkItem link) async {
    return await _box.add(link);
  }

  // 3. Get all links
  List<LinkItem> getAllLinks() {
    return _box.values.toList();
  }

  // 4. Delete link
  Future<void> deleteLink(int key) async {
    await _box.delete(key);
  }

  // --- Category Operations (Moved out of ViewModel!) ---

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