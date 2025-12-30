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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Optionally initialize Firebase and use Firestore repository.
  // Optionally initialize Firebase and use Firestore repository.
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
        ChangeNotifierProvider(
            create: (_) => MealProvider(repository: mealRepo)),
      ],
      child: const FoodDiaryApp(),
    ),
  );
}

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


