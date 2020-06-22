import 'dart:convert';

class Number {
  String number;
  String code;

  Number({
    this.number,
    this.code,
  });

  Number copyWith({
    String number,
    String code,
  }) =>
      Number(
        number: number ?? this.number,
        code: code ?? this.code,
      );

  factory Number.fromJson(String str) => Number.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Number.fromMap(Map<String, dynamic> json) => Number(
        number: json["number"] == null ? null : json["number"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toMap() => {
        "number": number == null ? null : number,
        "code": code == null ? null : code,
      };

  String getNumber() => number;

  void setNumber(String number) => this.number = number;

  String getCode() => code;

  void setCode(String code) => this.code = code;
}
