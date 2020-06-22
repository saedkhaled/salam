import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/order.dart';
import 'package:salam/models/user.dart';
import 'package:salam/pages/my_order.dart';

class OrderList extends StatefulWidget {
  OrderList({Key key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Order> _orderList;
  User _user;
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null) {
      _user = user;
      _orderList = _user.getOrderList();
      _orderList.sort((b, a) => a.getOrderDate().compareTo(b.getOrderDate()));
    }
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _orderList != null ? _orderList.length : 5,
        itemBuilder: (BuildContext eContext, int index) {
//          imageUrl = ' ';
//            print(_orderList[index].getService().getImageUrl());
//            FirebaseStorage.instance.ref().child(_orderList[index].getService().getImageUrl()).getDownloadURL().then((dynamic result) {
//              try {
//                if (mounted) {
//                  setState(() {
//                    imageUrl = Uri.parse(result).toString();
//                    print(imageUrl + 'saed');
//                  });
//                }
//              } catch (e){
//                print(e.toString());
//              }
//          });
          return InkWell(
            child: Column(
              children: <Widget>[
                ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20.0,
//                        child:Image(
//                          fit: BoxFit.cover,
//                          image:CachedNetworkImageProvider(imageUrl != null ? imageUrl : ""),
//                        ),
                      ),
                      Text(_orderList[index].getService().getTitle()),
                      Text(_orderList[index].getOrderDate().substring(
                          _orderList[index].getOrderDate().length - 5)),
                    ],
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 40.0, left: 40.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.content_copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: _orderList[index]
                                          .getNumberKey()
                                          .getNumber() +
                                      ' ' +
                                      _orderList[index]
                                          .getNumberKey()
                                          .getCode()));
                            },
                          ),
                          Icon(Icons.swap_horiz),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MyOrder(order: _orderList[index])));
                            },
                            icon: Icon(Icons.info_outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },

      ),
    );
  }
}