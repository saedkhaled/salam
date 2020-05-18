import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/key.dart';
import 'package:salam/models/movement.dart';
import 'package:salam/models/order.dart';
import 'package:salam/models/service.dart';
import 'package:salam/models/user.dart';
import 'package:salam/services/firestore.dart';


class MyModalBottomSheet extends StatefulWidget {
  final String uid;
  final int serviceIndex;
  final int groupIndex;

  MyModalBottomSheet({Key key, this.uid, this.serviceIndex, this.groupIndex})
      : super(key: key);

  @override
  _MyModalBottomSheetState createState() => _MyModalBottomSheetState();
}

class _MyModalBottomSheetState extends State<MyModalBottomSheet> {
  int counter = 1;
  int keysNumber;
  int validKeysNumber;
  User _user;
  Service service;
  String code = '';
  bool isConfirmed = false;
  bool isLoading = false;
  FireStoreService fireStoreService = FireStoreService();
  List<NumberKey> _keys = List();

  @override
  Widget build(BuildContext context) {
    _checkForAvailableKeys();
    final keys = Provider.of<Object>(context);
    if (keys != null)
      _keys = keys;
    final Widget spinRing = SpinKitRing(
      color: Colors.brown,
      size: 50.0,
    );

    return StreamProvider<Object>.value(
      value: fireStoreService.streamObject(
          '/users/' + widget.uid, fireStoreService.userFromSnapshot),
      child: Form(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: Consumer<Object>(
            builder: (BuildContext context, user, Widget child) {
              if (user != null) {
                _user = user;
                service = _user.getServiceGroups()[widget.groupIndex]
                    .getServices()[widget.serviceIndex];
              }
              return ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    title:code != '' ? Container(decoration: BoxDecoration(boxShadow: [ BoxShadow(color: Color(0xffeeeeee), blurRadius: 1.0, offset: Offset(1.0, 1.0),),]), child: Card(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(code, style: TextStyle(fontSize: 15.0),),
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: code));
                                Fluttertoast.showToast(msg: "تم نسخ المحتوى",
                                    toastLength: Toast.LENGTH_SHORT);
                                },
                              icon: Icon(Icons.content_copy)),
                        ],
                      ),
                    ))) : Text('هل تريد تأكيد عملية الشراء؟'),
                  ),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                if (counter > 0) {
                                  counter--;
                                }
                              });
                            },
                            child: Icon(Icons.remove)),
                        Text(counter.toString()),
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                if(counter < validKeysNumber) {
                                  counter++;
                                }
                                else {
                                  Fluttertoast.showToast(msg: "لا يتوفر لدينا حاليا هذا العدد من الأرقام يرجة المحاولة لاحقا!",
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              });
                            },
                            child: Icon(Icons.add)),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('تأكيد'),
                    onTap: confirmButtonPressed(),
                  ),
                  Container(
                    child: isLoading ? spinRing : Text(''),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Function confirmButtonPressed() {
    if (!isConfirmed) {
      return () async {
        code = '';
        setState(() {
          isConfirmed = true;
          isLoading = true;
        });
        QuerySnapshot querySnapshot = await fireStoreService.getDataCollection('/keys/'+_user.getServiceGroups()[widget.groupIndex].getTitle()+'/'+service.getTitle());
        keysNumber = querySnapshot.documents.length;
        List<NumberKey> myKeyList = List();
        for (int i = 0; i < counter; i++) {
          for(int j = 0; j < _keys.length;j++) {
            NumberKey numberKey = _keys[j];

            print(numberKey.getNumber());
            print(numberKey.getIsUsed());
            if (!numberKey.isUsed) {
              if (myKeyList.length < counter) {
                myKeyList.add(numberKey);
                print(numberKey.getNumber()+' added');
                numberKey.setIsUsed(true);
                fireStoreService.updateDocumentById(numberKey.toMap(), '/keys/'+_user.getServiceGroups()[widget.groupIndex].getTitle()+'/'+service.getTitle()+'/'+ j.toString());
              }
            }
          }
          if (_user.getParentUid() != _user.getUserUid()) {
            DocumentSnapshot snapshot = await fireStoreService
                .getDocumentById('/users/' + _user.getParentUid());
            User parentUser = User.fromMap(snapshot.data);
            print(parentUser.currentBalance);
            double profit = counter *
                (service.getPrice() -
                    parentUser
                        .getServiceGroups()[widget.groupIndex]
                        .getServices()[widget.serviceIndex]
                        .getPrice());
            if (profit > 0) {
              parentUser
                  .setCurrentBalance(parentUser.getCurrentBalance() + profit);
              print(parentUser.currentBalance);
              parentUser.getMovements().add(
                  Movement(description: "ربح من العميل", amount: profit));
              fireStoreService.updateDocumentById(
                  parentUser.toMap(), '/users/' + parentUser.getUserUid());
            }
          }
        }
        setState(() {
          for (int i = 0; i < myKeyList.length; i++)
            code = code + '\n' + myKeyList[i].getNumber() + '  ' + myKeyList[i].getCode();
          isLoading = false;
          Fluttertoast.showToast(msg: "تم اكمال عملية الشراء بنجاح!",
              toastLength: Toast.LENGTH_SHORT);
        });
        for (int i = 0; i < counter; i++) {
          Order order =
              Order(orderStatue: false, service: service,numberKey: myKeyList[i]);
          if( _user.getOrderList() == null)
            _user.setOrderList(new List<Order>());
          _user.getOrderList().add(order);
          _user.getMovements().add(order.getMovement());
        }
        _user.setCurrentBalance(
            _user.getCurrentBalance() - (counter * service.getPrice()));
        fireStoreService.updateDocumentById(
            _user.toMap(), '/users/' + _user.getUserUid());
      };
    } else {
      return null;
    }
  }
  _checkForAvailableKeys() async{
    int result = 0;
    QuerySnapshot querySnapshot = await fireStoreService.getDataCollection('/keys/'+_user.getServiceGroups()[widget.groupIndex].getTitle()+'/'+service.getTitle());
    int keysNumber = querySnapshot.documents.length;
    for(int i =0;i < keysNumber; i++) {
      NumberKey key = NumberKey.fromMap(querySnapshot.documents[i].data);
      if (!key.isUsed) {
        result++;
      }
    }
    validKeysNumber = result;
  }
}
