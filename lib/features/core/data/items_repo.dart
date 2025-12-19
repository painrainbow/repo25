import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/item.dart';
import 'firebase_refs.dart';

enum ItemsSort { titleAsc, yearDesc, ratingDesc, createdDesc }

class ItemsQuery {
  final String search;
  final String? shelfId;
  final ItemType? type;
  final String? tag;
  final ItemsSort sort;

  const ItemsQuery({
    this.search = '',
    this.shelfId,
    this.type,
    this.tag,
    this.sort = ItemsSort.createdDesc,
  });

  ItemsQuery copyWith({
    String? search,
    String? shelfId,
    ItemType? type,
    String? tag,
    ItemsSort? sort,
  }) {
    return ItemsQuery(
      search: search ?? this.search,
      shelfId: shelfId ?? this.shelfId,
      type: type ?? this.type,
      tag: tag ?? this.tag,
      sort: sort ?? this.sort,
    );
  }
}

class ItemsRepo {
  Stream<List<CollectionItem>> watchItems(ItemsQuery q) {
    Query<Map<String, dynamic>> query = itemsRef();

    if (q.shelfId != null && q.shelfId!.isNotEmpty) {
      query = query.where('shelfId', isEqualTo: q.shelfId);
    }
    if (q.type != null) {
      query = query.where('type', isEqualTo: q.type!.name);
    }
    if (q.tag != null && q.tag!.isNotEmpty) {
      query = query.where('tags', arrayContains: q.tag);
    }

    switch (q.sort) {
      case ItemsSort.titleAsc:
        query = query.orderBy('title');
        break;
      case ItemsSort.yearDesc:
        query = query.orderBy('year', descending: true);
        break;
      case ItemsSort.ratingDesc:
        query = query.orderBy('rating', descending: true);
        break;
      case ItemsSort.createdDesc:
        query = query.orderBy('createdAt', descending: true);
        break;
    }

    return query.snapshots().map((s) {
      final list = s.docs.map((d) => CollectionItem.fromMap(d.id, d.data())).toList();
      if (q.search.trim().isEmpty) return list;
      final needle = q.search.toLowerCase();
      return list
          .where((it) =>
              it.title.toLowerCase().contains(needle) ||
              it.author.toLowerCase().contains(needle))
          .toList();
    });
  }

  Future<String?> uploadCover(String itemId, File file) async {
    final ref = FirebaseStorage.instance.ref().child('covers/$uid/$itemId.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<String> createItem({
    required String title,
    required String author,
    required int year,
    required double rating,
    required List<String> tags,
    required String shelfId,
    required ItemType type,
    String? coverUrl,
  }) async {
    final doc = itemsRef().doc();
    await doc.set({
      'title': title,
      'author': author,
      'year': year,
      'rating': rating,
      'tags': tags,
      'shelfId': shelfId,
      'type': type.name,
      'coverUrl': coverUrl,
      'createdAt': DateTime.now().toUtc(),
      'updatedAt': DateTime.now().toUtc(),
    });
    return doc.id;
  }

  Future<void> updateItem(String id, Map<String, dynamic> patch) async {
    patch['updatedAt'] = DateTime.now().toUtc();
    await itemsRef().doc(id).update(patch);
  }

  Future<void> deleteItem(String id) async {
    await itemsRef().doc(id).delete();
  }
}
