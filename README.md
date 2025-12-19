# Отчет по практическому заданию № 14
## Кан Вячеслав Юрьевич
### Обновлены зависимости

<img width="505" height="204" alt="image" src="https://github.com/user-attachments/assets/280ce38a-8bda-4625-9735-75eaa1eb748f" />

включены линты
``` yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

### Выполнен анализ

<img width="519" height="177" alt="image" src="https://github.com/user-attachments/assets/10b45323-f26e-479c-83c3-e97c2026e9d5" />

После исправления ошибок

<img width="332" height="63" alt="image" src="https://github.com/user-attachments/assets/11eb0b8b-9d36-4446-af10-9af06be06a91" />


### Добавлено 5 юнит тестов
``` dart
 test('should create Note with all fields', () {
      final now = DateTime.now();
      final note = Note(
        id: 1,
        title: 'Test Title',
        body: 'Test Body',
        createdAt: now,
        updatedAt: now,
      );

      expect(note.id, 1);
      expect(note.title, 'Test Title');
      expect(note.body, 'Test Body');
      expect(note.createdAt, now);
      expect(note.updatedAt, now);
    });
```

<img width="281" height="38" alt="image" src="https://github.com/user-attachments/assets/8bba43b5-c3ef-447b-9570-65bbfd2e08bb" />


### Добавлено 2 widget теста

``` dart
 testWidgets('App bar shows correct title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NotesPage()));
    // Ждём отрисовки
    await tester.pump();
```


<img width="411" height="45" alt="image" src="https://github.com/user-attachments/assets/f11a348f-de40-4cf1-a8c2-04902ae47547" />


### Профилирование

запуск приложения в профильном режиме


<img width="656" height="236" alt="image" src="https://github.com/user-attachments/assets/53e3cde4-b724-4474-b33c-e3bcce56e029" />

Производительность

<img width="656" height="236" alt="image" src="https://github.com/user-attachments/assets/4e9cff1d-4043-46e6-b797-eccbbea2c0af" />
<img width="865" height="172" alt="image" src="https://github.com/user-attachments/assets/8803acc6-1762-4689-95f1-7eef1de5e96a" />


### Оптимизация

``` dart
return NoteItem(
  key: ValueKey(note.id), // Стабильный уникальный ключ
  note: note,
  onEdit: () => _edit(note),
  onDelete: () => _delete(note),
);
```





















