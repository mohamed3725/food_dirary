import 'package:flutter/material.dart';

// هذا الودجت مسؤول عن عرض شريط القيم الغذائية (سعرات، بروتين، كارب، دهون)
// بنستخدمه عشان نعرض تفاصيل الاكل بشكل مرتب وجميل
class NutritionRow extends StatelessWidget {
  // المتغيرات هذي عشان نستقبل القيم الغذائية لما نستدعي الودجت
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

  // هذي دالة مساعدة تبني مربع واحد لكل قيمة (عشان ما نكرر الكود 4 مرات)
  // تاخذ الاسم والقيمة واللون وترجع شكل المربع جاهز
  Widget _buildItem(
      BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // لون الخلفية شفاف شوي
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // عرض القيمة (الرقم)
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 2),
          // عرض الاسم (مثلا Kcal او Prot)
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
    // هنا نرتب المربعات جنب بعض في صف واحد
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildItem(context, 'Kcal', '$calories', Colors.orange), // السعرات
        _buildItem(context, 'Prot', '${protein}g', Colors.blue), // البروتين
        _buildItem(context, 'Carbs', '${carbs}g', Colors.green), // الكارب
        _buildItem(context, 'Fat', '${fat}g', Colors.red), // الدهون
      ],
    );
  }
}
