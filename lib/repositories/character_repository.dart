import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/character.dart';

abstract class CharacterRepository {
  Stream<List<Character>> streamCharacters();
  Future<void> createCharacter(Character c);
  Future<void> updateCharacter(Character c);
  Future<void> deleteCharacter(String id);
}

/// Firestore-backed implementation (requires Firebase initialization)
class FirestoreCharacterRepository implements CharacterRepository {
  final FirebaseFirestore _firestore;
  final String collectionPath;

  FirestoreCharacterRepository(
      {FirebaseFirestore? firestore, this.collectionPath = 'characters'})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Character>> streamCharacters() {
    return _firestore.collection(collectionPath).snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = d.data();
        data['id'] = d.id;
        return Character.fromJson(Map<String, dynamic>.from(data));
      }).toList();
    });
  }

  @override
  Future<void> createCharacter(Character c) async {
    final map = c.toJson();
    await _firestore.collection(collectionPath).add(map);
  }

  @override
  Future<void> updateCharacter(Character c) async {
    await _firestore.collection(collectionPath).doc(c.id).set(c.toJson());
  }

  @override
  Future<void> deleteCharacter(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }
}

/// Simple in-memory implementation for local testing / mock mode
class InMemoryCharacterRepository implements CharacterRepository {
  final Map<String, Character> _store = {};
  final StreamController<List<Character>> _controller =
      StreamController.broadcast();

  InMemoryCharacterRepository() {
    // Emit initial empty list
    _controller.add(_store.values.toList());
  }

  void _emit() => _controller.add(_store.values.toList());

  @override
  Stream<List<Character>> streamCharacters() => _controller.stream;

  @override
  Future<void> createCharacter(Character c) async {
    _store[c.id] = c;
    _emit();
  }

  @override
  Future<void> deleteCharacter(String id) async {
    _store.remove(id);
    _emit();
  }

  @override
  Future<void> updateCharacter(Character c) async {
    _store[c.id] = c;
    _emit();
  }
}
