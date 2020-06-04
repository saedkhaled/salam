import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/service.dart';
import 'package:salam/models/user.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null) {
      _user = user;
      service = _user.getServiceGroups()[widget.groupIndex].getServices()[widget
          .serviceIndex];
      FirebaseStorage.instance.ref().child(service.getImageUrl()).getDownloadURL().then((dynamic result) {
        try {
          setState(() {
            imageUrl = Uri.parse(result).toString();
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
                  image: CachedNetworkImageProvider(imageUrl != null ? imageUrl : "",scale: 0.7),
                ),
            ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB( 0,10.0, 0, 0),
                child: Center(
                  child: Text(
                    service != null ? service.getTitle() : '......',
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 20.0),
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
              Text(
                service != null ? service.getPrice().toString() + ' \$' : '......',
                style:
                TextStyle(color: Color(0xff5f6368), fontSize: 18.0),
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
