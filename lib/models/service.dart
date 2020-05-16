import 'dart:convert';
import 'package:uuid/uuid.dart';

class Service {
  String title;
  String description;
  double price;
  String imageUrl;
  String id;
  String keyPath;

  Service({
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.id,
    this.keyPath,
  }){
    if (id == null) {
      this.id = Uuid().v1().toString();
    }
  }


  Service copyWith({
    String title,
    String description,
    double price,
    String imageUrl,
    String id,
    String keyPath,
  }) =>
      Service(
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        id: id ?? this.id,
        keyPath: keyPath ?? this.keyPath,
      );

  factory Service.fromJson(String str) => Service.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  factory Service.fromMap(Map<String, dynamic> json) => Service(
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    price: json["price"] == null ? null : json["price"].toDouble(),
    imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
    id: json["id"] == null ? null : json["id"],
    keyPath: json["keyPath"] == null ? null : json["keyPath"],
  );

  Map<String, dynamic> toMap() => {
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "price": price == null ? null : price,
    "imageUrl": imageUrl == null ? null : imageUrl,
    "id": id == null ? null : id,
    "keyPath": keyPath == null ? null : keyPath,
  };

  String getTitle() => title;
  void setTitle(String title) => this.title = title;
  String getDescription() => description;
  void setDescription(String description) => this.description = description;
  double getPrice() => price;
  void setPrice(double price) => this.price = price;
  String getImageUrl() => imageUrl;
  void setImageUrl(String imageUrl) => this.imageUrl = imageUrl;
  String getId() => id;
  void setId(String id) => this.id = id;
  String getKeyPath() => keyPath;
  void setKeyPath(String keyPath) => this.keyPath = keyPath;

}
