import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import '../models/app_user.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();

  Future<AppUser> signUp(String name, String email, String password) async {
    if (roleForEmail(email) == null) {
      throw FirebaseAuthException(code: 'invalid-domain');
    }
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = cred.user!;
    await user.updateDisplayName(name);
    await _db.collection('users').doc(user.uid).set({
      'name': name,
      'email': email,
      'role': 'student', // staff are promoted manually
      'createdAt': FieldValue.serverTimestamp(),
    });
    return AppUser(uid: user.uid, name: name, email: email, role: 'student');
  }

  Future<void> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _auth.signOut();

  Future<AppUser?> fetchUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }

  Future<void> updateName(String uid, String name) async {
    await _db.collection('users').doc(uid).update({'name': name});
    await _auth.currentUser?.updateDisplayName(name);
  }
}