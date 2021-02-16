import 'dart:convert';

class ServiceInfoList {
  ServiceInfo serviceInfo;

  ServiceInfoList({
    this.serviceInfo
  });

  ServiceInfoList copyWith({
    ServiceInfo serviceInfo
  }) =>
      ServiceInfoList(
          serviceInfo: serviceInfo ?? this.serviceInfo
      );

  factory ServiceInfoList.fromJson(String str, String service) => ServiceInfoList.fromMap(json.decode(str), service);

  String toJson() => json.encode(toMap());

  factory ServiceInfoList.fromMap(Map<String, dynamic> json, String service) {
    ServiceInfo serviceInfo = ServiceInfo();
    if(service == "wa")
      serviceInfo = json["whatsapp"] == null ? null : ServiceInfo.fromMap(json["whatsapp"]);
    if(service == "vi")
      serviceInfo = json["viber"] == null ? null : ServiceInfo.fromMap(json["viber"]);
    if(service == "tg")
      serviceInfo = json["telegram"] == null ? null : ServiceInfo.fromMap(json["telegram"]);
    if(service == "im")
      serviceInfo = json["imo"] == null ? null : ServiceInfo.fromMap(json["imo"]);
    if(service == "fb")
      serviceInfo = json["facebook"] == null ? null : ServiceInfo.fromMap(json["facebook"]);
    if(service == "yl")
      serviceInfo = json["yalla"] == null ? null : ServiceInfo.fromMap(json["yalla"]);
    return ServiceInfoList(
      serviceInfo: serviceInfo,
  );
  }

  Map<String, dynamic> toMap() => {
    "whatsapp": serviceInfo == null ? null : serviceInfo.toMap(),
  };
}

class ServiceInfo{
  String category;
  int qty;
  dynamic price;
  ServiceInfo({
    this.category,
    this.qty,
    this.price
  });
  factory ServiceInfo.fromJson(String str) => ServiceInfo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServiceInfo.fromMap(Map<String, dynamic> json) => ServiceInfo(
    category: json["Category"] == null ? null : json["Category"],
    qty: json["Qty"] == null ? null : json["Qty"] as int,
    price: json["Price"] == null ? null : json["Price"] as dynamic
  );

  Map<String, dynamic> toMap() => {
    "Category": category == null ? null : category,
    "Qty": qty == null ? null : qty,
    "Price": price == null ? null : price,
  };

}