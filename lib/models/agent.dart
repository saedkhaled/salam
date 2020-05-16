import 'dart:convert';

class Agent{
  String userName;
  String name;
  String photo;
  String uid;


  Agent({
    this.userName,
    this.name,
    this.photo,
    this.uid,
  });

  Agent copyWith({
    String userName,
    String name,
    String photo,
    String uid,
  }) =>
      Agent(
        userName: userName ?? this.userName,
        name: name ?? this.name,
        photo: photo ?? this.photo,
        uid: uid ?? this.uid,
      );

  factory Agent.fromJson(String str) => Agent.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Agent.fromMap(Map<String, dynamic> json) => Agent(
    userName: json["userName"] == null ? null : json["userName"],
    name: json["name"] == null ? null : json["name"],
    photo: json["photo"] == null ? null : json["photo"],
    uid: json["uid"] == null ? null : json["uid"],
  );

  Map<String, dynamic> toMap() => {
    "userName": userName == null ? null : userName,
    "name": name == null ? null : name,
    "photo": photo == null ? null : photo,
    "uid": uid == null ? null : uid,
  };

  String getUserName() => userName;
  void setUserName(String userName) => this.userName = userName;
  String getName() => name;
  void setName(String name) => this.name = name;
  String getPhoto() => photo;
  void setPhoto(String photo) => this.photo = photo;
  String getUid() => uid;
  void setUid(String uid) => this.uid = uid;

}