enum ItemType { book, comic, vinyl, boardgame }

class CollectionItem {
  final String id;
  final String title;
  final String author;
  final int year;
  final String? coverUrl;
  final double rating;
  final List<String> tags;
  final String shelfId;
  final ItemType type;

  const CollectionItem({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.coverUrl,
    required this.rating,
    required this.tags,
    required this.shelfId,
    required this.type,
  });

  static CollectionItem fromMap(String id, Map<String, dynamic> data) => CollectionItem(
        id: id,
        title: (data['title'] ?? '') as String,
        author: (data['author'] ?? '') as String,
        year: (data['year'] ?? 0) as int,
        coverUrl: data['coverUrl'] as String?,
        rating: ((data['rating'] ?? 0) as num).toDouble(),
        tags: List<String>.from((data['tags'] ?? []) as List),
        shelfId: (data['shelfId'] ?? '') as String,
        type: ItemType.values.firstWhere(
          (e) => e.name == (data['type'] ?? 'book'),
          orElse: () => ItemType.book,
        ),
      );
}
