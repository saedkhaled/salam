import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String uid;

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      uid = user.uid;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Stream<FirebaseUser> get user {
    return _firebaseAuth.onAuthStateChanged;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
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
