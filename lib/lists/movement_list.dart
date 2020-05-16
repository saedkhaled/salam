import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salam/models/movement.dart';
import 'package:salam/models/user.dart';
class MovementList extends StatefulWidget {
  MovementList({Key key}) : super(key: key);

  @override
  _MovementListState createState() => _MovementListState();
}

class _MovementListState extends State<MovementList> {
  User _user;
  List<Movement> _movementList;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Object>(context);
    if (user != null) {
      _user = user;
      _movementList = _user.getMovements();
    }
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _movementList != null ? _movementList.length : 5,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap:() {},
                  title: Text(_movementList[index].getDescription()),
                  trailing: Text(_movementList[index].getDate()),
                  leading: Text(_movementList[index].getAmount() > 0 ? "+ " + _movementList[index].getAmount().toString() : _movementList[index].getAmount().toString()),
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