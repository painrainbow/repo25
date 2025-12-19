class Shelf {
  final String id;
  final String name;
  final int sortOrder;

  const Shelf({
    required this.id,
    required this.name,
    required this.sortOrder,
  });

  static Shelf fromMap(String id, Map<String, dynamic> data) => Shelf(
        id: id,
        name: (data['name'] ?? '') as String,
        sortOrder: (data['sortOrder'] ?? 0) as int,
      );
}
