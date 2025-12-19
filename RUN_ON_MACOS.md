# Инструкция по запуску MyShelf на macOS (iOS Simulator / Android Emulator)

## 0) Требования
- macOS + Xcode (для iOS)
- Flutter SDK (stable)
- CocoaPods
- Firebase CLI + FlutterFire CLI

## 1) Установка Flutter (если ещё нет)
1) Скачайте Flutter SDK (stable) и добавьте в PATH.
2) Проверьте:
```bash
flutter --version
flutter doctor
```

## 2) Установка CocoaPods (нужно для iOS)
```bash
sudo gem install cocoapods
pod --version
```

## 3) Создайте новый Flutter-проект (чтобы получить iOS/Android папки)
В любой папке (например, `~/Projects`):
```bash
flutter create myshelf_app
cd myshelf_app
```

## 4) Перенесите код из архива
Распакуйте архив `MyShelf.zip`, затем скопируйте **с заменой** файлы/папки:
- `pubspec.yaml`
- `analysis_options.yaml`
- `lib/`
- `README.md`, `RUN_ON_MACOS.md`

Например:
```bash
cp -R /path/to/unzipped/MyShelf/lib .
cp /path/to/unzipped/MyShelf/pubspec.yaml .
cp /path/to/unzipped/MyShelf/analysis_options.yaml .
cp /path/to/unzipped/MyShelf/README.md .
cp /path/to/unzipped/MyShelf/RUN_ON_MACOS.md .
```

## 5) Подключите Firebase
### 5.1 Firebase CLI
```bash
brew install firebase-cli
firebase --version
firebase login
```

### 5.2 FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
flutterfire --version
```

### 5.3 Создайте Firebase-проект и включите сервисы
В Firebase Console:
- Authentication → Sign-in method → **Email/Password** (Enable)
- Firestore Database → Create database
- Storage → Get started

### 5.4 Сгенерируйте конфиги в проект
В корне `myshelf_app`:
```bash
flutter pub get
flutterfire configure
```

После этого появится:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
(и/или macOS plist при необходимости)

## 6) Настройка iOS (Pods)
```bash
cd ios
pod install
cd ..
```

## 7) Запуск
### iOS Simulator
```bash
open -a Simulator
flutter run
```

### Android Emulator
Установите Android Studio, создайте эмулятор, затем:
```bash
flutter run
```

## 8) Правила Firestore/Storage (рекомендуется)
Firestore rules:
```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Storage rules:
```js
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /covers/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 9) Сборка release
Android:
```bash
flutter build apk --release
# или
flutter build appbundle --release
```

iOS (архивация делается через Xcode):
```bash
flutter build ios --release
```
