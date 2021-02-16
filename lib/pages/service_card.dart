import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:salam/models/service.dart';
import 'package:salam/services/firestore.dart';

class ServiceCard extends StatefulWidget {
  final Service service;

  ServiceCard({Key key, this.service}) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  // Service service;
  // User _user;
  FirebaseStorage firebaseStorage;
  Future<String> _imageUrl;
//  bool hasKeys = false;
  FireStoreService fireStoreService = FireStoreService();

  @override
  void initState() {
    super.initState();
    _imageUrl = getImage();
  }


  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<Object>(context);
    // if (user != null) {
    //   _user = user;
    //   service = _user.getServiceGroups()[widget.groupIndex].getServices()[widget
    //       .serviceIndex];

    return FutureBuilder(
        future: _imageUrl,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
            child: widget.service != null ?
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
                      image: CachedNetworkImageProvider(snapshot.data ?? ''),
                    ),
                ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB( 0,10.0, 0, 0),
                    child: Center(
                      child: Text(
                        widget.service.getTitle(),
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15.0),
                        softWrap: true,
                      ),
                    ),
                  ),

                  Text(
                    widget.service.getDescription(),
                    style: TextStyle(
                      color: Color(0xff202124),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               Text(
                  //                 widget.service.getPrice().toString() + ' \$',
                  //                 style: TextStyle(
                  //                     color: Color(0xff5f6368), fontSize: 15.0),
                  //               ),
                  //             ],
                  //           ),
                ],
                  ),
                ),
              ],
            )
                : Container(),
          ),
        );
      }
    );
  }

  Future<String> getImage() async{
    String result = (await FirebaseStorage.instance.ref().child(widget.service.getImageUrl()).getDownloadURL()).toString();
    return Uri.parse(result).toString();
  }
}
