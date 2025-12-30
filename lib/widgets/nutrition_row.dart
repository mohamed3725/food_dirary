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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.8),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildItem(context, 'Kcal', '$calories', Colors.orange),
        _buildItem(context, 'Prot', '${protein}g', Colors.blue),
        _buildItem(context, 'Carbs', '${carbs}g', Colors.green),
        _buildItem(context, 'Fat', '${fat}g', Colors.red),
      ],
    );
  }
}
