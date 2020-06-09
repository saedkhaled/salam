import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/keyGroup.dart';
import 'package:salam/models/numberKey.dart';
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
    final KeyGroup keyGroup = Provider.of<Object>(context);
    if (keyGroup != null)
      _keys = keyGroup.getKeys();
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
                                  Fluttertoast.showToast(msg: "لا يتوفر لدينا حاليا هذا العدد من الأرقام يرجى المحاولة لاحقا!",
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
        List<NumberKey> myKeyList = List();
        for (int i = 0; i < counter; i++) {
          for(int j = 0; j < _keys.length;j++) {
            if (!_keys[j].isUsed) {
              if (myKeyList.length < counter) {
                myKeyList.add(_keys[j]);
                _keys[j].setIsUsed(true);}
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
        Firestore.instance.collection("keys2").where("name",isEqualTo: service.getTitle()).getDocuments().then((value) {
          String documentId = value.documents[0].documentID;
//          Fluttertoast.showToast(msg: documentId,
//              toastLength: Toast.LENGTH_SHORT);
          Firestore.instance.collection("keys2").document(documentId).updateData({
            'keys' : List<dynamic>.from(_keys.map((x) => x.toMap()))
          }).then((value) {
            print("updating keys is successful!");
          }).catchError((onError){
            print("updating keys failed!" + onError.toString());
          });
        });
      };
    } else {
      return null;
    }
  }
  _checkForAvailableKeys() async{
    int result = 0;
    int keysNumber = _keys.length;
    for(int i =0;i < keysNumber; i++) {
      if (!_keys[i].isUsed) {
        result++;
      }
    }
    validKeysNumber = result;
  }
}
