import 'package:hive_ce/hive_ce.dart';

// Look how clean this is! No @HiveType or @HiveField needed anymore.
class LinkItem extends HiveObject {
  String url;
  String? description;
  String? category;
  List<String> tags;
  DateTime? reminder;
  String? metaDescription;
  String? metaTitle;
  String? metaImage;
  bool isPrivate;
  bool isFavourite;
  String status;

  LinkItem({
    this.metaDescription = "link...",
    this.metaTitle,
    this.metaImage,
    required this.url,
    this.description,
    this.category,
    this.tags = const [],
    this.reminder,
    this.isPrivate = false,
    this.status = 'pending',
    this.isFavourite = false,
  });

  String get displayDescription {
    if (description != null && description!.trim().isNotEmpty) {
      return description!.trim();
    }
    if (metaTitle != null && metaTitle!.trim().isNotEmpty) {
      return metaTitle!.trim();
    }
    if (metaDescription != null && metaDescription!.trim().isNotEmpty) {
      return metaDescription!.trim();
    }
    return url;
  }
}