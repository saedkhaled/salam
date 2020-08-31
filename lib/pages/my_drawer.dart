import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/user.dart';
import 'package:salam/pages/my_agents.dart';
import 'package:salam/pages/my_orders.dart';
import 'package:salam/pages/my_wallet.dart';
import 'package:salam/services/auth.dart';
class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  User _user;
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null) {
      _user = user;
    }
    return Drawer(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_user.getUserName()),
            accountEmail: Text(_user.getEmail()),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                _user.getName().substring(0, 2),
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    MyOrders(uid: _user.getUserUid()))),
            title: Text('طلباتي'),
            leading: Icon(
              Icons.playlist_play,
              size: 30.0,
            ),
          ),
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    MyWallet(uid: _user.getUserUid()))),
            title: Text('محفظتي'),
            leading: Icon(
              Icons.account_balance_wallet,
              size: 30.0,
            ),
          ),
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    MyAgents(uid: _user.getUserUid()))),
            title: Text('عملائي'),
            leading: Icon(
              Icons.supervised_user_circle,
              size: 30.0,
            ),
          ),
          ListTile(
            onTap: () => authService.signOut(),
            title: Text('تسجيل الخروج'),
            leading: Icon(
              Icons.person,
              size: 30.0,
            ),
          ),
          ListTile(
            onTap: () => showDialog(context: context, builder: (bContext) {
              return AlertDialog(content:Text('            +تطبيق السلام      \n للارقام و الخدمات الافتراضية \n        اصدار التطبيق: 1.0.0', style:TextStyle(fontSize: 20.0)));
            } ),
            title: Text('حول البرنامج'),
            leading: Icon(
              Icons.info,
              size: 30.0,
            ),
          ),
          ListTile(
            title: Text(
              'المبلغ الحالي ' + '\n' +
                  _user.getCurrentBalance().toStringAsFixed(2) +
                  ' \$',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
