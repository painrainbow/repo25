import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../core/models/shelf.dart';
import 'widgets/shelf_edit_dialog.dart';

class ShelvesPage extends ConsumerWidget {
  const ShelvesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(shelvesRepoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Полки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final name = await showShelfEditDialog(context, title: 'Новая полка');
              if (name == null) return;
              await repo.addShelf(name);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Shelf>>(
        stream: repo.watchShelves(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('Ошибка: ${snap.error}'));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final shelves = snap.data!;
          if (shelves.isEmpty) {
            return const Center(child: Text('Полок пока нет. Нажмите + чтобы добавить.'));
          }
          return ListView.separated(
            itemCount: shelves.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final s = shelves[i];
              return ListTile(
                title: Text(s.name),
                leading: const Icon(Icons.bookmark),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'rename') {
                      final name = await showShelfEditDialog(
                        context,
                        title: 'Переименовать полку',
                        initial: s.name,
                      );
                      if (name == null) return;
                      await repo.renameShelf(s.id, name);
                    } else if (v == 'delete') {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Удалить полку?'),
                          content: const Text('Полка будет удалена. Предметы с этой полкой останутся, но shelfId станет некорректным.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
                            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Удалить')),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await repo.deleteShelf(s.id);
                      }
                    }
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 'rename', child: Text('Переименовать')),
                    PopupMenuItem(value: 'delete', child: Text('Удалить')),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
