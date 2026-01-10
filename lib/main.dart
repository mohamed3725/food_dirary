import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/meal_provider.dart';
import 'repositories/meal_repository.dart';
import 'config/firebase_config.dart';
import 'services/notification_service.dart';
import 'providers/connectivity_provider.dart';

/// الدالة الرئيسية (Main Entry Point) للتطبيق
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// تهيئة خدمة الإشعارات
  try {
    final notificationService = NotificationService();
    await notificationService.initialize().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('Notification initialization failed: $e');
  }

  /// تحديد نوع مستودع البيانات (MealRepository)
  /// إذا كان استخدام Firestore مفعلًا، سيتم الاتصال بـ Firebase
  /// وإلا سيتم استخدام ذاكرة مؤقتة (InMemory) للتجربة المحلية
  MealRepository mealRepo;
  if (FirebaseConfig.useFirestore) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      mealRepo = FirestoreMealRepository();
    } catch (e) {
      // If Firebase fails to initialize, fall back to in-memory repo.
      mealRepo = InMemoryMealRepository();
    }
  } else {
    mealRepo = InMemoryMealRepository();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(
            create: (_) => MealProvider(repository: mealRepo)),
      ],
      child: const FoodDiaryApp(),
    ),
  );
}

/// الودجت الجذرية (Root Widget) تشمل إعداد المزودات (Providers) والثيم
class FoodDiaryApp extends StatelessWidget {
  const FoodDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      title: 'Food Diary',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.mode,
      home: authProvider.isAuthenticated
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
