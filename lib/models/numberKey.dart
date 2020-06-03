// To parse this JSON data, do
//
//     final key = keyFromJson(jsonString);

import 'dart:convert';

class NumberKey{
  String number;
  bool isUsed;
  String code;

  NumberKey({
    this.number,
    this.isUsed,
    this.code,
  });

  NumberKey copyWith({
    String number,
    bool isUsed,
    String code,
  }) =>
      NumberKey(
        number: number ?? this.number,
        isUsed: isUsed ?? this.isUsed,
        code: code ?? this.code,
      );

  factory NumberKey.fromJson(String str) => NumberKey.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NumberKey.fromMap(Map<String, dynamic> json) => NumberKey(
    number: json["number"] == null ? null : json["number"],
    isUsed: json["isUsed"] == null ? null : json["isUsed"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toMap() => {
    "number": number == null ? null : number,
    "isUsed": isUsed == null ? null : isUsed,
    "code": code == null ? null : code,
  };

  String getNumber() => number;
  void setNumber(String number) => this.number = number;
  String getCode() => code;
  void setCode(String code) => this.code = code;
  bool getIsUsed() => isUsed;
  void setIsUsed(bool isUsed) => this.isUsed = isUsed;

}