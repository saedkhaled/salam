// To parse this JSON data, do
//
//     final key = keyFromJson(jsonString);

import 'dart:convert';

class MyKey {
  bool isUsed;
  String code;

  MyKey({
    this.isUsed,
    this.code,
  });

  MyKey copyWith({
    String number,
    bool isUsed,
    String code,
  }) =>
      MyKey(
        isUsed: isUsed ?? this.isUsed,
        code: code ?? this.code,
      );

  factory MyKey.fromJson(String str) => MyKey.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyKey.fromMap(Map<String, dynamic> json) => MyKey(
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

class NumberKey extends MyKey {
  String number;
  bool isUsed;
  String code;
  int counter;

  NumberKey({
    this.number,
    this.isUsed,
    this.code,
    this.counter,
  });

  NumberKey copyWith({
    String number,
    bool isUsed,
    String code,
    int counter,
  }) =>
      NumberKey(
        number: number ?? this.number,
        isUsed: isUsed ?? this.isUsed,
        code: code ?? this.code,
        counter: counter ?? this.counter,
      );

  factory NumberKey.fromJson(String str) => NumberKey.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NumberKey.fromMap(Map<String, dynamic> json) => NumberKey(
    number: json["number"] == null ? null : json["number"],
    isUsed: json["isUsed"] == null ? null : json["isUsed"],
    code: json["code"] == null ? null : json["code"],
    counter: json["counter"] == null ? null : json["counter"],
  );

  Map<String, dynamic> toMap() => {
    "number": number == null ? null : number,
    "isUsed": isUsed == null ? null : isUsed,
    "code": code == null ? null : code,
    "counter": counter == null ? null : counter,
  };

  String getNumber() => number;
  void setNumber(String number) => this.number = number;
  String getCode() => code;
  void setCode(String code) => this.code = code;
  bool getIsUsed() => isUsed;
  void setIsUsed(bool isUsed) => this.isUsed = isUsed;
  int getCounter() => counter;
  void setCounter(int counter) => this.counter = counter;

}