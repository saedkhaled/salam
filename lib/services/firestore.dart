import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:salam/models/keyGroup.dart';
import 'package:salam/models/numberKey.dart';
import 'package:salam/models/movement.dart';
import 'package:salam/models/order.dart';
import 'package:salam/models/serviceGroup.dart';
import 'package:salam/models/user.dart';

class FireStoreService extends ChangeNotifier{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getDataCollection(String path) {
    return firestore.collection(path).get() ;
  }

  Future<QuerySnapshot> getDataCollectionWithQuery(String path, String field, String value) {
    return firestore.collection(path).where(field, isEqualTo: value).get() ;
  }

  Stream<Object> streamObject(String path, Function objectFromSnapshot) {
    return firestore.doc(path).snapshots()
        .map(objectFromSnapshot);
  }

  Stream<Object> streamCollection(String path, Function objectListFromSnapshot) {
    return firestore.collection(path).
    snapshots().map(objectListFromSnapshot);
  }

  Stream<Object> streamCollectionWithOrder(String path, String field, Function objectFromSnapshot) {
    return firestore.collection(path).orderBy(field).
    snapshots().map(objectFromSnapshot);
  }

  Stream<List<Object>> streamCollectionWithQuery(String path, String field, String key, Function objectFromSnapshot) {
    return firestore.collection('/users')
        .where(field, isEqualTo: key).
    snapshots().map(objectFromSnapshot);
  }

  Stream<Object> streamObjectWithQuery(String path, String field, String key, Function objectFromSnapshot) {
    return firestore.collection(path)
        .where(field, isEqualTo: key).
    snapshots().map(objectFromSnapshot);
  }

  Future<String> getDocumentId (String path, String field, String value) async{
    return firestore.collection(path).where(field,isEqualTo: value).get().
    then((value) {
      return value.docs[0].id;
    });
  }

  List<User> userListFromSnapshot (QuerySnapshot snapshots) {
    List<User> users;
    for(int i = 0; i < snapshots.docs.length; i++)
    users.add(User.fromMap(snapshots.docs[i].data()));
    return users;
  }


  User userFromSnapshot(DocumentSnapshot snapshot) {
    return User.fromMap(snapshot.data());
  }


  KeyGroup keyGroupFromSnapshot(QuerySnapshot querySnapshot) {
    return KeyGroup.fromMap(querySnapshot.docs[0].data());
  }

  List<Order> ordersFromSnapshot(DocumentSnapshot snapshot) {
    return User.fromMap(snapshot.data()).getOrderList();
  }

  List<Movement> movementsFromSnapshot(DocumentSnapshot snapshot) {
    return User.fromMap(snapshot.data()).getMovements();
  }

  List<ServiceGroup> serviceGroupListFromSnapshot (QuerySnapshot snapshots) {
    List<ServiceGroup> serviceGroups = List();
    for(int i = 0; i < snapshots.docs.length; i++)
      serviceGroups.add(ServiceGroup.fromMap(snapshots.docs[i].data()));
    return serviceGroups;
  }

  // getting a key list from snapshots list
  List<NumberKey> keyListFromSnapshot (QuerySnapshot snapshots) {
    List<NumberKey> keys = List();
    for(int i = 0; i < snapshots.docs.length; i++)
      keys.add(NumberKey.fromMap(snapshots.docs[i].data()));
    return keys;
  }
  
  Future<DocumentSnapshot> getDocumentById(String path) {
    return firestore.doc(path).get();
  }
  
  Future<void> removeDocumentById(String path) async{
    firestore.doc(path).delete();
    print('document deleted!');
  }

  Future<void> updateDocumentById(Map data , String path) async{
    try {
      await firestore.doc(path).update(data);
    } catch (e) {
      print(e);
      await createNewDocumentWithId(data, path);
    }
  }

  Future<void> createNewDocumentWithId(Map data , String path) async{
    await firestore.doc(path).set(data);
  }

  Future<void> createNewDocument(Map data , String path) async{
    await firestore.collection(path).add(data);
  }
  
}