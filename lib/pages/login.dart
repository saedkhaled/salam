import 'package:flutter/material.dart';
import 'package:salam/pages/loading.dart';
import 'package:salam/services/shared_prefs.dart';

import '../services/auth.dart';
import 'home.dart';

class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  dynamic _user;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 200.0,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    final email = TextFormField(
      validator: (value) => value.isEmpty ? 'يرجى ادخال البريد الالكتروني' : null,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onChanged: (String value){
        setState(() => _email = value);
        },
      decoration: InputDecoration(
        hintText: 'البريد الالكتروني',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      validator: (value) => value.isEmpty ? 'يرجى ادخال كبمة المرور' : null,
      autofocus: false,
      obscureText: true,
      onChanged: (String value){
        setState(() => _password = value);
        },
      decoration: InputDecoration(
        hintText: 'كلمة المرور',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          if (formKey.currentState.validate()) {
            setState(() => loading = true);
            _user = await auth.signIn(_email, _password);
            if (_user != null) {
              String uid = auth.uid;
              print('Signed in: $uid');
              sharedPrefs.isLoggedIn = true;
              sharedPrefs.userUid = uid;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
            } else {
              setState(() => loading = false);
              print("error singing in!");
            }
          }
        },
        padding: EdgeInsets.all(12),
        color: Color.fromARGB(255,185, 41, 255),
        child: Text('تسجيل الدخول', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'هل نسيت كلمة المرور؟',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              Center(
                child: Text("SALAM+",
                  style: TextStyle(
                    color: Color.fromARGB(255,185, 41, 255),
                    fontWeight: FontWeight.bold,
                    fontFamily: "",
                    fontSize: 50.0,
                  ),
                ),
              ),
              logo,
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              SizedBox(height: 8.0),
              loading ? Loading() : Container(),
              forgotLabel
            ],
          ),
        ),
      ),
    );
  }
}
