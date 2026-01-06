import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/meal.dart';

abstract class MealRepository {
  Stream<List<Meal>> streamMeals();
  Future<String?> addMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String id);
  Future<void> updateImageURL(String id, String url, {String? localPath});
  Future<String> uploadImage(Uint8List bytes, String fileName);
}

/// Firestore-backed implementation
class FirestoreMealRepository implements MealRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String collectionPath;

  FirestoreMealRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    this.collectionPath = 'meals',
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  @override
  Stream<List<Meal>> streamMeals() {
    return _firestore.collection(collectionPath).snapshots().map((snap) {
      return snap.docs.map((d) {
        return Meal.fromMap(d.data(), d.id);
      }).toList();
    });
  }

  @override
  Future<String?> addMeal(Meal meal) async {
    final docRef = await _firestore.collection(collectionPath).add(meal.toMap()..remove('id'));
    return docRef.id;
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    await _firestore
        .collection(collectionPath)
        .doc(meal.id)
        .update(meal.toMap()..remove('id'));
  }

  @override
  Future<void> deleteMeal(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  @override
  Future<void> updateImageURL(String id, String url, {String? localPath}) async {
    final updates = {
      'image': url,
      'lastModified': DateTime.now().toIso8601String(),
    };
    if (localPath != null) {
      updates['localImagePath'] = localPath;
    }
    await _firestore.collection(collectionPath).doc(id).update(updates);
  }

  @override
  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    try {
      final ref = _storage.ref().child('meal_images').child(fileName);
      final uploadTask = await ref.putData(bytes);
      final url = await uploadTask.ref.getDownloadURL();
      debugPrint('Upload successful: $url');
      return url;
    } catch (e) {
      debugPrint('Firebase Storage Error: $e');
      rethrow;
    }
  }
}

/// Simple in-memory implementation for local testing / mock mode
class InMemoryMealRepository implements MealRepository {
  final Map<String, Meal> _store = {};
  final StreamController<List<Meal>> _controller =
      StreamController.broadcast();

  InMemoryMealRepository() {
    _emit();
  }

  void _emit() => _controller.add(_store.values.toList());

  @override
  Stream<List<Meal>> streamMeals() => _controller.stream;

  @override
  Future<String?> addMeal(Meal meal) async {
    // Simulate ID generation if empty
    String id = meal.id.isEmpty ? DateTime.now().toIso8601String() : meal.id;
    _store[id] = meal; 
    _emit();
    return id;
  }

  @override
  Future<void> deleteMeal(String id) async {
    _store.remove(id);
    _emit();
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    _store[meal.id] = meal;
    _emit();
  }

  @override
  Future<void> updateImageURL(String id, String url, {String? localPath}) async {
    if (_store.containsKey(id)) {
      final meal = _store[id]!;
      _store[id] = Meal(
        id: meal.id,
        name: meal.name,
        description: meal.description,
        image: url,
        localImagePath: localPath ?? meal.localImagePath,
        createdAt: meal.createdAt,
        lastModified: DateTime.now(),
        calories: meal.calories,
        protein: meal.protein,
        carbs: meal.carbs,
        fat: meal.fat,
      );
      _emit();
    }
  }

  @override
  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    // Just return a mock URL
    return 'https://via.placeholder.com/150';
  }
}
