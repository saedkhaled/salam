import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:salam/models/movement.dart';
import 'package:salam/models/order.dart';
import 'package:salam/models/serviceGroup.dart';
import 'package:salam/models/user.dart';

class FireStoreService extends ChangeNotifier{
  final Firestore firestore = Firestore.instance;

  Future<QuerySnapshot> getDataCollection(String path) {
    return firestore.collection(path).getDocuments() ;
  }

  Stream<Object> streamObject(String path, Function objectFromSnapshot) {
    return firestore.document(path).snapshots()
        .map(objectFromSnapshot);
  }

  Stream<Object> streamCollection(String path, Function objectListFromSnapshot) {
    return firestore.collection(path).
    snapshots().map(objectListFromSnapshot);
  }

  Stream<List<Object>> streamCollectionWithQuery(String path, String field, String key, Function objectFromSnapshot) {
    return firestore.collection('/users')
        .where(field, isEqualTo: key).
    snapshots().map(objectFromSnapshot);
  }

  List<User> userListFromSnapshot (QuerySnapshot snapshots) {
    List<User> users;
    for(int i = 0; i < snapshots.documents.length; i++)
    users.add(User.fromMap(snapshots.documents[i].data));
    return users;
  }


  User userFromSnapshot(DocumentSnapshot snapshot) {
    return User.fromMap(snapshot.data);
  }

  List<Order> ordersFromSnapshot(DocumentSnapshot snapshot) {
    return User.fromMap(snapshot.data).getOrderList();
  }

  List<Movement> movementsFromSnapshot(DocumentSnapshot snapshot) {
    return User.fromMap(snapshot.data).getMovements();
  }

  List<ServiceGroup> serviceGroupListFromSnapshot (QuerySnapshot snapshots) {
    List<ServiceGroup> serviceGroups = List();
    for(int i = 0; i < snapshots.documents.length; i++)
      serviceGroups.add(ServiceGroup.fromMap(snapshots.documents[i].data));
    return serviceGroups;
  }

  
  Future<DocumentSnapshot> getDocumentById(String path) {
    return firestore.document(path).get();
  }
  
  Future<void> removeDocumentById(String path) async{
    firestore.document(path).delete();
    print('document deleted!');
  }

  Future<void> updateDocumentById(Map data , String path) async{
    try {
      await firestore.document(path).updateData(data);
    } catch (e) {
      print(e);
      await createNewDocumentWithId(data, path);
    }
  }

  Future<void> createNewDocumentWithId(Map data , String path) async{
    await firestore.document(path).setData(data);
  }

  Future<void> createNewDocument(Map data , String path) async{
    await firestore.collection(path).add(data);
  }
  
}