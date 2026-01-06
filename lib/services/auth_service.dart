import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream of auth changes
  Stream<bool> get authState => _firebaseAuth.authStateChanges().map((User? user) => user != null);

  User? get currentUser => _firebaseAuth.currentUser;

  // Sign in with Email and Password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An error occurred during login.';
    }
  }

  // Register with Email and Password
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An error occurred during registration.';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Helper for error messages
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'network-request-failed':
        return 'Connection failed: Please check your internet connection and try again.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      default:
        if (e.message != null && (e.message!.contains('network') || e.message!.contains('unreachable'))) {
          return 'Network error: Please check your connection.';
        }
        return 'Authentication failed: ${e.message}';
    }
  }
}

