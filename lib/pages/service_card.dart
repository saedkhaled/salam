import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/keyGroup.dart';
import 'package:salam/models/numberKey.dart';
import 'package:salam/models/service.dart';
import 'package:salam/models/user.dart';
import 'package:salam/services/firestore.dart';

class ServiceCard extends StatefulWidget {
  final int groupIndex;
  final int serviceIndex;

  ServiceCard({Key key, this.groupIndex, this.serviceIndex}) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  Service service;
  User _user;
  FirebaseStorage firebaseStorage;
  String imageUrl;
  bool hasKeys = false;
  FireStoreService fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null) {
      _user = user;
      service = _user.getServiceGroups()[widget.groupIndex].getServices()[widget
          .serviceIndex];
      FirebaseStorage.instance.ref().child(service.getImageUrl()).getDownloadURL().then((dynamic result) {
        try {
          if (mounted) {
            setState(() {
              imageUrl = Uri.parse(result).toString();
            });
          }
          fireStoreService.getDataCollectionWithQuery('/keys2/','name', service.getTitle()).then((value) {
            hasKeys = false;
            List<NumberKey> list = KeyGroup.fromMap(value.documents[0].data).getKeys();
            for(int i =0;i < list.length; i++) {
              if (!list[i].getIsUsed() && list[i].getCode() != 'null' &&
                  list[i].getNumber() != 'null') {
                if(mounted) {
                  setState(() {
                    hasKeys = true;
                  });
                }
                break;
              }
            }
          });

        } catch (e){
          print(e.toString());
        }
      });
    }
    return Container(
      width: 150.0,
      decoration: new BoxDecoration(boxShadow: [
        new BoxShadow(
          color: Colors.transparent,
          blurRadius: 7.0,
          offset: new Offset(1.0, 1.0),
        ),
      ]),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: service != null ?
        Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color.fromARGB(255,185, 41, 255),Colors.blue[900]],
                    ),
                ),
              height: 100.0,),
            ),
            Container(
              padding: EdgeInsets.only(top: 45.0),
              alignment:Alignment.center,
              child: Column(
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(imageUrl != null ? imageUrl : ""),
                ),
            ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB( 0,10.0, 0, 0),
                child: Center(
                  child: Text(
                    service != null ? service.getTitle() : '......',
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15.0),
                    softWrap: true,
                  ),
                ),
              ),

              Text(
                service != null ? service.getDescription() : "...........",
                style: TextStyle(
                  color: Color(0xff202124),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  !hasKeys ? Container(
                    padding: EdgeInsets.only(right: 5.0),
                      child: Icon(Icons.error_outline,color: Colors.red,size: 20.0,)) : Container(),
                  Text(
                    service != null ? service.getPrice().toString() + ' \$' : '......',
                    style:
                    TextStyle(color: Color(0xff5f6368), fontSize: 15.0),
                  ),
                ],
              ),
            ],
              ),
            ),
          ],
        )
//                  Center(
//                    child: CircleAvatar(
//                      radius: 70.0,
//                      backgroundImage: imageUrl != null ? CachedNetworkImageProvider(
//                        imageUrl,
//                        scale: 1.0,
//
//                      ) : NetworkImage('https://via.placeholder.com/150'),
//                      backgroundColor: Colors.transparent,
//                    ),
//                  )
            : Container(),
      ),
    );
  }
}
