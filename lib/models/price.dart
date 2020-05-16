import 'dart:convert';

class Price {
  double amount;
  String id;

  Price({
    this.amount,
    this.id,
  });

  Price copyWith({
    double amount,
    String id,
  }) =>
      Price(
        amount: amount ?? this.amount,
        id: id ?? this.id,
      );

  factory Price.fromJson(String str) => Price.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Price.fromMap(Map<String, dynamic> json) => Price(
    amount: json["amount"] == null ? null : json["amount"].toDouble(),
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toMap() => {
    "amount": amount == null ? null : amount,
    "id": id == null ? null : id,
  };

  double getAmount() => amount;
  void setAmount(double amount) => this.amount = amount;
  String getId() => id;
  void setId(String id) => this.id = id;

}