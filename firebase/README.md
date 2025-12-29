# Firebase setup (local instructions)

Steps to enable Firebase (Firestore/Auth/Storage) for this project:

1. Create a Firebase project at https://console.firebase.google.com/
2. Add Android and/or iOS apps in the Firebase console.
   - For Android, download `google-services.json` and place it under `android/app/`.
   - For iOS, download `GoogleService-Info.plist` and add it to `ios/Runner/`.
3. In `pubspec.yaml` ensure `firebase_core`, `cloud_firestore`, `firebase_auth`, and `firebase_storage` are present (they already are).
4. Enable Firestore and Authentication (Email/Password) in the console.
5. (Optional) Configure Firebase Storage rules for image uploads.
6. Update `lib/config/firebase_config.dart` and set `useFirestore = true`.
7. Run `flutter pub get` then run the app. The app will attempt `Firebase.initializeApp()` and use Firestore repository.

Notes:
- The code falls back to an in-memory repository when Firebase initialization fails.
- After enabling Firebase, you should replace any mock behavior and test with real Firestore data.
