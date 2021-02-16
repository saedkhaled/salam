// To parse this JSON data, do
//
//     final key = keyFromJson(jsonString);

import 'dart:convert';

class NumberKey{
  bool isUsed;
  String code;

  NumberKey({
    this.isUsed,
    this.code,
  });

  NumberKey copyWith({
    bool isUsed,
    String code,
  }) =>
      NumberKey(
        isUsed: isUsed ?? this.isUsed,
        code: code ?? this.code,
      );

  factory NumberKey.fromJson(String str) => NumberKey.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NumberKey.fromMap(Map<String, dynamic> json) => NumberKey(
    isUsed: json["isUsed"] == null ? null : json["isUsed"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toMap() => {
    "isUsed": isUsed == null ? null : isUsed,
    "code": code == null ? null : code,
  };

  String getCode() => code;
  void setCode(String code) => this.code = code;
  bool getIsUsed() => isUsed;
  void setIsUsed(bool isUsed) => this.isUsed = isUsed;

}