class Meal {
  final String name;
  final String? description;
  final String? image;
  final DateTime createdAt;
  final DateTime lastModified;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

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
