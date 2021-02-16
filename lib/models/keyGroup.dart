import 'dart:convert';

import 'package:salam/models/numberKey.dart';

class KeyGroup {
  List<NumberKey> codes;
  String id;



  KeyGroup({
    this.id,
    this.codes,
  });

  KeyGroup copyWith({
    String id,
    List<NumberKey> codes,
  }) =>
      KeyGroup(
        id: id ?? this.id,
        codes: codes ?? this.codes,
      );

  factory KeyGroup.fromJson(String str) => KeyGroup.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KeyGroup.fromMap(Map<String, dynamic> json) => KeyGroup(
    id: json["id"] == null ? null : json["id"],
    codes: json["codes"] == null ? null : List<NumberKey>.from(json["codes"].map((x) => NumberKey.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "codes": codes == null ? null : List<dynamic>.from(codes.map((x) => x.toMap())),
  };

  String getId() => id;

  void setId(String id) => this.id = id;

  List<NumberKey> getCodes() => codes;

  void setCodes(List<NumberKey> codes) => this.codes = codes;

}