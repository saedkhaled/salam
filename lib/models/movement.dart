// To parse this JSON data, do
//
//     final movement = movementFromJson(jsonString);

import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:uuid/uuid.dart';

class Movement {
  String description;
  double amount;
  String date;
  String id;

  Movement({
    this.description,
    this.amount,
    this.date,
    this.id,
  }) {
    if(this.id == null) {
      this.id = Uuid().v1().toString();
    }
    if (this.date == null) {
      this.date = _getCurrentDate();
    }
  }

  String _getCurrentDate() {
    var now = new DateTime.now();
    return formatDate(now, [yy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }

  Movement copyWith({
    String description,
    double amount,
    String date,
    String id,
  }) =>
      Movement(
        description: description ?? this.description,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        id: id ?? this.id,
      );

  factory Movement.fromJson(String str) => Movement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Movement.fromMap(Map<String, dynamic> json) => Movement(
    description: json["description"] == null ? null : json["description"],
    amount: json["amount"] == null ? null : json["amount"].toDouble(),
    date: json["date"] == null ? null : json["date"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toMap() => {
    "description": description == null ? null : description,
    "amount": amount == null ? null : amount,
    "date": date == null ? null : date,
    "id": id == null ? null : id,
  };

  String getDescription() => description;
  void setDescription(String description) => this.description = description;
  String getDate() => date;
  void setDate(String date) => this.date = date;
  double getAmount() => amount;
  void setAmount(double amount) => this.amount = amount;
  String getId() => id;
  void setId(String  id) => this.id = id;

}