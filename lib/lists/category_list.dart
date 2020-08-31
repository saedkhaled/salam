import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/lists/service_list.dart';
import 'package:salam/models/serviceGroup.dart';
import 'package:salam/models/user.dart';
import 'package:salam/services/firestore.dart';

class CategoryList extends StatefulWidget {

  CategoryList({Key key,}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<ServiceGroup> _serviceGroups = List();
  FireStoreService fireStoreService = FireStoreService();
  User _user;
  int counter = 0;


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null) _user = user;
    FirebaseFirestore.instance.collection('groups').snapshots().listen((event) {
      _serviceGroups.clear();
      for (DocumentSnapshot documentSnapshot in event.docs) {
        _serviceGroups.add(ServiceGroup.fromMap(documentSnapshot.data()));
      }
      fitchPrices();
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user.getUserUid())
          .update({
        'serviceGroups' :
        List<dynamic>.from(_serviceGroups.map((x) => x.toMap())),
      });
    });
//    if (counter == 0 && _user != null && _user.getServiceGroups() != null) {
//      fitchPrices();
//      Firestore.instance
//          .collection('users')
//          .document(_user.getUserUid())
//          .updateData({
//        'serviceGroups':
//        List<dynamic>.from(_user.getServiceGroups().map((x) => x.toMap())),
//      }).then((value) =>
//          print(
//              "updating prices is successful!"));
//      counter++;
//    }
    final listView = ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _user != null ? _user.getServiceGroups().length : 7,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
//            StreamProvider<Object>.value(
//          value: fireStoreService.streamCollection('/groups/', fireStoreService.serviceGroupListFromSnapshot),
//              child: Consumer<Object>(
//                builder: (BuildContext context, serviceGroups, Widget child) {
//                  if (serviceGroups != null)
//                    _serviceGroups = serviceGroups;
////                  fitchPrices();
//                  if(_serviceGroups.length > 0) {
//                    _user.setServiceGroups(_serviceGroups);
//                    fireStoreService.updateDocumentById(_user.toMap(), '/users/'+_user.getUserUid());
//                  }
//                  return Container();
//                },
//              ),
//            ),
            ServiceList(
              groupIndex: index,
            ),
          ],
        );
      },
    );
    return listView;
  }

  void fitchPrices() {
    for(int i =0; i < _serviceGroups.length; i++) {
      for(int j =0; j < _serviceGroups[i].getServices().length;j++) {
        for(int k=0; k < _user.getPrices().length;k++){
          if (_user.getPrices()[k].getId() == _serviceGroups[i].getServices()[j].getId()) {
            _serviceGroups[i].getServices()[j].setPrice(_user.getPrices()[k].getAmount());
          }
        }
      }
    }
  }
}