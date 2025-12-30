import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';

abstract class MealRepository {
  Stream<List<Meal>> streamMeals();
  Future<void> addMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String id);
}

/// Firestore-backed implementation
class FirestoreMealRepository implements MealRepository {
  final FirebaseFirestore _firestore;
  final String collectionPath;

  FirestoreMealRepository(
      {FirebaseFirestore? firestore, this.collectionPath = 'meals'})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Meal>> streamMeals() {
    return _firestore.collection(collectionPath).snapshots().map((snap) {
      return snap.docs.map((d) {
        return Meal.fromMap(d.data(), d.id);
      }).toList();
    });
  }

  @override
  Future<void> addMeal(Meal meal) async {
    // We don't include 'id' in the map because Firestore generates it
    // But Meal.toMap includes 'id'. We should probably remove it or let Firestore ignore it.
    // Better to just let Firestore generate ID and we ignore the ID in the passed meal object for creation.
    // However, if we want to support offline creation with UUID, we might set it.
    // For simplicity, let's just add the map.
    await _firestore.collection(collectionPath).add(meal.toMap()..remove('id'));
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    await _firestore
        .collection(collectionPath)
        .doc(meal.id)
        .set(meal.toMap()..remove('id'));
  }

  @override
  Future<void> deleteMeal(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
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
  Future<void> addMeal(Meal meal) async {
    // Simulate ID generation if empty
    String id = meal.id.isEmpty ? DateTime.now().toIso8601String() : meal.id;
    // Create new meal with ID to store
    // Since Meal fields are final, we assume the passed meal has an ID or we treat it as such.
    // If the ID is mock, we just store it.
    _store[id] = meal; 
    _emit();
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
}
