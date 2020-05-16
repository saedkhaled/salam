// To parse this JSON data, do
//
//     final serviceGroup = serviceGroupFromJson(jsonString);

import 'dart:convert';

import 'package:salam/models/service.dart';
class ServiceGroup {
  String title;
  List<Service> services;

  ServiceGroup({
    this.title,
    this.services,
  });

  ServiceGroup copyWith({
    String title,
    List<Service> services,
  }) =>
      ServiceGroup(
        title: title ?? this.title,
        services: services ?? this.services,
      );

  factory ServiceGroup.fromJson(String str) => ServiceGroup.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServiceGroup.fromMap(Map<String, dynamic> json) => ServiceGroup(
    title: json["title"] == null ? null : json["title"],
    services: json["services"] == null ? null : List<Service>.from(json["services"].map((x) => Service.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "title": title == null ? null : title,
    "services": services == null ? null : List<dynamic>.from(services.map((x) => x.toMap())),
  };

  String getTitle() => title;

  void setTitle(String title) => this.title = title;

  List<Service> getServices() => services;

  void setServices(List<Service> services) => this.services = services;

}
