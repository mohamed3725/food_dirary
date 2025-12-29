import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'models/meal.dart';
import 'widgets/meal_card.dart';
import 'widgets/empty_state.dart';
// auth handled by `AuthProvider`
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/character_provider.dart';
import 'repositories/character_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Optional: enable when configured
  // Provide an in-memory repository by default (replace with FirestoreCharacterRepository when Firebase enabled)
  final characterRepo = InMemoryCharacterRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => CharacterProvider(repository: characterRepo)),
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data for Demo
    final List<Meal> meals = [
      Meal(
        id: '1',
        name: 'Oatmeal with Berries',
        description: 'Healthy breakfast with blueberries and honey',
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
        calories: 350,
        protein: 12,
        carbs: 60,
        fat: 6,
      ),
      Meal(
        id: '2',
        name: 'Grilled Chicken Salad',
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
        calories: 450,
        protein: 40,
        carbs: 10,
        fat: 20,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {},
          ),
        ],
      ),
      body: meals.isEmpty
          ? const EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return MealCard(
                  meal: meals[index],
                  onTap: () {
                    // Navigate to details
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
