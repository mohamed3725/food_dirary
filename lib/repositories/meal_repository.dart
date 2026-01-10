import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/meal.dart';

/// المستودع (Repository) هو المسؤول عن إدارة البيانات الخاصة بالوجبات
/// هذه واجهة (Abstract Class) تحدد العمليات الأساسية التي يجب توفرها
abstract class MealRepository {
  /// الاستماع إلى قائمة الوجبات بشكل مستمر (تحديث تلقائي)
  Stream<List<Meal>> streamMeals();

  /// إضافة وجبة جديدة وإرجاع معرفها (ID)
  Future<String?> addMeal(Meal meal);

  /// تحديث بيانات وجبة موجودة
  Future<void> updateMeal(Meal meal);

  /// حذف وجبة عن طريق  (ID)
  Future<void> deleteMeal(String id);

  /// تحديث رابط الصورة لوجبة معينة
  Future<void> updateImageURL(String id, String url, {String? localPath});

  /// رفع صورة الوجبة إلى التخزين السحابي (Storage) وإرجاع الرابط
  Future<String> uploadImage(Uint8List bytes, String fileName);
}

/// Firestore-backed implementation
/// تنفيذ المستودع باستخدام Firebase Firestore و Firebase Storage
/// هذا هو الكلاس الفعلي الذي يتعامل مع السيرفر
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
  /// جلب البيانات من مجموعة 'meals' في Firestore وتحويلها لقائمة من كائنات [Meal]
  Stream<List<Meal>> streamMeals() {
    return _firestore.collection(collectionPath).snapshots().map((snap) {
      return snap.docs.map((d) {
        return Meal.fromMap(d.data(), d.id);
      }).toList();
    });
  }

  @override
  /// إضافة وجبة جديدة إلى Firestore
  /// يتم إزالة حقل ID من الـ Map لأن Firestore ينشئه تلقائيًا
  Future<String?> addMeal(Meal meal) async {
    final docRef = await _firestore.collection(collectionPath).add(meal.toMap()..remove('id'));
    return docRef.id;
  }

  @override
  /// تحديث وجبة موجودة في Firestore (بدون تغيير الـ ID)
  Future<void> updateMeal(Meal meal) async {
    await _firestore
        .collection(collectionPath)
        .doc(meal.id)
        .update(meal.toMap()..remove('id'));
  }

  @override
  /// حذف وثيقة (Document) الوجبة من Firestore
  Future<void> deleteMeal(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  @override
  /// تحديث حقل الصورة ووقت التعديل فقط للوجبة
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
  /// رفع ملف الصورة (Bytes) إلى Firebase Storage والحصول على رابط التحميل
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
/// تنفيذ وهمي (In-Memory) للمستودع، يُستخدم للتجربة بدون إنترنت أو سيرفر
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
