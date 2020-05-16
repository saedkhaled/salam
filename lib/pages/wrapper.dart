import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/pages/home.dart';
import 'package:salam/pages/login.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<FirebaseUser>(context);
    if (authUser == null) {
      return LogIn();
    } else {
      return Home(userUid: authUser.uid, email: authUser.email);
    }
  }
}
