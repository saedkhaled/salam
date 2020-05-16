import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/order.dart';
import 'package:salam/models/user.dart';
class OrderList extends StatefulWidget {
  OrderList({Key key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Order> _orderList;
  User _user;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null) {
      _user = user;
      _orderList = _user.getOrderList();
    }
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _orderList != null ? _orderList.length : 5,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap:() {},
                  title: Text(_orderList[index].getNumberKey().getNumber() + ' ' + _orderList[index].getNumberKey().getCode()),
                  trailing: Text(_orderList[index].getOrderDate()),
                  leading: IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _orderList[index].getNumberKey().getNumber() + ' ' + _orderList[index].getNumberKey().getCode()));
                        Fluttertoast.showToast(msg: "تم نسخ المحتوى",
                            toastLength: Toast.LENGTH_SHORT);
                      },
                      icon: Icon(Icons.content_copy)),
                ),
                Divider(
                  color: Colors.black,
                ),
              ],
            ),
          );
        },

      ),
    );
  }
}