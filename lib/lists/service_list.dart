import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/keyGroup.dart';
import 'package:salam/models/numberKey.dart';
import 'package:salam/models/serviceGroup.dart';
import 'package:salam/models/user.dart';
import 'package:salam/pages/bottom_sheet.dart';
import 'package:salam/pages/service_card.dart';
import 'package:salam/services/firestore.dart';
class ServiceList extends StatefulWidget {

  final int groupIndex;

  ServiceList({Key key, this.groupIndex}) : super(key: key);

  @override
  _ServiceListState createState() => _ServiceListState();

}

class _ServiceListState extends State<ServiceList> {
  ServiceGroup serviceGroup;
  User _user;
  FireStoreService fireStoreService = FireStoreService();
  bool hasKeys = true;
  String code = ' ';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null)
      _user = user;
    final listView = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _user != null ? _user.getServiceGroups()[widget.groupIndex].getServices().length : 7,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap:() {
            if(_user.getCurrentBalance() >= 5 * _user.getServiceGroups()[widget.groupIndex].getServices()[index].getPrice()) {
//              _showSettingsPanel(index);
            showDialog(context: context,
            builder: (BuildContext bContext) {
              return AlertDialog(
                title: Container(child: Text('عملية الشراء'),alignment: Alignment.centerRight, height: 30.0,),
                content:Container(child: Text('هل تريد تأكيد عملية الشراء؟'), alignment: Alignment.centerRight, height: 30.0,),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () async{
                        String documentId = await fireStoreService.getDocumentId("/keys2/", 'name', _user.getServiceGroups()[widget.groupIndex].getServices()[index].getTitle());
                        await fireStoreService.getDocumentById('/keys2/' + documentId).then((value) {
                          KeyGroup keyGroup = KeyGroup.fromMap(value.data);
                          for(int j = 0; j < keyGroup.getKeys().length;j++) {
                            if (!keyGroup.getKeys()[j].isUsed) {
                              setState(() {
                                code = keyGroup.getKeys()[j].getNumber() + '\n' + keyGroup.getKeys()[j].getCode();
                              });
                              keyGroup.getKeys()[j].setIsUsed(true);
                              break;
                            }
                          }
                        });
                        Navigator.of(bContext).pop();
                        showDialog(context: context,
                          builder: (BuildContext cContext) {
                          return AlertDialog(
                            title: Center(child: Text('الكود')),
                            content: Container(decoration: BoxDecoration(boxShadow: [ BoxShadow(color: Color(0xffeeeeee), blurRadius: 1.0, offset: Offset(1.0, 1.0),),]), child: Card(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(code, style: TextStyle(fontSize: 15.0),),
                                  IconButton(
                                      onPressed: () async{
                                        Clipboard.setData(ClipboardData(text: code));
                                        Fluttertoast.showToast(msg: "تم نسخ المحتوى",
                                            toastLength: Toast.LENGTH_SHORT);
                                      },
                                      icon: Icon(Icons.content_copy)),
                                ],
                              ),
                            ))),
                          );
                          }
                        );
                      },
                      child: Container(child: Text('تأكيد'))),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('إلفاء')),
                ],
              );
            });
            }
            else{
              Fluttertoast.showToast(msg: "ليس لديك رصيد كافي لاتمام العملية!!",
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

    return
      Container(
        padding: EdgeInsets.only(bottom: 20.0,right: 4.0,left: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.elliptical(100.0,10.0),topLeft: Radius.elliptical(100.0,10.0)),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0,top: 10.0,bottom: 10.0),
                  child: Text(
                    _user != null ? _user.getServiceGroups()[widget.groupIndex].getTitle().toUpperCase() : 'getting info',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 20.0, ),
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


  _checkForAvailableKeys(int index) async{
    int result = 0;
    QuerySnapshot querySnapshot = await fireStoreService.getDataCollection('/keys2/'+_user.getServiceGroups()[widget.groupIndex].getTitle()+'/'+_user.getServiceGroups()[widget.groupIndex].getServices()[index].getTitle());
    int keysNumber = querySnapshot.documents.length;
    for(int i =0;i < keysNumber; i++) {
      NumberKey key = NumberKey.fromMap(querySnapshot.documents[i].data);
      if (!key.isUsed) {
        result++;
      }
    }
    if(result > 0){
      hasKeys = true;
    }
    else{
      hasKeys = false;
    }
  }

  void _showSettingsPanel(int index) {
      showModalBottomSheet(context: context, builder: (context) {
        return StreamProvider.value(
          value: fireStoreService.streamObjectWithQuery(
              '/keys2/',
              'name',
              _user.getServiceGroups()[widget.groupIndex].getServices()[index].getTitle(),
              fireStoreService.keyGroupFromSnapshot),
            child: MyModalBottomSheet(uid: _user.getUserUid(), groupIndex: widget.groupIndex, serviceIndex: index));
      });
  }
}
