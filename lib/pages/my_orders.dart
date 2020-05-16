import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/lists/order_list.dart';
import 'package:salam/services/firestore.dart';

class MyOrders extends StatefulWidget {
  final String uid;

  MyOrders({Key key, this.uid}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  FireStoreService fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamProvider<Object>.value(
        value: fireStoreService.streamObject('/users/' + widget.uid, fireStoreService.userFromSnapshot),
        child: Scaffold(
          appBar: AppBar(
            title: Text('طلباتي'),
          ),
          body: OrderList(),
        ),
      ),
    );
  }
}