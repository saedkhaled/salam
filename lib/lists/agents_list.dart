import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/agent.dart';
import 'package:salam/models/user.dart';
import 'package:salam/services/firestore.dart';

class AgentsList extends StatefulWidget {
  AgentsList({Key key}) : super(key: key);

  @override
  _AgentsListState createState() => _AgentsListState();
}

class _AgentsListState extends State<AgentsList> {
  FireStoreService fireStoreService = FireStoreService();
  User _user;
  List<Agent> _agents = List();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null) {
      _user = user;
      _agents = _user.getAgentList();
    }
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: _agents != null ? _agents.length : 5,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap:() {},
                    title: Text(_agents != null && _agents.length > 0 ? _agents[index].getName() : "Loading"),
                    trailing: Text(_agents != null && _agents.length > 0 ? _agents[index].getUserName() : "Loading"),
                    leading: Text(_agents != null && _agents.length > 0 ? _agents[index].getPhoto() : "Loading"),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            );
          },

        ),
      );
  }
}