import 'dart:async';

class AuthService {
  // Mock Stream - broadcast to allow multiple listeners if needed
  static final StreamController<bool> _authController = StreamController<bool>.broadcast();

  // Stream of auth changes
  Stream<bool> get authState => _authController.stream;

  // Sign in with Email and Password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // Mock login delay
    await Future.delayed(const Duration(seconds: 1));
    if (password == '123456') { // Simple mock validation
      _authController.add(true); // Emit logged in
      return;
    }
    throw 'Invalid credentials (use password: 123456)';
  }

  // Register with Email and Password
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _authController.add(true); // Emit logged in
  }

  // Sign Out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _authController.add(false); // Emit logged out
  }
}

