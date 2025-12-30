import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../repositories/meal_repository.dart';

class MealProvider extends ChangeNotifier {
  final MealRepository repository;
  List<Meal> _meals = [];
  bool _loading = false;

  MealProvider({required this.repository}) {
    _subscribe();
  }

  List<Meal> get meals => _meals;
  bool get loading => _loading;

  void _subscribe() {
    repository.streamMeals().listen((list) {
      _meals = list;
      notifyListeners();
    });
  }

  Future<void> add(Meal m) async {
    // _loading = true; // Removed to prevent blocking UI
    // notifyListeners();
    try {
      await repository.addMeal(m);
    } catch (e) {
      debugPrint('Error adding meal: $e');
    }
  }

  Future<void> update(Meal m) async {
    try {
      await repository.updateMeal(m);
    } catch (e) {
      debugPrint('Error updating meal: $e');
    }
  }

  Future<void> remove(String id) async {
    try {
      await repository.deleteMeal(id);
    } catch (e) {
      debugPrint('Error deleting meal: $e');
    }
  }
}
