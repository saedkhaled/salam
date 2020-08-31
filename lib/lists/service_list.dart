import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/movement.dart';
import 'package:salam/models/numberKey.dart';
import 'package:salam/models/order.dart';
import 'package:salam/models/user.dart';
import 'package:salam/pages/loading.dart';
import 'package:salam/pages/service_card.dart';
import 'package:salam/services/firestore.dart';
import 'package:http/http.dart' as http;

class ServiceList extends StatefulWidget {
  final int groupIndex;

  ServiceList({Key key, this.groupIndex}) : super(key: key);

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  User _user;
  FireStoreService fireStoreService = FireStoreService();
  String fullNumber = '';
  BuildContext codeContext;
  bool isLoading = true;
  bool isDisabled = false;
  int availableNumbers = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null) _user = user;
    final listView = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _user != null
          ? _user.getServiceGroups()[widget.groupIndex].getServices().length
          : 7,
      itemBuilder: (BuildContext context, int index) {

        return InkWell(
          onTap: () {
            if (_user.getCurrentBalance() >=
                _user
                    .getServiceGroups()[widget.groupIndex]
                    .getServices()[index]
                    .getPrice()) {
              isDisabled = false;
              showDialog(
                  context: context,
                  builder: (BuildContext bContext) {
                    return StatefulBuilder(
                        builder: (context, setMainAlertState) {
                          String apiKey = '';
                          FirebaseFirestore.instance.collection('other')
                              .doc('apiKey').get().then((
                              snapshot) async{
                            apiKey = snapshot.data()["apiKey"];
                            String numberPath = _user
                                .getServiceGroups()[widget.groupIndex]
                                .getServices()[index]
                                .getKeyPath();
                            String serviceString = numberPath.substring(
                                3);
                            String availableNumbersString = (await http
                                    .get(
                                'https://sms-activate.ru/stubs/handler_api.php?api_key=$apiKey&action=getNumbersStatus&country=$serviceString'))
                            .body;
                            String groupString = numberPath.substring(
                                0, 2);
                            int serviceStart = availableNumbersString
                                .indexOf('$groupString' + '_0');
                            setMainAlertState((){
                              availableNumbers = int.parse(
                                  availableNumbersString.substring(
                                      availableNumbersString.indexOf(
                                          ':', serviceStart) + 3,
                                      availableNumbersString.indexOf(
                                          ',', serviceStart) - 1
                                  ));
                              print('availbe numers: ' + availableNumbers.toString());
                            });
                          });
                          return AlertDialog(
                            title: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                children: [
                                  Text(availableNumbers.toString() + ' :الأرقام المتوفرة', style: TextStyle(fontSize: 12.0),),
                                  Text('عملية الشراء'),
                                ],
                              ),
                              alignment: Alignment.centerRight,
                              height: 30.0,
                            ),
                            content: Container(
                              child: Text('هل تريد تأكيد عملية الشراء؟'),
                              alignment: Alignment.centerRight,
                              height: 30.0,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: isDisabled ? null : () async {
                                    setState(() {
                                      isDisabled = true;
                                    });
                                    fullNumber = '';
                                    apiKey =
                                    await FirebaseFirestore.instance.collection('other')
                                        .doc('apiKey').get().then((
                                        snapshot) {
                                      return snapshot.data()["apiKey"];
                                    });
//                                    print(apiKey);
                                    String numberPath = _user
                                        .getServiceGroups()[widget.groupIndex]
                                        .getServices()[index]
                                        .getKeyPath();
                                    String groupString = numberPath.substring(
                                        0, 2);
                                    String serviceString = numberPath.substring(
                                        3);
                                    String availableNumbersString = (await http
                                        .get(
                                        'https://sms-activate.ru/stubs/handler_api.php?api_key=$apiKey&action=getNumbersStatus&country=$serviceString'))
                                        .body;
//                                    print(availableNumbersString);
                                    String currentBalance = (await http.get(
                                        'https://sms-activate.ru/stubs/handler_api.php?api_key=$apiKey&action=getBalance'))
                                        .body;
                                    String priceString = (await http.get(
                                        'https://sms-activate.ru/stubs/handler_api.php?api_key=$apiKey&action=getPrices&service=$groupString&country=$serviceString'))
                                        .body;

//                                    print(currentBalance);
//                                    print(priceString);
                                    int serviceStart = availableNumbersString
                                        .indexOf('$groupString' + '_0');
                                    availableNumbers = int.parse(
                                        availableNumbersString.substring(
                                            availableNumbersString.indexOf(
                                                ':', serviceStart) + 3,
                                            availableNumbersString.indexOf(
                                                ',', serviceStart) - 1
                                        ));
                                    double balance = double.parse(currentBalance
                                        .substring(
                                        currentBalance.indexOf(':') + 1));
                                    double price = double.parse(priceString
                                        .substring(
                                        priceString.indexOf('cost') + 6,
                                        priceString.indexOf(',')
                                    ));
//                                    print('saed $price');
//                                    print(groupString);
//                                    print(serviceString);
                                    if (balance != null &&
                                        balance > price &&
                                        availableNumbers > 0) {
                                      String numberResponse = (await http.get(
                                          'https://sms-activate.ru/stubs/handler_api.php?api_key=$apiKey&action=getNumber&service=$groupString&country=$serviceString'))
                                          .body;
//                                      print(numberResponse);
                                      String id = numberResponse.substring(
                                          numberResponse.indexOf(':') + 1,
                                          numberResponse.indexOf(':', 15));
                                      String numberString = numberResponse
                                          .substring(
                                          numberResponse.indexOf(':', 15) + 1);
//                                      print(id);
//                                      print(numberString);
                                      fullNumber = numberString;
                                      Function alertSetState;
                                      isLoading = true;
                                      if (fullNumber != '') {
                                        Navigator.of(bContext).pop();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext cContext) {
                                              return StatefulBuilder(
                                                builder: (cContext, setState) {
                                                  alertSetState = setState;
                                                  codeContext = cContext;
                                                  return WillPopScope(
                                                    onWillPop: () async {
//                                                      print(await http.get(
//                                                          'https://sms-activate.ru/stubs/handler_api.php?api_key=$apiKey&action=setStatus&status=8&id=$id'));
                                                      return true;
                                                    },
                                                    child: AlertDialog(
                                                      title: Center(
                                                          child: Text('الكود')),
                                                      content: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                        0xffeeeeee),
                                                                    blurRadius: 1.0,
                                                                    offset: Offset(
                                                                        1.0,
                                                                        1.0),
                                                                  ),
                                                                ]),
                                                            child: Card(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      fullNumber,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          15.0),
                                                                    ),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          Clipboard
                                                                              .setData(
                                                                              ClipboardData(
                                                                                  text:
                                                                                  fullNumber));
                                                                          Fluttertoast
                                                                              .showToast(
                                                                              msg:
                                                                              "تم نسخ المحتوى",
                                                                              toastLength:
                                                                              Toast
                                                                                  .LENGTH_SHORT);
                                                                        },
                                                                        icon: Icon(
                                                                            Icons
                                                                                .content_copy)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          isLoading
                                                              ? Row(
                                                            children: <Widget>[
                                                              Loading(),
                                                              Text(
                                                                  'يرجى انتظار وصول الكود'),
                                                            ],
                                                          )
                                                              : Text(
                                                              'لقد تمت عملية الشراء بنجاح!'
                                                          ),
                                                          CountdownFormatted(
                                                            duration: Duration(minutes: 5),
                                                            onFinish: () {
//                                                              print('finished!');
                                                            },
                                                            builder: (ctx,duration) {
                                                              return Text(duration,
                                                              style: TextStyle(color: Colors.black,fontSize: 20.0),);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            });
                                        int counter = 0;
                                        int timerCounter = 0;
                                        new Timer.periodic(
                                            const Duration(seconds: 1),
                                                (Timer t) async {
//                                              print('waiting!');
                                              counter++;
                                              if (counter >= 300) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
                                                    toastLength: Toast
                                                        .LENGTH_SHORT);
//                                                print('closed');
                                                t.cancel();
//                                                print(await http.get(
//                                                    'https://sms-activate.ru/stubs/handler_api.php?api_key=$apiKey&action=setStatus&status=8&id=$id'));
                                                Navigator.of(codeContext).pop();
                                              }
                                              String statue = (await http.get(
                                                  'https://sms-activate.ru/stubs/handler_api.php?api_key=$apiKey&action=getStatus&id=$id'))
                                                  .body;
//                                              print(statue);
//                                              print(timerCounter);
                                              if (
                                              statue.contains(
                                                  'STATUS_OK') &&
                                                  timerCounter == 0
                                              ) {
                                                timerCounter++;
                                                String code = statue
                                                    .substring(
                                                    statue.indexOf(':') + 1);
                                                if (mounted)
                                                  alertSetState(() {
                                                    isLoading = false;
                                                    fullNumber += '\n' + code;
                                                  });
                                                Order order = Order(
                                                    orderStatue: false,
                                                    service: _user
                                                        .getServiceGroups()[
                                                    widget.groupIndex]
                                                        .getServices()[index],
                                                    numberKey: new NumberKey(
                                                        number: numberString,
                                                        code: code,
                                                        isUsed: true));
                                                if (_user.getOrderList() ==
                                                    null)
                                                  _user
                                                      .setOrderList(
                                                      new List<Order>());
                                                _user
                                                    .getOrderList()
                                                    .add(order);
                                                _user
                                                    .getMovements()
                                                    .add(order.getMovement());
                                                _user
                                                    .setCurrentBalance(
                                                    _user
                                                        .getCurrentBalance() -
                                                        _user
                                                            .getServiceGroups()[widget.groupIndex]
                                                            .getServices()[index]
                                                            .getPrice());
                                                distributeProfit(price, index);
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(
                                                    _user.getUserUid())
                                                    .update({
                                                  'orders': List<dynamic>.from(
                                                      _user
                                                          .getOrderList()
                                                          .map((x) =>
                                                          x.toMap())),
                                                  'movements': List<
                                                      dynamic>.from(_user
                                                      .getMovements()
                                                      .map((x) => x.toMap())),
                                                  'currentBalance':
                                                  _user.getCurrentBalance(),
                                                }).then((value) {
                                                  print(
                                                      "updating user info is successful!");
                                                }).catchError((onError) {
                                                  print(
                                                      "updating user info failed!!" +
                                                          onError.toString());
                                                });
                                                print(code);
                                                t.cancel();
                                              } else if (statue
                                                  .contains(
                                                  'STATUS_WAIT_CODE')) {} else {
                                                print(
                                                    'error getting the number!!!');
                                                t.cancel();
                                              }
                                            });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                            "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
                                            toastLength: Toast.LENGTH_SHORT);
                                        Navigator.of(bContext).pop();
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                          "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
                                          toastLength: Toast.LENGTH_SHORT);
                                      Navigator.of(bContext).pop();
                                    }
                                  },
                                  child: Container(child: Text('تأكيد'))),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(bContext).pop();
                                  },
                                  child: Text('إلغاء')),
                            ],
                          );
                        }
                    );
                  });
            } else {
              Fluttertoast.showToast(
                  msg: "ليس لديك رصيد كافي لاتمام العملية!!",
                  toastLength: Toast.LENGTH_LONG);
            }
          },
          child: ServiceCard(
            groupIndex: widget.groupIndex,
            serviceIndex: index,
          ),
        );
      },
    );

    return Container(
      padding: EdgeInsets.only(bottom: 20.0, right: 4.0, left: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.elliptical(100.0, 10.0),
                topLeft: Radius.elliptical(100.0, 10.0)),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                child: Text(
                  _user != null
                      ? _user
                          .getServiceGroups()[widget.groupIndex]
                          .getTitle()
                          .toUpperCase()
                      : 'getting info',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 250,
            child: listView,
          ),
        ],
      ),
    );
  }

  void distributeProfit (double price, int index) async {
    User user = _user;
    double rubPrice = await apiGetRubPrice();
    price = (price / rubPrice)*1.07;
//    print(price);
    while (user.getUserUid() != user.getParentUid()){
      User parent = await FirebaseFirestore.instance.collection('users').doc(user.getParentUid()).get().then(
              (value) {
                return User.fromMap(value.data());
              });
      parent.setCurrentBalance(
          parent.getCurrentBalance() +(user.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice() - parent.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice()));
      parent.getMovements().add(new Movement(description:"ربح من العميل", amount:user.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice() - parent.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice(), date: null, id:null));
      FirebaseFirestore.instance.collection('users').doc(parent.getUserUid()).update({
        'currentBalance':
            parent.getCurrentBalance(),
        'movements':
        List<dynamic>.from(parent.getMovements().map((x) => x.toMap())),
      }).then((value) => print('profit distributed to parent ' + parent.getUserName())).catchError((onError){
        print('Error uploading info to '+ parent.getUserName() + ' ' + onError.toString());
      });
      user = parent;
    }
    double profit = user.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice() - price;
    FirebaseFirestore.instance.collection('other').doc('profit').get().then((value) {
      double amount = value.data()['amount'];
      FirebaseFirestore.instance.collection('other').doc('profit').update({
        'amount':
            amount+profit,
      });
    });
  }

  Future<double> apiGetRubPrice () async {
    String response = (await http.get(
        'https://api.exchangeratesapi.io/latest?base=USD&symbols=RUB')).body;
//    print(response);
    String stringPrice = response.substring(response.indexOf('RUB')+5,response.indexOf('}',20));
//    print(stringPrice);
    double price = double.parse(stringPrice);
    return price;
  }
}
