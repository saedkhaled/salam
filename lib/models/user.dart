
// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';
import 'package:salam/models/agent.dart';
import 'package:salam/models/movement.dart';
import 'package:salam/models/order.dart';
import 'package:salam/models/price.dart';
class User {
  String userName;
  String password;
  String name;
  String phoneNumber;
  String parentUid;
  String email;
  String address;
  String userUid;
  double price;
  double currentBalance;
  List<Price> prices;
  List<String> otherRequests;
  List<String> messages;
  List<Movement> movements;
  List<Order> orders;
  List<Agent> agents;

  void checkMap() {
    if(this.userName == null)
      print("Alert: userName is null!!");
    if(this.password == null)
      print("Alert: password is null!!");
    if(this.name == null)
      print("Alert: name is null!!");
    if(this.phoneNumber == null)
      print("Alert: phoneNumber is null!!");
    if(this.parentUid == null)
      print("Alert: parentUid is null!!");
    if(this.email == null)
      print("Alert: email is null!!");
    if(this.address == null)
      print("Alert: address is null!!");
    if(this.userUid == null)
      print("Alert: userUid is null!!");
    if(this.prices == null)
      print("Alert: prices is null!!");
    if(this.currentBalance == null)
      print("Alert: currentBalance is null!!");
    if(this.price == null)
      print("Alert: price is null!!");
    if(this.otherRequests == null)
      print("Alert: otherRequests is null!!");
    if(this.messages == null)
      print("Alert: messages is null!!");
    if(this.movements == null)
      print("Alert: movements is null!!");
    if(this.orders == null)
      print("Alert: orders is null!!");
    if(this.agents == null)
      print("Alert: agents is null!!");
  }

  void correctUser() {
    if(this.userName == null)
      this.userName = '';
    if(this.password == null)
      this.password = '';
    if(this.name == null)
      this.name = '';
    if(this.phoneNumber == null)
      this.phoneNumber = '';
    if(this.parentUid == null)
      this.parentUid = '';
    if(this.email == null)
      this.email = '';
    if(this.address == null)
      this.address = '';
    if(this.userUid == null)
      this.userUid = '';
    if(this.prices == null)
      this.prices = List();
    if(this.currentBalance == null)
      this.currentBalance = 0.0;
    if(this.price == null)
      this.price = 0.0;
    if(this.otherRequests == null)
      this.otherRequests = List();
    if(this.messages == null)
      this.messages = List();
    if(this.movements == null)
      this.movements = List();
    if(this.orders == null)
      this.orders = List();
    if(this.agents == null)
      this.agents = List();
  }

  User({
    this.userName,
    this.password,
    this.name,
    this.phoneNumber,
    this.parentUid,
    this.email,
    this.address,
    this.userUid,
    this.prices,
    this.currentBalance,
    this.price,
    this.otherRequests,
    this.messages,
    this.movements,
    this.orders,
    this.agents,
  });


  User copyWith({
    String userName,
    String password,
    String name,
    String phoneNumber,
    String parentUid,
    String email,
    String address,
    String userUid,
    double price,
    double currentBalance,
    List<Price> prices,
    List<String> otherRequests,
    List<String> messages,
    List<Movement> movements,
    List<Order> orders,
    List<Agent> agents,
  }) =>
      User(
        userName: userName ?? this.userName,
        password: password ?? this.password,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        parentUid: parentUid ?? this.parentUid,
        email: email ?? this.email,
        address: address ?? this.address,
        userUid: userUid ?? this.userUid,
        prices: prices ?? this.prices,
        currentBalance: currentBalance ?? this.currentBalance,
        price: price ?? this.price,
        otherRequests: otherRequests ?? this.otherRequests,
        messages: messages ?? this.messages,
        movements: movements ?? this.movements,
        orders: orders ?? this.orders,
        agents: agents ?? this.agents,
      );

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    userName: json["userName"] == null ? null : json["userName"],
    password: json["password"] == null ? null : json["password"],
    name: json["name"] == null ? null : json["name"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    parentUid: json["parentUid"] == null ? null : json["parentUid"],
    email: json["email"] == null ? null : json["email"],
    address: json["address"] == null ? null : json["address"],
    userUid: json["userUid"] == null ? null : json["userUid"],
    currentBalance: json["currentBalance"] == null ? null : json["currentBalance"] as double,
    price: json["price"] == null ? null : json["price"] as double,
    prices: json["prices"] == null ? null : List<Price>.from(json["prices"].map((x) => Price.fromMap(x))),
    otherRequests: json["otherRequests"] == null ? null : List<String>.from(json["otherRequests"].map((x) => x)),
    messages: json["messages"] == null ? null : List<String>.from(json["messages"].map((x) => x)),
    movements: json["movements"] == null ? null : List<Movement>.from(json["movements"].map((x) => Movement.fromMap(x))),
    orders: json["orders"] == null ? null : List<Order>.from(json["orders"].map((x) => Order.fromMap(x))),
    agents: json["agents"] == null ? null : List<Agent>.from(json["agents"].map((x) => Agent.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "userName": userName == null ? null : userName,
    "password": password == null ? null : password,
    "name": name == null ? null : name,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "parentUid": parentUid == null ? null : parentUid,
    "email": email == null ? null : email,
    "address": address == null ? null : address,
    "userUid": userUid == null ? null : userUid,
    "prices": prices == null ? null : List<dynamic>.from(prices.map((x) => x.toMap())),
    "currentBalance": currentBalance == null ? null : currentBalance,
    "price": price == null ? null : price,
    "otherRequests": otherRequests == null ? null : List<dynamic>.from(otherRequests.map((x) => x)),
    "messages": messages == null ? null : List<dynamic>.from(messages.map((x) => x)),
    "movements": movements == null ? null : List<dynamic>.from(movements.map((x) => x.toMap())),
    "orders": orders == null ? null : List<dynamic>.from(orders.map((x) => x.toMap())),
    "agents": agents == null ? null : List<dynamic>.from(agents.map((x) => x.toMap())),
  };

  String getUserName() => userName;

  void setUserName(String name) => userName = name;

  String getPassword() => password;

  void setPassword(String password) => this.password = password;

  String getName() => name;

  void setName(String name) => this.name = name;

  double getCurrentBalance() => currentBalance;

  void setCurrentBalance(double currentBalance) => this.currentBalance = currentBalance;

  double getPrice() => price;

  void setPrice(double price) => this.price = price;

  List<String> getOtherRequests() => otherRequests;

  void setOtherRequests(List<String> otherRequests) => this.otherRequests = otherRequests;

  List<Price> getPrices() => prices;

  void setPrices(List<Price> prices) => this.prices = prices;

  List<String> getMessages() => messages;

  void setMessages(List<String> messages) => this.messages = messages;

  List<Movement> getMovements() => movements;

  void setMovements(List<Movement> movements) => this.movements = movements;

  List<Order> getOrderList() => orders;

  void setOrderList(List<Order> orderList) => this.orders = orderList;

  List<Agent> getAgentList() => agents;

  void setAgentList(List<Agent> agents) => this.agents = agents;

  String getPhoneNumber() => phoneNumber;

  void setPhoneNumber(String phoneNumber) => this.phoneNumber = phoneNumber;

  String getParentUid() => parentUid;

  void setParentUid(String parentUid) => this.parentUid = parentUid;

  String getEmail() => email;

  void setEmail(String email) => this.email = email;

  String getAddress() => address;

  void setAddress(String address) => this.address = address;

  String getUserUid() => userUid;

  void setUserUid(String userUid) => this.userUid = userUid;

}
