import 'dart:io' show File, Directory;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../repositories/meal_repository.dart';
import '../services/notification_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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
  /// يقوم بحفظ البيانات، تخزين الصورة محليًا (للسرعة)، ثم رفع الصورة للخادم في الخلفية
  Future<void> add(Meal m, {Uint8List? imageBytes, String? fileName, String? webPath}) async {
    try {
      final docId = await repository.addMeal(m);
      if (docId != null && (imageBytes != null || webPath != null)) {
        String? localPath;
        if (kIsWeb) {
          localPath = webPath;
        } else if (imageBytes != null && fileName != null) {
          localPath = await _saveLocalImage(imageBytes, fileName);
        }

        if (localPath != null) {
          final mealWithLocal = Meal(
            id: docId,
            name: m.name,
            description: m.description,
            image: m.image,
            localImagePath: localPath,
            createdAt: m.createdAt,
            lastModified: m.lastModified,
            calories: m.calories,
            protein: m.protein,
            carbs: m.carbs,
            fat: m.fat,
          );
          await repository.updateMeal(mealWithLocal);
          
          if (imageBytes != null && fileName != null) {
            _uploadInBackground(docId, mealWithLocal, imageBytes, fileName);
          }
        } else if (imageBytes != null && fileName != null) {
          _uploadInBackground(docId, m, imageBytes, fileName);
        }
      }
      _notificationService.showLocalNotification(
        title: 'New Meal Added! 🥗',
        body: '${m.name} has been added to your diary.',
      );
    } catch (e) {
      debugPrint('Error adding meal: $e');
    }
  }

  /// تحديث بيانات وجبة موجودة وتحديث الصورة إذا وجدت
  Future<void> update(Meal m, {Uint8List? imageBytes, String? fileName, String? webPath}) async {
    try {
      String? currentLocalPath = m.localImagePath;
      if (kIsWeb) {
        if (webPath != null) currentLocalPath = webPath;
      } else if (imageBytes != null && fileName != null) {
        currentLocalPath = await _saveLocalImage(imageBytes, fileName);
      }
      
      final mealToUpdate = Meal(
        id: m.id,
        name: m.name,
        description: m.description,
        image: m.image,
        localImagePath: currentLocalPath,
        createdAt: m.createdAt,
        lastModified: m.lastModified,
        calories: m.calories,
        protein: m.protein,
        carbs: m.carbs,
        fat: m.fat,
      );

      await repository.updateMeal(mealToUpdate);

      if (imageBytes != null && fileName != null) {
        _uploadInBackground(m.id, mealToUpdate, imageBytes, fileName);
      }
      _notificationService.showLocalNotification(
        title: 'Meal Updated! 📝',
        body: '${m.name} has been successfully updated.',
      );
    } catch (e) {
      debugPrint('Error updating meal: $e');
    }
  }

  /// عملية رفع الصورة في الخلفية (Background Upload)
  /// تضمن عدم توقف واجهة التطبيق أثناء الرفع
  Future<void> _uploadInBackground(String docId, Meal originalMeal, Uint8List bytes, String fileName) async {
    try {
      debugPrint('Starting background upload for meal $docId...');
      final url = await repository.uploadImage(bytes, fileName);
      debugPrint('Background upload finished. URL: $url');
      await repository.updateImageURL(docId, url, localPath: originalMeal.localImagePath);
      debugPrint('Firestore updated with image URL.');
    } catch (e) {
      debugPrint('Background upload failed: $e');
    }
  }

  Future<String?> _saveLocalImage(Uint8List bytes, String fileName) async {
    if (kIsWeb) return null;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(directory.path, 'meal_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      final filePath = path.join(imagesDir.path, fileName);
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      debugPrint('Error saving image locally: $e');
      return null;
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

  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    return await repository.uploadImage(bytes, fileName);
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
