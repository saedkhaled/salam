import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
          key: _scaffoldKey,
          endDrawer: MyDrawer(),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color.fromARGB(255, 208, 196, 232),Color.fromARGB(255, 179, 77, 201)])
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: CategoryList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("تطبيقنا ما زال قيد التجريب! شكرا لكم لتعاونكم معنا",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 60.0,
                    padding:const EdgeInsets.only(right:10.0, top: 25.0),
                    child: FloatingActionButton(
                      backgroundColor: Color.fromARGB(255,185, 41, 255),
                      onPressed:() {
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                      child: Icon(Icons.menu),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
