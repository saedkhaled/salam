import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/lists/movement_list.dart';
import 'package:salam/models/user.dart';
import 'package:salam/services/firestore.dart';

class MyWallet extends StatefulWidget {
  final String uid;
  MyWallet({Key key, this.uid}) : super(key: key);

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  FireStoreService fireStoreService = FireStoreService();
  User _user;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Object>.value(
      value: fireStoreService.streamObject('/users/' + widget.uid,
          fireStoreService.userFromSnapshot),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('My Wallet'),
          ),
          body: Consumer<Object>(
            builder: (BuildContext context, user, Widget child) {
              if (user != null) {
                _user = user;
              }
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "Current Balance: " +
                        _user.getCurrentBalance().toString() +
                        " \$",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Gained Profit from Agents: " +
                        calculateGainedProfitFromAgents() +
                        " \$",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Total Outcome: " + calculateExpenses() + " \$",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  MovementList(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String calculateGainedProfitFromAgents() {
    double totalProfit = 0;
    if (_user != null) {
      for (int i = 0; i < _user.getMovements().length; i++) {
        if (_user.getMovements()[i].getDescription() ==
            "Profit from an Agent") {
          totalProfit += _user.getMovements()[i].getAmount();
        }
      }
    }
    return totalProfit.toString();
  }

  String calculateExpenses() {
    double totalExpense = 0;
    if (_user != null) {
      for (int i = 0; i < _user.getMovements().length; i++) {
        if (_user.getMovements()[i].getAmount() < 0) {
          totalExpense += (-1 * _user.getMovements()[i].getAmount());
        }
      }
    }
    return totalExpense.toString();
  }
}
