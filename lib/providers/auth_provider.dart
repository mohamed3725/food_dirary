import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// استخدمنا ستيت مانجمن نوعها بروفيدر عشان نهندل السستم

// هذا الملف لي يتعامل مع حالات ال auth لي يخليك تخش او لا للبرنامج

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

  String get userName {
    final user = _authService.currentUser;
    if (user == null || user.email == null) return 'Guest';
    // Extract the part before @ and capitalize it
    final emailPart = user.email!.split('@')[0];
    if (emailPart.isEmpty) return 'User';
    return emailPart[0].toUpperCase() + emailPart.substring(1);
  }

  String get userEmail => _authService.currentUser?.email ?? '';

  Future<void> signIn(String email, String password) =>
      _authService.signInWithEmailAndPassword(email, password);
  Future<void> register(String email, String password) =>
      _authService.registerWithEmailAndPassword(email, password);
  Future<void> signOut() => _authService.signOut();
}
