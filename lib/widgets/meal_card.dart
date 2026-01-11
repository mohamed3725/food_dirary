import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/meal.dart';
import 'nutrition_row.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback? onTap;

  const MealCard({super.key, required this.meal, this.onTap});

  // هذه دالة المشاركة، وظيفتها تاخذ بيانات الوجبة وترسلها لتطبيقات ثانية
  void _shareMeal() {
    // هنا نجهز النص اللي بنشاركه، يحتوي على الاسم والوصف والسعرات
    final text = 'Check out my meal on Food Diary! 🥗\n'
        'Meal: ${meal.name}\n'
        '${meal.description?.isNotEmpty == true ? 'About: ${meal.description}\n' : ''}'
        'Nutrition Facts:\n'
        '🔥 Calories: ${meal.calories} kcal\n'
        '💪 Protein: ${meal.protein}g\n'
        '🍞 Carbs: ${meal.carbs}g\n'
        '🥑 Fat: ${meal.fat}g\n\n'
        'Track your journey with Food Diary!';

    // هذا السطر هو اللي يفتح قائمة المشاركة في الموبايل
    Share.share(text, subject: 'My Meal: ${meal.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildMealInfo(context)),
                    const SizedBox(width: 12),
                    _buildActions(context),
                  ],
                ),
                const SizedBox(height: 12),
                NutritionRow(
                  calories: meal.calories,
                  protein: meal.protein,
                  carbs: meal.carbs,
                  fat: meal.fat,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          meal.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (meal.description?.isNotEmpty == true) ...[
          const SizedBox(height: 6),
          Text(
            meal.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.4,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.restaurant_menu,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        IconButton(
          onPressed: _shareMeal,
          icon: Icon(
            Icons.share_outlined,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          tooltip: 'Share Meal',
        ),
      ],
    );
  }
}
