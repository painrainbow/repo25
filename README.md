# Отчёт по разработке мобильного приложения "Каталог домашней библиотеки/коллекции" (Кан Вячеслав Юрьевич)

## Цель работы
Целью данной работы было создание мобильного приложения для каталогизации личной домашней библиотеки и коллекций (книги, комиксы, виниловые пластинки, настольные игры). Приложение должно поддерживать регистрацию пользователей, хранение элементов коллекции и организацию их по полкам.

# Функционал 
## 1. База данных
Профили пользователей
Элементы коллекции: title, author, year, coverUrl, rating, tags, shelfId, type
Полки/коллекции (например: “Прочитано”, “Хочу прочитать”, “Любимые”)
## 2. Авторизация/Регистрация
Email/Password через Firebase Auth
Создание профиля в Firestore при регистрации
## 3. Списки
Общий список предметов коллекции пользователя
Фильтры: по типу, полке, тегам, поиску
Сортировка: по названию, году, рейтингу, дате добавления
Отдельный экран полок и просмотр по выбранной полке

# Регистрация
<img width="264" height="603" alt="Снимок экрана 2025-12-19 в 05 24 51" src="https://github.com/user-attachments/assets/b40cc39f-c1f7-4665-b197-5d3980eba143" />

# Главная страница
<img width="193" height="423" alt="Снимок экрана 2025-12-19 в 05 40 29" src="https://github.com/user-attachments/assets/3b329df3-7f03-44e9-a12d-d2f152beef9f" />

# Создание книги и комикса
<img width="349" height="777" alt="Снимок экрана 2025-12-19 в 08 56 44" src="https://github.com/user-attachments/assets/06e68f40-36e7-4f4d-8146-b828efa31ff4" />
<img width="344" height="774" alt="Снимок экрана 2025-12-19 в 08 55 25" src="https://github.com/user-attachments/assets/0a550f43-e4b5-4351-a4e1-9d22e1d5fe89" />
<img width="348" height="773" alt="Снимок экрана 2025-12-19 в 05 43 19" src="https://github.com/user-attachments/assets/d1ce8ad3-e92b-4ca2-b4af-1b381327f27d" />
<img width="337" height="777" alt="Снимок экрана 2025-12-19 в 08 55 56" src="https://github.com/user-attachments/assets/5d5223fe-8a8d-459d-b7c3-6ad2f07c7034" />

# Создание полки и списки
<img width="342" height="778" alt="Снимок экрана 2025-12-19 в 08 57 31" src="https://github.com/user-attachments/assets/e0d42e2d-439a-4a1c-9963-5c540319c127" />
<img width="344" height="781" alt="Снимок экрана 2025-12-19 в 05 56 28" src="https://github.com/user-attachments/assets/872df9d1-4038-43ab-bc98-866b1ad6dbcb" />
<img width="347" height="774" alt="Снимок экрана 2025-12-19 в 05 56 57" src="https://github.com/user-attachments/assets/c0ff3685-db9c-437c-989b-d6b95b2590d8" />

# Используемые технологии
- Flutter — кроссплатформенный фреймворк для мобильной разработки
- Dart — язык программирования
- Firebase Authentication — регистрация и вход пользователей
- Cloud Firestore — хранение данных коллекции
- Android Emulator — тестирование приложения

