import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salam/models/order.dart';

class MyOrder extends StatelessWidget {
  final Order order;

  const MyOrder({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fullNumber = order.getNumberKey().getCode() +
        '\n' +
        order.getNumberKey().getCode();
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Text(
                  'الخدمة: ' + order.getService().getTitle(),
                  style: TextStyle(fontSize: 35.0),
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Color(0xffeeeeee),
                      blurRadius: 1.0,
                      offset: Offset(1.0, 1.0),
                    ),
                  ]),
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                fullNumber,
                                style: TextStyle(fontSize: 25.0),
                                softWrap: true,
                              ),
                              IconButton(
                                  onPressed: () async {
                                    Clipboard.setData(
                                        ClipboardData(text: fullNumber));
                                    Fluttertoast.showToast(
                                        msg: "تم نسخ المحتوى",
                                        toastLength: Toast.LENGTH_SHORT);
                                  },
                                  icon: Icon(Icons.content_copy)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'التاريخ:' + order.getOrderDate(),
                  style: TextStyle(fontSize: 25.0),
                ),
                Text(
                  ' السعر:' + order.getService().getPrice().toString(),
                  style: TextStyle(fontSize: 25.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
