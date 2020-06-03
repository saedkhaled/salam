// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:salam/models/numberKey.dart';
import 'package:salam/models/movement.dart';
import 'package:salam/models/service.dart';
import 'package:uuid/uuid.dart';

class Order {
  String orderDate;
  bool orderStatue;
  Service service;
  String id;
  Movement movement;
  NumberKey numberKey;

  Order({
    this.orderDate,
    this.orderStatue,
    this.service,
    this.id,
    this.movement,
    this.numberKey,
  }) {
    if (this.orderDate == null) {
      this.orderDate = getCurrentDate();
    }
    if (this.id == null) {
      this.id = Uuid().v1().toString();
    }
    if (this.movement == null) {
      this.movement = generateNewMovement();
    }
  }

  String getCurrentDate() {
    var now = new DateTime.now();
    return formatDate(now, [yy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }

  Order copyWith({
    String orderDate,
    bool orderStatue,
    Service service,
    String id,
    Movement movement,
    NumberKey numberKey,
  }) =>
      Order(
        orderDate: orderDate ?? this.orderDate,
        orderStatue: orderStatue ?? this.orderStatue,
        service: service ?? this.service,
        id: id ?? this.id,
        movement: movement ?? this.movement,
        numberKey: numberKey ?? this.numberKey,
      );

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    orderDate: json["orderDate"] == null ? null : json["orderDate"],
    orderStatue: json["orderStatue"] == null ? null : json["orderStatue"],
    service: json["service"] == null ? null : Service.fromMap(json["service"]),
    id: json["id"] == null ? null : json["id"],
    movement: json["movement"] == null ? null : Movement.fromMap(json["movement"]),
    numberKey: json["numberKey"] == null ? null : NumberKey.fromMap(json["numberKey"]),
  );

  Map<String, dynamic> toMap() => {
    "orderDate": orderDate == null ? null : orderDate,
    "orderStatue": orderStatue == null ? null : orderStatue,
    "service": service == null ? null : service.toMap(),
    "id": id == null ? null : id,
    "movement": movement == null ? null : movement.toMap(),
    "numberKey": numberKey == null ? null : numberKey.toMap(),
  };
  String getOrderDate() => orderDate;
  void setOrderDate(String orderDate) => this.orderDate = orderDate;
  bool getOrderStatue() => orderStatue;
  void setOrderStatue(bool orderStatue) => this.orderStatue = orderStatue;
  Service getService() => service;
  void setService(Service service) => this.service = service;
  String getId() => id;
  void setId(String id) => this.id = id;
  Movement getMovement() => movement;
  void setMovement(Movement movement) => this.movement = movement;
  NumberKey getNumberKey() => numberKey;
  void setNumberKey(NumberKey numberKey) => this.numberKey = numberKey;

  Movement generateNewMovement() {
    return Movement(id: this.getId(),description: "عملية شراء", amount:  -1 * service.getPrice(),date: this.getOrderDate());
  }

}