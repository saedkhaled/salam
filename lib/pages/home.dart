import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:salam/lists/category_list.dart';
import 'package:salam/pages/my_drawer.dart';
import 'package:salam/services/firestore.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
    this.userUid,
    this.email,
  }) : super(key: key);

  final String userUid;
  final String email;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FireStoreService fireStoreService = FireStoreService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // show a toast telling the user that he signed in successfully
    Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح!",
        toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Color.fromARGB(255,111, 63, 252),

          // Define the default font family.
          fontFamily: 'Georgia',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          ),
      home: StreamProvider.value(
        value: fireStoreService.streamObject('/users/' + widget.userUid, fireStoreService.userFromSnapshot),
        child: Scaffold(
          appBar: GradientAppBar(
            title: Center(child: Text('SALAM+',style: TextStyle(fontSize: 25.0),)),
            leading: Container(),
            actions: [
              InkWell(
                child: Image.asset('assets/images/drawer.png',
                width: 50.0,),
                onTap:() => _scaffoldKey.currentState.openEndDrawer(),
              ),
              ],
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color.fromARGB(255, 179, 77, 201),Colors.blue[900]])
          ),
          key: _scaffoldKey,
          endDrawer: MyDrawer(),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color.fromARGB(255, 255, 255, 255),Color.fromARGB(255, 179, 77, 201)])
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: CategoryList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
