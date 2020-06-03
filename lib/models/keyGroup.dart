import 'dart:convert';

import 'package:salam/models/numberKey.dart';

class KeyGroup {
  List<NumberKey> keys;
  String name;



  KeyGroup({
    this.name,
    this.keys,
  });

  KeyGroup copyWith({
    String name,
    List<NumberKey> keys,
  }) =>
      KeyGroup(
        name: name ?? this.name,
        keys: keys ?? this.keys,
      );

  factory KeyGroup.fromJson(String str) => KeyGroup.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KeyGroup.fromMap(Map<String, dynamic> json) => KeyGroup(
    name: json["name"] == null ? null : json["name"],
    keys: json["keys"] == null ? null : List<NumberKey>.from(json["keys"].map((x) => NumberKey.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "name": name == null ? null : name,
    "keys": keys == null ? null : List<dynamic>.from(keys.map((x) => x.toMap())),
  };

  String getName() => name;

  void setName(String name) => this.name = name;

  List<NumberKey> getKeys() => keys;

  void setKeys(List<NumberKey> keys) => this.keys = keys;

}