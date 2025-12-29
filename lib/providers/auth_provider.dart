import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  bool _isAuthenticated = false;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _authService.authState.listen((loggedIn) {
      _isAuthenticated = loggedIn;
      notifyListeners();
    });
  }

  bool get isAuthenticated => _isAuthenticated;

  Future<void> signIn(String email, String password) =>
      _authService.signInWithEmailAndPassword(email, password);
  Future<void> register(String email, String password) =>
      _authService.registerWithEmailAndPassword(email, password);
  Future<void> signOut() => _authService.signOut();
}
