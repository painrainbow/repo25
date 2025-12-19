import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/item.dart';
import '../../core/models/shelf.dart';
import '../../core/providers.dart';
import '../../core/data/items_repo.dart';
import 'item_edit_page.dart';

class ItemsPage extends ConsumerWidget {
  const ItemsPage({super.key});

  String _typeLabel(ItemType? t) {
    if (t == null) return 'Все типы';
    switch (t) {
      case ItemType.book:
        return 'Книги';
      case ItemType.comic:
        return 'Комиксы';
      case ItemType.vinyl:
        return 'Винил';
      case ItemType.boardgame:
        return 'Настолки';
    }
  }

  String _sortLabel(ItemsSort s) {
    switch (s) {
      case ItemsSort.createdDesc:
        return 'Сначала новые';
      case ItemsSort.titleAsc:
        return 'По названию (A→Z)';
      case ItemsSort.yearDesc:
        return 'По году (сначала новые)';
      case ItemsSort.ratingDesc:
        return 'По рейтингу (сначала выше)';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelvesRepo = ref.watch(shelvesRepoProvider);
    final itemsRepo = ref.watch(itemsRepoProvider);
    final q = ref.watch(itemsQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Коллекция'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // reset filters
              ref.read(itemsQueryProvider.notifier).state = const ItemsQuery();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Ensure default shelves exist (first run)
          await shelvesRepo.createDefaultShelvesIfEmpty();
          if (!context.mounted) return;
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemEditPage()));
        },
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Поиск по названию или автору',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => ref.read(itemsQueryProvider.notifier).state = q.copyWith(search: v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: StreamBuilder<List<Shelf>>(
              stream: shelvesRepo.watchShelves(),
              builder: (context, snap) {
                final shelves = snap.data ?? const <Shelf>[];
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Shelf filter
                    DropdownMenu<String?>(
                      initialSelection: q.shelfId,
                      dropdownMenuEntries: [
                        const DropdownMenuEntry(value: null, label: 'Все полки'),
                        ...shelves.map((s) => DropdownMenuEntry(value: s.id, label: s.name)),
                      ],
                      onSelected: (v) => ref.read(itemsQueryProvider.notifier).state = q.copyWith(shelfId: v),
                      label: const Text('Полка'),
                    ),
                    // Type filter
                    DropdownMenu<ItemType?>(
                      initialSelection: q.type,
                      dropdownMenuEntries: [
                        const DropdownMenuEntry(value: null, label: 'Все типы'),
                        ...ItemType.values.map((t) => DropdownMenuEntry(value: t, label: _typeLabel(t))),
                      ],
                      onSelected: (v) => ref.read(itemsQueryProvider.notifier).state = q.copyWith(type: v),
                      label: const Text('Тип'),
                    ),
                    // Sort
                    DropdownMenu<ItemsSort>(
                      initialSelection: q.sort,
                      dropdownMenuEntries: ItemsSort.values
                          .map((s) => DropdownMenuEntry(value: s, label: _sortLabel(s)))
                          .toList(),
                      onSelected: (v) => ref.read(itemsQueryProvider.notifier).state = q.copyWith(sort: v),
                      label: const Text('Сортировка'),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: StreamBuilder<List<CollectionItem>>(
              stream: itemsRepo.watchItems(q),
              builder: (context, snap) {
                if (snap.hasError) return Center(child: Text('Ошибка: ${snap.error}'));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final items = snap.data!;
                if (items.isEmpty) {
                  return const Center(child: Text('Пока пусто. Нажмите "Добавить".'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final it = items[i];
                    return Dismissible(
                      key: ValueKey(it.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Удалить предмет?'),
                            content: Text('«${it.title}» будет удалён без возможности восстановления.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
                              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Удалить')),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) async => await itemsRepo.deleteItem(it.id),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: it.coverUrl == null
                              ? Container(
                                  width: 44,
                                  height: 44,
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: const Icon(Icons.image_not_supported),
                                )
                              : Image.network(it.coverUrl!, width: 44, height: 44, fit: BoxFit.cover),
                        ),
                        title: Text(it.title),
                        subtitle: Text('${it.author} • ${it.year} • ★ ${it.rating.toStringAsFixed(1)}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ItemEditPage(existing: it)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
