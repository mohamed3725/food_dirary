import 'package:flutter/material.dart';

class NutritionRow extends StatelessWidget {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  const NutritionRow({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Widget _buildItem(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildItem(context, 'Kcal', '$calories', Colors.orange),
        _buildItem(context, 'Prot', '${protein}g', Colors.blue),
        _buildItem(context, 'Carbs', '${carbs}g', Colors.green),
        _buildItem(context, 'Fat', '${fat}g', Colors.red),
      ],
    );
  }
}
