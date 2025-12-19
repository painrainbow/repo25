import 'package:flutter/material.dart';

Future<String?> showShelfEditDialog(
  BuildContext context, {
  required String title,
  String initial = '',
}) async {
  final c = TextEditingController(text: initial);

  return showDialog<String?>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: c,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Название',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Отмена')),
        FilledButton(
          onPressed: () {
            final v = c.text.trim();
            if (v.isEmpty) return;
            Navigator.pop(ctx, v);
          },
          child: const Text('Сохранить'),
        ),
      ],
    ),
  );
}
