import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salam/app_keys.dart';
import 'package:salam/models/keyGroup.dart';
import 'package:salam/models/numberKey.dart';
import 'package:salam/models/order.dart';
import 'package:salam/models/service.dart';
import 'package:salam/models/serviceGroup.dart';
import 'package:salam/models/serviceInfoList.dart';
import 'package:salam/models/user.dart';
import 'package:salam/pages/loading.dart';
import 'package:salam/pages/service_card.dart';
import 'package:salam/services/api_controller.dart';
import 'package:salam/services/shared_prefs.dart';
import 'package:salam/widgets/app_loader.dart';

class ServiceList extends StatefulWidget {
  final ServiceGroup serviceGroup;

  ServiceList({Key key, this.serviceGroup}) : super(key: key);

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  Future<User> _user;
  String _apiKey = "";
  String _5simApiKey = "";
  String fullNumber = '';
  BuildContext codeContext;
  bool isLoading = true;
  bool isDisabled = false;
  int _availableNumbers = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int notificationCounter = 0;


  @override
  void initState() {
    super.initState();
    _user = getUser();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(new InitializationSettings(android: AndroidInitializationSettings('app_icon')));
  }

  void showNotification({
    String title,
    String body,
  }) async{

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        '1',
        'Alsalam +',
        'app',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(notificationCounter++, title, body, platformChannelSpecifics, payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {

    // final user = Provider.of<Object>(context);
    // if (user != null) _user = user;
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
                  widget.serviceGroup.getTitle().toUpperCase(),
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
            child: buildList(),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return FutureBuilder(
        future: _user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else {
            final user =
                snapshot.data ?? User(); // handle the case that data is null
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.serviceGroup.getServices().length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    openDialog(index, user);
                  },
                  child: ServiceCard(
                    service: widget.serviceGroup.getServices()[index],
                  ),
                );
              },
            );
          }
        });
  }

  BuildContext _loadingDialogContext;
  void showLoaderDialog() {
    showDialog(context: context, builder: (bContext) {
      _loadingDialogContext = bContext;
      return AlertDialog(
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLoader(),
              Text('جاري التحميل')
            ],
          ),
        ),
      );
    });
  }
  void openDialog(int index, User user) async {
    Service service = widget.serviceGroup.getServices()[index];
    showLoaderDialog();
    if(service.type == AppKeys.SMS_ACTIVATE) {
      String numberPath = service.getKeyPath();
      String serviceString = numberPath.substring(3);
      String availableNumbersString = await ApiController.get(
          'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=getNumbersStatus&country=$serviceString');
      String groupString = numberPath.substring(0, 2);
      String priceString = await ApiController.get(
          'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=getPrices&service=$groupString&country=$serviceString');
      double price = double.parse(priceString.substring(
          priceString.indexOf('cost') + 6, priceString.indexOf(',')));
      double rubPrice = await apiGetRubPrice();
      price = (price / rubPrice)*1.07 + user.getPrice();
      if (user.getCurrentBalance() >=
          price) {
        isDisabled = false;
        Navigator.pop(_loadingDialogContext);
        showDialog(
            context: context,
            builder: (BuildContext bContext) {
              return StatefulBuilder(builder: (context, setMainAlertState) {
                int serviceStart =
                availableNumbersString.indexOf('$groupString' + '_0');
                setMainAlertState(() {
                  _availableNumbers = int.parse(availableNumbersString.substring(
                      availableNumbersString.indexOf(':', serviceStart) + 3,
                      availableNumbersString.indexOf(',', serviceStart) - 1));
                  print('available numbers: ' + _availableNumbers.toString());
                });
                return AlertDialog(
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _availableNumbers.toString() + ' :الأرقام المتوفرة',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        Text('عملية الشراء'),
                      ],
                    ),
                    alignment: Alignment.centerRight,
                    height: 30.0,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text('هل تريد تأكيد عملية الشراء؟'),
                        alignment: Alignment.centerRight,
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          Text('السعر'),
                          Text(price.toStringAsFixed(3) + ' \$')
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    RaisedButton(
                        color: Color.fromARGB(255, 179, 77, 201),
                        onPressed: isDisabled
                            ? null
                            : () => buyNumber(
                            index, availableNumbersString, bContext, user, price),
                        child: Container(child: Text('تأكيد'))
                    ),
                    RaisedButton(
                        color: Color.fromARGB(255, 179, 77, 201),
                        onPressed: () {
                          Navigator.of(bContext).pop();
                        },
                        child: Text('إلغاء')),
                  ],
                );
              });
            });
      } else {
        Fluttertoast.showToast(
            msg: "ليس لديك رصيد كافي لاتمام العملية!!",
            toastLength: Toast.LENGTH_LONG);
      }
    } else if (service.type == AppKeys.SIM_5) {
      String numberPath = service.getKeyPath();
      String serviceString = numberPath.substring(3,4);
      String groupString = numberPath.substring(0,2);
      String availableNumbersString = await ApiController.get(
          'http://api1.5sim.net/stubs/handler_api.php?api_key=$_5simApiKey&action=getNumbersStatus&country=$serviceString');
      String countryString = numberPath.substring(numberPath.indexOf(' ', 3)+1);
      ServiceInfoList serviceInfoList = ServiceInfoList.fromJson(await ApiController.get(
          'https://5sim.net/v1/guest/products/$countryString/any'), groupString);
      double price = serviceInfoList.serviceInfo.price * 1.0;
      double rubPrice = await apiGetRubPrice();
      price = (price / rubPrice)*1.07 + user.getPrice();
      isDisabled = false;
      Navigator.pop(_loadingDialogContext);
      showDialog(
            context: context,
            builder: (BuildContext bContext) {
              return StatefulBuilder(builder: (context, setMainAlertState) {
                setMainAlertState(() {
                  _availableNumbers = serviceInfoList.serviceInfo.qty;
                  print('available numbers: ' + _availableNumbers.toString());
                });
                return AlertDialog(
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _availableNumbers.toString() + ' :الأرقام المتوفرة',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        Text('عملية الشراء'),
                      ],
                    ),
                    alignment: Alignment.centerRight,
                    height: 30.0,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text('هل تريد تأكيد عملية الشراء؟'),
                        alignment: Alignment.centerRight,
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          Text('السعر'),
                          Text(price.toStringAsFixed(3) + ' \$')
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    RaisedButton(
                        color: Color.fromARGB(255, 179, 77, 201),
                        onPressed: isDisabled
                            ? null
                            : () => buy5SimNumber(
                            index, availableNumbersString, bContext, user, price),
                        child: Container(child: Text('تأكيد'))
                    ),
                    RaisedButton(
                        color: Color.fromARGB(255, 179, 77, 201),
                        onPressed: () {
                          Navigator.of(bContext).pop();
                        },
                        child: Text('إلغاء')),
                  ],
                );
              });
            });
    } else if (service.type == AppKeys.READY) {
      QuerySnapshot query = await FirebaseFirestore.instance.collection('keys').where('id', isEqualTo: service.getId()).get();
      KeyGroup group = KeyGroup.fromMap((query).docs[0].data());

      if (user.getCurrentBalance() >=
          service.price) {
        isDisabled = false;
        Navigator.pop(_loadingDialogContext);
        showDialog(
            context: context,
            builder: (BuildContext bContext) {
              return StatefulBuilder(builder: (context, setMainAlertState) {
                int availableNumbers = 0;
                setMainAlertState(() {
                  availableNumbers = group.getCodes().length;
                  print('available numbers: ' + availableNumbers.toString());
                });
                return AlertDialog(
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          availableNumbers.toString() + ' :الأرقام المتوفرة',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        Text('عملية الشراء'),
                      ],
                    ),
                    alignment: Alignment.centerRight,
                    height: 30.0,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text('هل تريد تأكيد عملية الشراء؟'),
                        alignment: Alignment.centerRight,
                        height: 30.0,
                      ),
                      Row(
                        children: [
                          Text('السعر'),
                          Text(service.price.toStringAsFixed(3) + ' \$')
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    RaisedButton(
                        color: Color.fromARGB(255, 179, 77, 201),
                        onPressed: isDisabled
                            ? null
                            : () => buyReadyNumber(
                            index, bContext, user, service, group, query.docs[0].id),
                        child: Container(child: Text('تأكيد'))
                    ),
                    RaisedButton(
                        color: Color.fromARGB(255, 179, 77, 201),
                        onPressed: () {
                          Navigator.of(bContext).pop();
                        },
                        child: Text('إلغاء')),
                  ],
                );
              });
            });
      } else {
        Fluttertoast.showToast(
            msg: "ليس لديك رصيد كافي لاتمام العملية!!",
            toastLength: Toast.LENGTH_LONG);
      }
    } else {

    }
  }

  void buyNumber(int index, String availableNumbersString,
      BuildContext bContext, User user, double price) async {
    showLoaderDialog();
    setState(() {
      isDisabled = true;
    });
    fullNumber = '';
//                                    print(apiKey);
    String numberPath = widget.serviceGroup.getServices()[index].getKeyPath();
    String groupString = numberPath.substring(0, 2);
    String serviceString = numberPath.substring(3);
    // String availableNumbersString = (await http
    //     .get(
    //     'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=getNumbersStatus&country=$serviceString'))
    //     .body;
//                                    print(availableNumbersString);
    String currentBalance = await ApiController.get(
        'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=getBalance');
//                                    print(currentBalance);
//                                    print(priceString);
    int serviceStart = availableNumbersString.indexOf('$groupString' + '_0');
    _availableNumbers = int.parse(availableNumbersString.substring(
        availableNumbersString.indexOf(':', serviceStart) + 3,
        availableNumbersString.indexOf(',', serviceStart) - 1));
    double balance =
        double.parse(currentBalance.substring(currentBalance.indexOf(':') + 1));
//                                    print('saed $price');
//                                    print(groupString);
//                                    print(serviceString);
    if (balance != null && balance > price && _availableNumbers > 0) {
      String numberResponse = await ApiController.get(
          'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=getNumber&service=$groupString&country=$serviceString');
//                                      print(numberResponse);
      String id = numberResponse.substring(
          numberResponse.indexOf(':') + 1, numberResponse.indexOf(':', 15));
      String numberString =
          numberResponse.substring(numberResponse.indexOf(':', 15) + 1);
//                                      print(id);
//                                      print(numberString);
      fullNumber = numberString;
      Function alertSetState;
      isLoading = true;
      if (fullNumber != '') {
        int counter = 0;
        int timerCounter = 0;
        Timer timer;
        Order order;
        Navigator.of(bContext).pop();
        Navigator.pop(_loadingDialogContext);
        showDialog(
            context: context,
            builder: (BuildContext cContext) {
              return StatefulBuilder(
                builder: (cContext, setState) {
                  alertSetState = setState;
                  codeContext = cContext;
                  return WillPopScope(
                    onWillPop: () async {
                      int status =8;
                      print('closing dialog');
                      timer.cancel();
                      if (order != null) {
                        if (user.getOrderList() == null)
                          user.setOrderList(new List<Order>());
                        user.getOrderList().add(order);
                        user.getMovements().add(order.getMovement());
                        user.setCurrentBalance(user.getCurrentBalance() -
                            price);
                        // distributeProfit(price, index, user);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.getUserUid())
                            .update({
                          'orders': List<dynamic>.from(
                              user.getOrderList().map((x) => x.toMap())),
                          'movements': List<dynamic>.from(
                              user.getMovements().map((x) => x.toMap())),
                          'currentBalance': user.getCurrentBalance(),
                        }).then((value) {
                          print("updating user info is successful!");
                        }).catchError((onError) {
                          print("updating user info failed!!" +
                              onError.toString());
                        });
                        status = 6;
                      }
                      print(await ApiController.get(
                          'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=setStatus&status=$status&id=$id'));
                      return true;
                    },
                    child: AlertDialog(
                      title: Center(child: Text('الكود')),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Color(0xffeeeeee),
                                blurRadius: 1.0,
                                offset: Offset(1.0, 1.0),
                              ),
                            ]),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          fullNumber,
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              Clipboard.setData(ClipboardData(
                                                  text: fullNumber));
                                              Fluttertoast.showToast(
                                                  msg: "تم نسخ المحتوى",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                            },
                                            icon: Icon(Icons.content_copy)
                                        ),
                                      ],
                                    ),
                                    isLoading ? Container() : RaisedButton(
                                      color: Color.fromARGB(255, 179, 77, 201),
                                        onPressed: () async {
                                          int status = 3;
                                          await ApiController.get(
                                              'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=setStatus&status=$status&id=$id');
                                          timerCounter = 0;
                                          alertSetState(() {
                                            fullNumber = numberString;
                                            isLoading = true;
                                          });
                                        },
                                        child: Text('ارسل مجددا',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          isLoading
                              ? Row(
                                  children: <Widget>[
                                    Loading(),
                                    Text('يرجى انتظار وصول الكود'),
                                  ],
                                ) : Text('لقد تمت عملية الشراء بنجاح!'),
                          CountdownFormatted(
                            duration: Duration(minutes: 15),
                            onFinish: () {
//                                                              print('finished!');
                            },
                            builder: (ctx, duration) {
                              return Text(
                                duration,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
        timer = new Timer.periodic(const Duration(seconds: 1), (Timer t) async {
//                                              print('waiting!');
          counter++;
          if (counter >= 900) {
            int status = 8;
            Fluttertoast.showToast(
                msg: "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
                toastLength: Toast.LENGTH_SHORT);
//                                                print('closed');
            t.cancel();
            print(await ApiController.get(
                'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=setStatus&status=$status&id=$id'));
            Navigator.of(codeContext).pop();
          }
          String statue = await ApiController.get(
              'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=getStatus&id=$id');
          print('Log     ' + statue);
          print('Log ' + timerCounter.toString());
          if (statue.contains('STATUS_OK')) {
            if (timerCounter == 0) {
              timerCounter++;
              String code = statue.substring(statue.indexOf(':') + 1);
              if (mounted)
                alertSetState(() {
                  isLoading = false;
                  fullNumber += '\n' + code;
                });
              showNotification(title: 'إشعار من تطبيق السلام+', body: 'لقد تم استلام الكود بنجاح يرجى التحقق');
              order = Order(
                  orderStatue: false,
                  service: widget.serviceGroup.getServices()[index],
                  numberKey: new NumberKey(code: fullNumber, isUsed: true),
                  price: price);
            }
          } else if (statue.contains('STATUS_WAIT_CODE')) {
          } else if (statue.contains('STATUS_WAIT_RETRY')) {
          } else {
            print('Log:  ' + statue);
            print('error getting the number!!!');
            t.cancel();
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.of(bContext).pop();
      }
    } else {
      Fluttertoast.showToast(
          msg: "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
          toastLength: Toast.LENGTH_SHORT);
      Navigator.of(bContext).pop();
    }
  }

  void buy5SimNumber(int index, String availableNumbersString,
      BuildContext bContext, User user, double price) async {
    showLoaderDialog();
    setState(() {
      isDisabled = true;
    });
    fullNumber = '';
//                                    print(apiKey);
    String numberPath = widget.serviceGroup.getServices()[index].getKeyPath();
    String groupString = numberPath.substring(0, 2);
    String serviceString = numberPath.substring(3);
    // String availableNumbersString = (await http
    //     .get(
    //     'https://sms-activate.ru/stubs/handler_api.php?api_key=$_apiKey&action=getNumbersStatus&country=$serviceString'))
    //     .body;
//                                    print(availableNumbersString);
    String currentBalance = await ApiController.get(
        'http://api1.5sim.net/stubs/handler_api.php?api_key=$_5simApiKey&action=getBalance');
//                                    print(currentBalance);
//                                    print(priceString);
    int serviceStart = availableNumbersString.indexOf('$groupString' + '_0');
    _availableNumbers = int.parse(availableNumbersString.substring(
        availableNumbersString.indexOf(':', serviceStart) + 3,
        availableNumbersString.indexOf(',', serviceStart) - 1));
    double balance =
        double.parse(currentBalance.substring(currentBalance.indexOf(':') + 1));
//                                    print('saed $price');
//                                    print(groupString);
//                                    print(serviceString);
    if (balance != null && balance > price && _availableNumbers > 0) {
      String numberResponse = await ApiController.get(
          'http://api1.5sim.net/stubs/handler_api.php?api_key=$_5simApiKey&action=getNumber&service=$groupString&country=$serviceString');
                                     print(numberResponse);
      String id = numberResponse.substring(
          numberResponse.indexOf(':') + 1, numberResponse.indexOf(':', 15));
      String numberString =
          numberResponse.substring(numberResponse.indexOf(':', 15) + 1);
      print(id);
      print(numberString);
      fullNumber = numberString;
      Function alertSetState;
      isLoading = true;
      if (fullNumber != '') {
        int counter = 0;
        int timerCounter = 0;
        Timer timer;
        Order order;
        Navigator.of(bContext).pop();
        Navigator.pop(_loadingDialogContext);
        showDialog(
            context: context,
            builder: (BuildContext cContext) {
              return StatefulBuilder(
                builder: (cContext, setState) {
                  alertSetState = setState;
                  codeContext = cContext;
                  return WillPopScope(
                    onWillPop: () async {
                      int status = -1;
                      print('closing dialog');
                      timer.cancel();
                      if (order != null) {
                        if (user.getOrderList() == null)
                          user.setOrderList(new List<Order>());
                        user.getOrderList().add(order);
                        user.getMovements().add(order.getMovement());
                        user.setCurrentBalance(user.getCurrentBalance() -
                            price);
                        // distributeProfit(price, index, user);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.getUserUid())
                            .update({
                          'orders': List<dynamic>.from(
                              user.getOrderList().map((x) => x.toMap())),
                          'movements': List<dynamic>.from(
                              user.getMovements().map((x) => x.toMap())),
                          'currentBalance': user.getCurrentBalance(),
                        }).then((value) {
                          print("updating user info is successful!");
                        }).catchError((onError) {
                          print("updating user info failed!!" +
                              onError.toString());
                        });
                        status = 1;
                      }
                      print(await ApiController.get(
                          'http://api1.5sim.net/stubs/handler_api.php?api_key=$_5simApiKey&action=setStatus&status=$status&id=$id'));
                      return true;
                    },
                    child: AlertDialog(
                      title: Center(child: Text('الكود')),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Color(0xffeeeeee),
                                blurRadius: 1.0,
                                offset: Offset(1.0, 1.0),
                              ),
                            ]),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          fullNumber,
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              Clipboard.setData(ClipboardData(
                                                  text: fullNumber));
                                              Fluttertoast.showToast(
                                                  msg: "تم نسخ المحتوى",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                            },
                                            icon: Icon(Icons.content_copy)
                                        ),
                                      ],
                                    ),
                                    isLoading ? Container() : RaisedButton(
                                      color: Color.fromARGB(255, 179, 77, 201),
                                        onPressed: () async {
                                          int status = 3;
                                          await ApiController.get(
                                              'http://api1.5sim.net/stubs/handler_api.php?api_key=$_5simApiKey&action=setStatus&status=$status&id=$id');
                                          timerCounter = 0;
                                          alertSetState(() {
                                            fullNumber = numberString;
                                            isLoading = true;
                                          });
                                        },
                                        child: Text('ارسل مجددا',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          isLoading
                              ? Row(
                                  children: <Widget>[
                                    Loading(),
                                    Text('يرجى انتظار وصول الكود'),
                                  ],
                                ) : Text('لقد تمت عملية الشراء بنجاح!'),
                          CountdownFormatted(
                            duration: Duration(minutes: 15),
                            onFinish: () {
//                                                              print('finished!');
                            },
                            builder: (ctx, duration) {
                              return Text(
                                duration,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
        timer = new Timer.periodic(const Duration(seconds: 1), (Timer t) async {
//                                              print('waiting!');
          counter++;
          if (counter >= 900) {
            int status = -1;
            Fluttertoast.showToast(
                msg: "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
                toastLength: Toast.LENGTH_SHORT);
//                                                print('closed');
            t.cancel();
            print(await ApiController.get(
                'https://sms-activate.ru/stubs/handler_api.php?api_key=$_5simApiKey&action=setStatus&status=$status&id=$id'));
            Navigator.of(codeContext).pop();
          }
          String statue = await ApiController.get(
              'http://api1.5sim.net/stubs/handler_api.php?api_key=$_5simApiKey&action=getStatus&id=$id');
          print('Log     ' + statue);
          // print('Log ' + timerCounter.toString());
          if (statue.contains('STATUS_OK')) {
            if (timerCounter == 0) {
              timerCounter++;
              String code = statue.substring(statue.indexOf(':') + 1);
              if (mounted)
                alertSetState(() {
                  isLoading = false;
                  fullNumber += '\n' + code;
                });
              showNotification(title: 'إشعار من تطبيق السلام+', body: 'لقد تم استلام الكود بنجاح يرجى التحقق');
              order = Order(
                  orderStatue: false,
                  service: widget.serviceGroup.getServices()[index],
                  numberKey: new NumberKey(code: fullNumber, isUsed: true),
                  price: price);
            }
          } else if (statue.contains('STATUS_WAIT_CODE')) {
          } else if (statue.contains('STATUS_WAIT_RETRY')) {
          } else {
            print('Log:  ' + statue);
            print('error getting the number!!!');
            t.cancel();
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.of(bContext).pop();
      }
    } else {
      Fluttertoast.showToast(
          msg: "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
          toastLength: Toast.LENGTH_SHORT);
      Navigator.of(bContext).pop();
    }
  }

  void buyReadyNumber(int index,
      BuildContext bContext, User user, Service service, KeyGroup group, String id) async {
    showLoaderDialog();
    setState(() {
      isDisabled = true;
    });
    List<NumberKey> availableCodes = new List();
    for(int i = 0; i < group.codes.length; i++) {
      if (!group.codes[i].isUsed) {
        availableCodes.add(group.codes[i]);
        group.codes[i].isUsed = true;
      }
    }
    fullNumber = '';
    if (availableCodes.length > 0) {
      fullNumber = availableCodes[0].code;
      Function alertSetState;
      if (fullNumber != '') {
        Order order;
        Navigator.of(bContext).pop();
        Navigator.pop(_loadingDialogContext);
        showDialog(
            context: context,
            builder: (BuildContext cContext) {
              return StatefulBuilder(
                builder: (cContext, setState) {
                  alertSetState = setState;
                  codeContext = cContext;
                  return WillPopScope(
                    onWillPop: () async {
                      print('closing dialog');
                      if (order != null) {
                        if (user.getOrderList() == null)
                          user.setOrderList(new List<Order>());
                        user.getOrderList().add(order);
                        user.getMovements().add(order.getMovement());
                        user.setCurrentBalance(user.getCurrentBalance() -
                            service.price);
                        // distributeProfit(price, index, user);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.getUserUid())
                            .update({
                          'orders': List<dynamic>.from(
                              user.getOrderList().map((x) => x.toMap())),
                          'movements': List<dynamic>.from(
                              user.getMovements().map((x) => x.toMap())),
                          'currentBalance': user.getCurrentBalance(),
                        }).then((value) {
                          print("updating user info is successful!");
                        }).catchError((onError) {
                          print("updating user info failed!!" +
                              onError.toString());
                        });
                        FirebaseFirestore.instance;
                        FirebaseFirestore.instance
                            .collection('keys')
                            .doc(id)
                            .update({
                          'codes': List<dynamic>.from(
                              group.codes.map((x) => x.toMap())),
                        });
                      }
                      return true;
                    },
                    child: AlertDialog(
                      title: Center(child: Text('الكود')),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Color(0xffeeeeee),
                                blurRadius: 1.0,
                                offset: Offset(1.0, 1.0),
                              ),
                            ]),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          fullNumber,
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              Clipboard.setData(ClipboardData(
                                                  text: fullNumber));
                                              Fluttertoast.showToast(
                                                  msg: "تم نسخ المحتوى",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                            },
                                            icon: Icon(Icons.content_copy)
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text('لقد تمت عملية الشراء بنجاح!'),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
        showNotification(title: 'إشعار من تطبيق السلام+', body: 'لقد تم استلام الكود بنجاح يرجى التحقق');
        order = Order(
            orderStatue: false,
            service: widget.serviceGroup.getServices()[index],
            numberKey: new NumberKey(code: fullNumber, isUsed: true),
            price: service.price);
      } else {
        Fluttertoast.showToast(
            msg: "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.of(bContext).pop();
      }
      } else {
        Fluttertoast.showToast(
            msg: "حدث خطأ اثناء شراء الرقم! يرجى المحاولة لاحقا!",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.of(bContext).pop();
      }
    }

  Future<User> getUser() async {
    DocumentSnapshot keyDoc = await FirebaseFirestore.instance
        .collection('other')
        .doc('apiKey')
        .get();
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userUid)
        .get();
    // print('response : ' +  list.docs.toString());
    _apiKey = keyDoc.data()["apiKey"];
    _5simApiKey = keyDoc.data()["5SimApiKey"];
    User user = User.fromMap(doc.data());
    return user;
  }

//   void distributeProfit (double price, int index, User user) async {
//     double rubPrice = await apiGetRubPrice();
//     price = (price / rubPrice)*1.07;
// //    print(price);
//     while (user.getUserUid() != user.getParentUid()){
//       User parent = await FirebaseFirestore.instance.collection('users').doc(user.getParentUid()).get().then(
//               (value) {
//                 return User.fromMap(value.data());
//               });
//       parent.setCurrentBalance(
//           parent.getCurrentBalance() +(user.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice() - parent.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice()));
//       parent.getMovements().add(new Movement(description:"ربح من العميل", amount:user.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice() - parent.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice(), date: null, id:null));
//       FirebaseFirestore.instance.collection('users').doc(parent.getUserUid()).update({
//         'currentBalance':
//             parent.getCurrentBalance(),
//         'movements':
//         List<dynamic>.from(parent.getMovements().map((x) => x.toMap())),
//       }).then((value) => print('profit distributed to parent ' + parent.getUserName())).catchError((onError){
//         print('Error uploading info to '+ parent.getUserName() + ' ' + onError.toString());
//       });
//       user = parent;
//     }
//     double profit = user.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice() - price;
//     FirebaseFirestore.instance.collection('other').doc('profit').get().then((value) {
//       double amount = value.data()['amount'];
//       FirebaseFirestore.instance.collection('other').doc('profit').update({
//         'amount':
//             amount+profit,
//       });
//     });
//   }

  Future<double> apiGetRubPrice() async {
    String response = await ApiController.get(
        'https://api.exchangeratesapi.io/latest?base=USD&symbols=RUB');
//    print(response);
    String stringPrice = response.substring(
        response.indexOf('RUB') + 5, response.indexOf('}', 20));
//    print(stringPrice);
    double price = double.parse(stringPrice);
    return price;
  }
}
