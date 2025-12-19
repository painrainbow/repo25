# Отчет по практическому заданию № 11
## Кан Вячеслав Юрьевич
### Cоздание нового ресурса в mockapi

<img width="609" height="360" alt="image" src="https://github.com/user-attachments/assets/1b44d67a-fef6-4b41-8479-a30f51baaeb6" />

<img width="507" height="309" alt="image" src="https://github.com/user-attachments/assets/9fb812d5-cf1e-4915-bf5c-35a066d4a0b1" />


### Контрольная точка №2
Проект создан, собран и запускается

<img width="505" height="553" alt="image" src="https://github.com/user-attachments/assets/f381be5a-9a5f-41a7-8e57-ac569d705f3f" />

<img width="312" height="534" alt="image" src="https://github.com/user-attachments/assets/d183d08e-d09a-43c4-8357-c716a18cbbe2" />


### Контрольная точка №3
Код модели note
``` dart 
class Note {
  final String id;
  final String title;
  final String body;

  Note({required this.id, required this.title, required this.body});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] is String
        ? int.tryParse(json['id']) ?? 0
        : (json['id'] ?? 0),
    title: json['title'] ?? '',
    body: json['body'] ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body};
}
```


### Измененные эндпоинты репозитории

<img width="550" height="450" alt="image" src="https://github.com/user-attachments/assets/6c41cc2e-a3a6-46fe-85de-b8176dc6cbe2" />



<img width="304" height="522" alt="image" src="https://github.com/user-attachments/assets/8536799b-8385-448f-ab22-3559e110854b" />

### Записи

<img width="302" height="160" alt="image" src="https://github.com/user-attachments/assets/b0ce41ff-36d3-4264-9258-a794806d9f2e" />

### 
Проект создан, собран и запускается





















