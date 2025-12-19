import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/data/items_repo.dart';
import '../../core/models/item.dart';
import '../../core/models/shelf.dart';
import '../../core/providers.dart';

class ItemEditPage extends ConsumerStatefulWidget {
  final CollectionItem? existing;
  const ItemEditPage({super.key, this.existing});

  @override
  ConsumerState<ItemEditPage> createState() => _ItemEditPageState();
}

class _ItemEditPageState extends ConsumerState<ItemEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _year = TextEditingController();
  final _tags = TextEditingController();

  ItemType _type = ItemType.book;
  String? _shelfId;
  double _rating = 0;
  File? _pickedCover;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _title.text = e.title;
      _author.text = e.author;
      _year.text = e.year.toString();
      _tags.text = e.tags.join(', ');
      _type = e.type;
      _shelfId = e.shelfId;
      _rating = e.rating;
    } else {
      _year.text = DateTime.now().year.toString();
      _rating = 0;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _year.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (x == null) return;
    setState(() => _pickedCover = File(x.path));
  }

  List<String> _parseTags(String raw) {
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
  }

  Future<void> _save(List<Shelf> shelves) async {
    if (!_formKey.currentState!.validate()) return;
    if (_shelfId == null || _shelfId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Выберите полку')));
      return;
    }

    setState(() => _saving = true);
    try {
      final itemsRepo = ref.read(itemsRepoProvider);

      final title = _title.text.trim();
      final author = _author.text.trim();
      final year = int.parse(_year.text.trim());
      final tags = _parseTags(_tags.text);

      String? coverUrl = widget.existing?.coverUrl;

      if (widget.existing == null) {
        // Create doc first to get id (we return id), then optionally upload cover and patch
        final id = await itemsRepo.createItem(
          title: title,
          author: author,
          year: year,
          rating: _rating,
          tags: tags,
          shelfId: _shelfId!,
          type: _type,
          coverUrl: null,
        );
        if (_pickedCover != null) {
          coverUrl = await itemsRepo.uploadCover(id, _pickedCover!);
          if (coverUrl != null) await itemsRepo.updateItem(id, {'coverUrl': coverUrl});
        }
      } else {
        final id = widget.existing!.id;
        if (_pickedCover != null) {
          coverUrl = await itemsRepo.uploadCover(id, _pickedCover!);
        }
        await itemsRepo.updateItem(id, {
          'title': title,
          'author': author,
          'year': year,
          'rating': _rating,
          'tags': tags,
          'shelfId': _shelfId,
          'type': _type.name,
          'coverUrl': coverUrl,
        });
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка сохранения: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shelvesRepo = ref.watch(shelvesRepoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Добавить предмет' : 'Редактировать'),
      ),
      body: StreamBuilder<List<Shelf>>(
        stream: shelvesRepo.watchShelves(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('Ошибка: ${snap.error}'));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final shelves = snap.data!;
          if (shelves.isEmpty) {
            return const Center(child: Text('Сначала создайте полку на вкладке "Полки".'));
          }
          _shelfId ??= shelves.first.id;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _pickedCover != null
                              ? Image.file(_pickedCover!, width: 88, height: 88, fit: BoxFit.cover)
                              : (widget.existing?.coverUrl != null
                                  ? Image.network(widget.existing!.coverUrl!, width: 88, height: 88, fit: BoxFit.cover)
                                  : Container(
                                      width: 88,
                                      height: 88,
                                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      child: const Icon(Icons.image),
                                    )),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FilledButton.icon(
                                onPressed: _saving ? null : _pickImage,
                                icon: const Icon(Icons.upload),
                                label: const Text('Обложка'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Изображение хранится в Firebase Storage',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _title,
                      decoration: const InputDecoration(labelText: 'Название', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите название' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _author,
                      decoration: const InputDecoration(labelText: 'Автор/Исполнитель/Издатель', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите автора/исполнителя' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _year,
                      decoration: const InputDecoration(labelText: 'Год', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Введите год';
                        final n = int.tryParse(v.trim());
                        if (n == null || n < 0 || n > DateTime.now().year + 5) return 'Некорректный год';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ItemType>(
                      value: _type,
                      decoration: const InputDecoration(labelText: 'Тип', border: OutlineInputBorder()),
                      items: ItemType.values
                          .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                          .toList(),
                      onChanged: _saving ? null : (v) => setState(() => _type = v!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _shelfId,
                      decoration: const InputDecoration(labelText: 'Полка', border: OutlineInputBorder()),
                      items: shelves.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                      onChanged: _saving ? null : (v) => setState(() => _shelfId = v),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _tags,
                      decoration: const InputDecoration(
                        labelText: 'Теги (через запятую)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Оценка: ${_rating.toStringAsFixed(1)}'),
                            Slider(
                              value: _rating,
                              min: 0,
                              max: 5,
                              divisions: 50,
                              onChanged: _saving ? null : (v) => setState(() => _rating = v),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: _saving ? null : () => _save(shelves),
                      icon: const Icon(Icons.save),
                      label: Text(_saving ? 'Сохранение...' : 'Сохранить'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
