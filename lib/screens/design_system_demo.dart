import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/meal_card.dart';
import '../models/meal.dart';

class DesignSystemDemo extends StatelessWidget {
  const DesignSystemDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final demoMeal = Meal(
      id: 'demo',
      name: 'Demo Meal',
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      calories: 300,
      protein: 20,
      carbs: 40,
      fat: 10,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Design System Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Typography',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Headline', style: Theme.of(context).textTheme.headlineSmall),
            Text('Body', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            const Text('Form Elements',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            CustomTextField(label: 'Example input'),
            const SizedBox(height: 12),
            PrimaryButton(text: 'Primary action', onPressed: () {}),
            const SizedBox(height: 16),
            const Text('Empty State',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const SizedBox(height: 160, child: EmptyState()),
            const SizedBox(height: 16),
            const Text('Cards', style: TextStyle(fontWeight: FontWeight.bold)),
            MealCard(meal: demoMeal),
          ],
        ),
      ),
    );
  }
}
