import 'dart:convert';

class Character {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime lastModified;
  final List<String> skills;
  final Map<String, double> stats;

  const Character({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.createdAt,
    required this.lastModified,
    this.skills = const [],
    this.stats = const {},
  });

  Character copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? lastModified,
    List<String>? skills,
    Map<String, double>? stats,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      skills: skills ?? List<String>.from(this.skills),
      stats: stats ?? Map<String, double>.from(this.stats),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'skills': skills,
      'stats': stats,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : DateTime.now(),
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      stats: (json['stats'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          {},
    );
  }

  String toRawJson() => json.encode(toJson());

  factory Character.fromRawJson(String str) =>
      Character.fromJson(json.decode(str));

  @override
  String toString() {
    return 'Character(id: $id, name: $name, skills: ${skills.length}, stats: ${stats.length})';
  }
}
