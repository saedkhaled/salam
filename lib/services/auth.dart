import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  String uid;

  Future<auth.User> signIn(String email, String password) async {
    try {
      auth.UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      auth.User user = result.user;
      uid = user.uid;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Stream<auth.User> get user {
    return _firebaseAuth.authStateChanges();
  }

  Future<auth.User> getCurrentUser() async {
    auth.User user = _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    try {
      return _firebaseAuth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}
