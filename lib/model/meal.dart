/// تمثل هذه الفئة وجبة طعام وتحتوي على التفاصيل الغذائية الخاصة بها
class Meal {
  /// اسم الوجبة
  final String name;

  /// وصف اختياري للوجبة
  final String? description;

  /// رابط أو مسار صورة الوجبة (اختياري)
  final String? image;

  /// تاريخ ووقت إنشاء الوجبة
  final DateTime createdAt;

  /// تاريخ ووقت آخر تعديل للوجبة
  final DateTime lastModified;

  /// عدد السعرات الحرارية في الوجبة
  final int calories;

  /// كمية البروتين في الوجبة (بالجرام)
  final double protein;

  /// كمية الكربوهيدرات في الوجبة (بالجرام)
  final double carbs;

  /// كمية الدهون في الوجبة (بالجرام)
  final double fat;

  /// المُنشئ (Constructor) لإنشاء كائن جديد من نوع Meal
  Meal({
    required this.name,
    this.description,
    this.image,
    required this.createdAt,
    required this.lastModified,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  /// تحويل كائن الوجبة إلى خريطة (Map) لحفظها في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  /// إنشاء كائن وجبة من خريطة (Map) قادمة من قاعدة البيانات
  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      name: map['name'] ?? '',
      description: map['description'],
      image: map['image'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      lastModified: map['lastModified'] != null
          ? DateTime.parse(map['lastModified'])
          : DateTime.now(),
      calories: map['calories']?.toInt() ?? 0,
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
    );
  }
}
