import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal.dart';
import 'nutrition_row.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback? onTap;

  const MealCard({super.key, required this.meal, this.onTap});

  void _shareMeal() {
    final text = '''
Check out my meal on Food Diary! 🥗
Meal: ${meal.name}
${meal.description != null && meal.description!.isNotEmpty ? 'About: ${meal.description}\n' : ''}
Nutrition Facts:
🔥 Calories: ${meal.calories} kcal
💪 Protein: ${meal.protein}g
🍞 Carbs: ${meal.carbs}g
🥑 Fat: ${meal.fat}g

Track your journey with Food Diary!
''';
    Share.share(text, subject: 'My Meal: ${meal.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (meal.image != null && meal.image!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: kIsWeb
                            ? ((meal.image != null && meal.image!.isNotEmpty) || (meal.localImagePath != null))
                                ? Image.network(
                                    meal.image ?? meal.localImagePath!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.error_outline),
                                    ),
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_outlined),
                                  )
                            : ((meal.image != null && meal.image!.isNotEmpty) || (meal.localImagePath != null))
                                ? (meal.image != null && meal.image!.isNotEmpty)
                                    ? CachedNetworkImage(
                                        imageUrl: meal.image!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.image_outlined),
                                        ),
                                        errorWidget: (context, url, error) => meal.localImagePath != null
                                            ? Image.file(
                                                File(meal.localImagePath!),
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 80,
                                                height: 80,
                                                color: Colors.grey[200],
                                                child: const Icon(Icons.error_outline),
                                              ),
                                      )
                                    : Image.file(
                                        File(meal.localImagePath!),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_outlined),
                                  )
                        ),
                      )
                    else if (meal.localImagePath != null && !kIsWeb)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(meal.localImagePath!),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (meal.description != null &&
                              meal.description!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              meal.description!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    height: 1.4,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
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
                          icon: Icon(
                            Icons.share_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: _shareMeal,
                          tooltip: 'Share Meal',
                        ),
                      ],
                    ),
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
}
