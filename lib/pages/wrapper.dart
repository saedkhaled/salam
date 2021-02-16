import 'package:flutter/material.dart';
import 'package:salam/pages/home.dart';
import 'package:salam/pages/login.dart';
import 'package:salam/services/shared_prefs.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!sharedPrefs.isLoggedIn ?? false) {
      return LogIn();
    } else {
      return Home();
    }
  }
}
