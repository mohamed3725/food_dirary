import 'package:flutter/foundation.dart';
import '../models/meal.dart';
import '../repositories/meal_repository.dart';
import '../services/notification_service.dart';

// لي يتعامل مع الوجبات

/// مزود البيانات (Provider) لإدارة حالة الوجبات في التطبيق
/// يربط بين واجهة المستخدم (UI) ومستودع البيانات (Repository)
class MealProvider extends ChangeNotifier {
  final MealRepository repository;
  final NotificationService _notificationService = NotificationService();
  List<Meal> _meals = [];
  bool _loading = false;

  MealProvider({required this.repository}) {
    _subscribe();
  }

  List<Meal> get meals => _meals;
  bool get loading => _loading;

  /// الاشتراك في Stream الوجبات لتحديث القائمة تلقائيًا عند حدوث تغييرات
  void _subscribe() {
    repository.streamMeals().listen((list) {
      _meals = list;
      notifyListeners();
    });
  }

  /// إضافة وجبة جديدة
  Future<void> add(Meal m) async {
    try {
      await repository.addMeal(m);
      _notificationService.showLocalNotification(
        title: 'New Meal Added! 🥗',
        body: '${m.name} has been added to your diary.',
      );
    } catch (e) {
      debugPrint('Error adding meal: $e');
    }
  }

  /// تحديث بيانات وجبة موجودة
  Future<void> update(Meal m) async {
    try {
      // Create a fresh copy with updated lastModified
      final mealToUpdate = Meal(
        id: m.id,
        name: m.name,
        description: m.description,
        createdAt: m.createdAt,
        lastModified: DateTime.now(),
        calories: m.calories,
        protein: m.protein,
        carbs: m.carbs,
        fat: m.fat,
      );

      await repository.updateMeal(mealToUpdate);

      _notificationService.showLocalNotification(
        title: 'Meal Updated! 📝',
        body: '${m.name} has been successfully updated.',
      );
    } catch (e) {
      debugPrint('Error updating meal: $e');
    }
  }

  /// حذف وجبة
  Future<void> remove(String id) async {
    try {
      await repository.deleteMeal(id);
    } catch (e) {
      debugPrint('Error deleting meal: $e');
    }
  }

  Future<void> addAll(List<Meal> meals) async {
    _loading = true;
    notifyListeners();
    try {
      for (var meal in meals) {
        await repository.addMeal(meal);
      }
    } catch (e) {
      debugPrint('Error bulk adding meals: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
