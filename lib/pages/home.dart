import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:salam/app_keys.dart';
import 'package:salam/lists/category_list.dart';
import 'package:salam/models/service.dart';
import 'package:salam/models/serviceGroup.dart';
import 'package:salam/pages/my_drawer.dart';
import 'package:salam/services/firestore.dart';

class Home extends StatefulWidget {
  Home({
    Key key
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FireStoreService fireStoreService = FireStoreService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List<ServiceGroup>> _serviceGroups;

  @override
  void initState() {
    super.initState();
    // show a toast telling the user that he signed in successfully
    Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح!",
        toastLength: Toast.LENGTH_LONG);
    _serviceGroups = getServiceLists();
    // FirebaseFirestore.instance.collection('groups')
    //     .get().then((value) => handleResult(value));
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
      home: FutureBuilder(
        future: _serviceGroups,
        builder: (BuildContext context, AsyncSnapshot<List<ServiceGroup>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else {
            final items = snapshot.data ??
                List<ServiceGroup>(); // handle the case that data is null

            return Scaffold(
              appBar: GradientAppBar(
                  title: Center(
                      child: Text('SALAM+', style: TextStyle(fontSize: 25.0),)),
                  leading: Container(),
                  actions: [
                    InkWell(
                      child: Image.asset('assets/images/drawer.png',
                        width: 50.0,),
                      onTap: () => _scaffoldKey.currentState.openEndDrawer(),
                    ),
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 179, 77, 201),
                        Colors.blue[900]
                      ])
              ),
              key: _scaffoldKey,
              endDrawer: MyDrawer(),
              body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(255, 179, 77, 201)
                        ])
                ),
                child: Stack(
                  children: <Widget>[
                    RefreshIndicator(
                      onRefresh: refreshList,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child:
                        CategoryList(serviceLists: items),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> refreshList() async{
    // reload
    setState(() {
      _serviceGroups = getServiceLists();
    });
  }

  void handleResult(QuerySnapshot query) async{
    for(var doc in query.docs) {
      ServiceGroup group = ServiceGroup.fromMap(doc.data());
      for(Service service in group.getServices()) {
        service.setType(AppKeys.SMS_ACTIVATE);
    }
      FirebaseFirestore.instance.collection("groups").doc(group.getTitle()).update(group.toMap()).then((value) => print("group"));
    }
  }


  Future<List<ServiceGroup>> getServiceLists() async{
    List<ServiceGroup> serviceGroups = List();
    QuerySnapshot list = (await FirebaseFirestore.instance.collection('groups').get().then((value) {
      print(value.toString());
      return value;
    }));
    // print('response : ' +  list.docs.toString());
    for (QueryDocumentSnapshot documentSnapshot in list.docs) {
      serviceGroups.add(ServiceGroup.fromMap(documentSnapshot.data()));
    }
    return serviceGroups;
  }

}
