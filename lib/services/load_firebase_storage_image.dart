//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
//import 'package:yamenflutter/services/firebase_storage_service.dart';
//
//class LoadFirbaseStorageImage extends StatefulWidget {
//  @override
//  _LoadFirbaseStorageImageState createState() =>
//      _LoadFirbaseStorageImageState();
//}
//
//class _LoadFirbaseStorageImageState extends State<LoadFirbaseStorageImage> {
//  FirebaseStorage firebaseStorage;
//
//
//  @override
//  Widget build(BuildContext context) {
//    loadButton(context);
//    return Expanded(
//    //Image Loading code goes here
//    child: FutureBuilder(
//    future: _getImage(context, image),
//    builder: (context, snapshot) {
//    if (snapshot.connectionState ==
//    ConnectionState.done)
//    return Container(
//    height:
//    MediaQuery.of(context).size.height / 1.25,
//    width:
//    MediaQuery.of(context).size.width / 1.25,
//    child: snapshot.data,
//    );
//
//    if (snapshot.connectionState ==
//    ConnectionState.waiting)
//    return Container(
//    height: MediaQuery.of(context).size.height /
//    1.25,
//    width: MediaQuery.of(context).size.width /
//    1.25,
//    child: CircularProgressIndicator());
//
//    return Container();
//    },
//    ),
//    );
//    //This is button to toggle image.
//  }
//
//  Future<Widget> _getImage(BuildContext context, String image) async {
//    Image m;
//    await FireStorageService.loadImage(context, image).then((downloadUrl) {
//      m = Image.network(
//        downloadUrl.toString(),
//        fit: BoxFit.scaleDown,
//      );
//    });
//    return m;
//  }
//}