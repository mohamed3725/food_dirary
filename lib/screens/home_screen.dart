import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_card.dart';
import '../widgets/empty_state.dart';
import 'add_edit_meal_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final meals = mealProvider.meals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Food Diary'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Show confirmation dialog or just logout
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: mealProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : meals.isEmpty
              ? const EmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 100, // Large padding to avoid FAB overlap
                  ),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return MealCard(
                      meal: meals[index],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditMealScreen(meal: meals[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditMealScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
      ),
    );
  }
}
