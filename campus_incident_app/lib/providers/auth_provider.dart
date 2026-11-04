import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();
  AppUser? _user;
  bool _initializing = true, _loading = false, _signingUp = false;
  String? _error;

  AppUser? get user => _user;
  bool get initializing => _initializing;
  bool get loading => _loading;
  String? get error => _error;

  AuthProvider() {
    _service.authChanges.listen(_onAuthChanged);
  }

  Future<void> _onAuthChanged(User? u) async {
    if (_signingUp) return; // signUp sets _user itself
    if (u == null) {
      _user = null;
    } else {
      _user = await _service.fetchUser(u.uid);
      if (_user == null) await _service.signOut();
    }
    _initializing = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true; _error = null; notifyListeners();
    try {
      await _service.signIn(email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _message(e.code);
      return false;
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _loading = true; _signingUp = true; _error = null; notifyListeners();
    try {
      _user = await _service.signUp(name, email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _message(e.code);
      return false;
    } finally {
      _signingUp = false; _loading = false; notifyListeners();
    }
  }

  Future<bool> updateName(String name) async {
    try {
      await _service.updateName(_user!.uid, name);
      _user = AppUser(
          uid: _user!.uid, name: name, email: _user!.email, role: _user!.role);
      notifyListeners();
      return true;
    } catch (_) {
      _error = 'Could not update your name.';
      return false;
    }
  }

  Future<void> signOut() => _service.signOut();

  String _message(String code) {
    switch (code) {
      case 'email-already-in-use': return 'That email is already registered.';
      case 'weak-password': return 'Password must be at least 6 characters.';
      case 'invalid-email': return 'Enter a valid email address.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential': return 'Incorrect email or password.';
      default: return 'Something went wrong. Try again.';
    }
  }
}