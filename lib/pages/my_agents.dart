import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/lists/agents_list.dart';
import 'package:salam/services/firestore.dart';
class MyAgents extends StatefulWidget {
  final String uid;
  MyAgents({Key key, this.uid}) : super(key: key);

  @override
  _MyAgentsState createState() => _MyAgentsState();
}

class _MyAgentsState extends State<MyAgents> {
  FireStoreService fireStoreService = FireStoreService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Object>.value(
      value: fireStoreService.streamObject('/users/' + widget.uid,
          fireStoreService.userFromSnapshot),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('My Agents List'),
          ),
          body: AgentsList(),
        ),
      ),
    );
  }
}
