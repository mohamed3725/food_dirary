import 'package:flutter/material.dart';
import '../models/character.dart';
import '../repositories/character_repository.dart';

class CharacterProvider extends ChangeNotifier {
  final CharacterRepository repository;
  List<Character> _characters = [];
  bool _loading = false;

  CharacterProvider({required this.repository}) {
    _subscribe();
  }

  List<Character> get characters => _characters;
  bool get loading => _loading;

  void _subscribe() {
    repository.streamCharacters().listen((list) {
      _characters = list;
      notifyListeners();
    });
  }

  Future<void> add(Character c) async {
    _loading = true;
    notifyListeners();
    await repository.createCharacter(c);
    _loading = false;
    notifyListeners();
  }

  Future<void> update(Character c) async {
    _loading = true;
    notifyListeners();
    await repository.updateCharacter(c);
    _loading = false;
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _loading = true;
    notifyListeners();
    await repository.deleteCharacter(id);
    _loading = false;
    notifyListeners();
  }
}
