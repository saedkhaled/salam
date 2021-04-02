import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/user.dart';
import 'package:salam/pages/my_agents.dart';
import 'package:salam/pages/my_orders.dart';
import 'package:salam/pages/my_wallet.dart';
import 'package:salam/services/auth.dart';
import 'package:salam/services/shared_prefs.dart';
class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Future<User> _user;
  final AuthService authService = AuthService();


  @override
  void initState() {
    super.initState();
    _user = getUser();
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<Object>(context);
    // if (user != null) {
    //   _user = user;
    // }
    return Drawer(
      child: FutureBuilder(
          future: _user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

      if (snapshot.connectionState == ConnectionState.waiting) {
        return new Center(
          child: new CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return new Text('Error: ${snapshot.error}');
      } else {
        final user = snapshot.data ??
            User(); // handle the case that data is null
        return ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user.getUserName()),
              accountEmail: Text(user.getEmail()),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  user.getName().substring(0, 2),
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              onTap: () =>
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MyOrders(uid: user.getUserUid()))),
              title: Text('طلباتي'),
              leading: Icon(
                Icons.playlist_play,
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () =>
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MyWallet(uid: user.getUserUid()))),
              title: Text('محفظتي'),
              leading: Icon(
                Icons.account_balance_wallet,
                size: 30.0,
              ),
            ),
            // ListTile(
            //   onTap: () =>
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder: (BuildContext context) =>
            //               MyAgents(uid: user.getUserUid()))),
            //   title: Text('عملائي'),
            //   leading: Icon(
            //     Icons.supervised_user_circle,
            //     size: 30.0,
            //   ),
            // ),
            ListTile(
              onTap: () => authService.signOut(),
              title: Text('تسجيل الخروج'),
              leading: Icon(
                Icons.person,
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () =>
                  showDialog(context: context, builder: (bContext) {
                    return AlertDialog(content: Text(
                        '            +تطبيق السلام      \n للارقام و الخدمات الافتراضية \n        اصدار التطبيق: 1.0.0',
                        style: TextStyle(fontSize: 20.0)));
                  }),
              title: Text('حول البرنامج'),
              leading: Icon(
                Icons.info,
                size: 30.0,
              ),
            ),
            ListTile(
              title: Text(
                'المبلغ الحالي ' + '\n' +
                    snapshot.data.getCurrentBalance().toStringAsFixed(2) +
                    ' \$',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      }
        }
      ),
    );
  }

  Future<User> getUser() async{
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(sharedPrefs.userUid).get();
    // print('response : ' +  list.docs.toString());
    User user = User.fromMap(doc.data());
    return user;
  }

}
