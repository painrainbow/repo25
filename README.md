# Отчет по практическому заданию № 8
## Кан Вячеслав Юрьевич
### Подключение firebase к проекту.

<img width="600" height="201" alt="image" src="https://github.com/user-attachments/assets/bde2f0a7-e52b-486e-b3a5-c2bea9a42c5e" />


### Создание базы данных в firebase.

<img width="773" height="519" alt="image" src="https://github.com/user-attachments/assets/d15d8a43-bc5c-49a0-b89c-190b0815af9d" />


### Настроеная база данных.

<img width="1054" height="528" alt="image" src="https://github.com/user-attachments/assets/41213332-09f4-400e-be5e-8ab70aca8cfb" />


### Работающее приложение с заметками. Добавление/изменение/удаление

<img width="308" height="536" alt="image" src="https://github.com/user-attachments/assets/d37d7fda-197f-4493-87c4-17869f98a4ac" />


### Отображение заметки в firebase.

<img width="806" height="300" alt="image" src="https://github.com/user-attachments/assets/f288b340-5b5d-44a6-b6bb-953b075ca913" />


### Дополнительное задание (по желанию, +1 балл)
1. **Добавил аутентификацию:**
   ```yaml
   # pubspec.yaml
   firebase_auth: ^4.6.1

   
Безопасность: что поменять в продакшене
Текущие правила безопасности Firestore разрешают чтение и запись всем пользователям без аутентификации. Это недопустимо для продакшен-среды.

Ключевые файлы проекта
lib/main.dart - точка входа приложения, инициализация Firebase
lib/firebase_options.dart - конфигурация Firebase (автогенерация)
lib/notes_page.dart - основной экран с CRUD-операциями
android/app/google-services.json - конфигурация Firebase для Android
ios/Runner/GoogleService-Info.plist - конфигурация Firebase для iOS
Заключение
В ходе практического занятия успешно разработано Flutter-приложение, интегрированное с Firebase Firestore. Реализованы CRUD-операции и синхронизация данных в реальном времени.
