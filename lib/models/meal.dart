
/// // الكلاس هذا بيش نتعامل مع ميل 
class Meal {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final String? localImagePath;
  final DateTime createdAt;
  final DateTime lastModified;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  ///  (Constructor)  لإنشاء  
  Meal({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.localImagePath,
    required this.createdAt,
    required this.lastModified,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  /// يُستخدم هذا التنسيق عند إرسال البيانات إلى Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'localImagePath': localImagePath,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  /// إنشاء كائن وجبة جديد بناءً على البيانات القادمة من Firebase (Map)
  /// يأخذ البيانات (map) والمعرف الخاص بالمستند (documentId)
  
  /// يتعامل مع البيانات جايه من Firebase 
  factory Meal.fromMap(Map<String, dynamic> map, String documentId) {
    return Meal(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'],
      image: map['image'],
      localImagePath: map['localImagePath'],
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


