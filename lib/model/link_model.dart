class LinkItem {

  final String url; // Added url since it is essential for a link app
  final String? description;
  final String? category;
  final List<String> tags;
  final DateTime? reminder;

  // --- New Fields ---
  final bool isPrivate;
  final String status; // e.g., 'pending', 'today', 'watched'
  final bool isFavourite;

  LinkItem({

    required this.url,
    this.description,
    this.category,
    this.tags = const [],
    this.reminder,
    this.isPrivate = false, // Defaults to false
    this.status = 'pending', // Defaults to 'pending'
    this.isFavourite = false, // Defaults to false
  });
}