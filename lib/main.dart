import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/meal.dart';
import 'widgets/meal_card.dart';
import 'widgets/empty_state.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Disabled for Mock Mode
  runApp(const FoodDiaryApp());
}

class FoodDiaryApp extends StatelessWidget {
  const FoodDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Diary',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: StreamBuilder<bool>(
        stream: AuthService().authState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             // If we don't have a value yet, check if we want to default to login or not.
             // For mock, let's just show LoginScreen by default if no event yet.
             // But StreamBuilder starts with waiting. 
             // We can emit an initial value in AuthService or handle it here.
             // Let's assume waiting = loading or default to login.
            return const LoginScreen(); 
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
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
