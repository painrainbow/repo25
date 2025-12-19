import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shelf.dart';
import 'firebase_refs.dart';

class ShelvesRepo {
  Stream<List<Shelf>> watchShelves() {
    return shelvesRef()
        .orderBy('sortOrder')
        .snapshots()
        .map((s) => s.docs.map((d) => Shelf.fromMap(d.id, d.data())).toList());
  }

  Future<void> createDefaultShelvesIfEmpty() async {
    final snap = await shelvesRef().limit(1).get();
    if (snap.docs.isNotEmpty) return;

    final batch = FirebaseFirestore.instance.batch();
    final defaults = [
      {'name': 'Прочитано', 'sortOrder': 1},
      {'name': 'Хочу прочитать', 'sortOrder': 2},
      {'name': 'Любимые', 'sortOrder': 3},
    ];
    for (final d in defaults) {
      final doc = shelvesRef().doc();
      batch.set(doc, {
        ...d,
        'createdAt': DateTime.now().toUtc(),
      });
    }
    await batch.commit();
  }

  Future<void> addShelf(String name) async {
    await shelvesRef().add({
      'name': name,
      'sortOrder': DateTime.now().millisecondsSinceEpoch,
      'createdAt': DateTime.now().toUtc(),
    });
  }

  Future<void> renameShelf(String shelfId, String name) async {
    await shelvesRef().doc(shelfId).update({'name': name});
  }

  Future<void> deleteShelf(String shelfId) async {
    await shelvesRef().doc(shelfId).delete();
  }
}
