import 'dart:convert';

Config configFromJson(String str) {
  final jsonData = json.decode(str);
  return Config.fromMap(jsonData);
}

String configToJson(Config data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Config {
  String recNo;
  String serverIP;
  String portNo;
  String createdDate;
  String userType;
  String master;
  String imgScroll;
  String msgScroll;
  String logo;
  String speed;
  String country;
  String decimal;

  Config({
    this.recNo,
    this.serverIP,
    this.portNo,
    this.createdDate,
    this.userType,
    this.master,
    this.imgScroll,
    this.msgScroll,
    this.logo,
    this.speed,
    this.country,
    this.decimal,
  });

  factory Config.fromMap(Map<String, dynamic> json) => Config(
      recNo: json["RecNo"].toString(),
      serverIP: json["ServerIP"],
      portNo: json["PortNo"],
      createdDate: json["CreatedDate"],
      userType: json["UserType"],
      master: json["Master"],
      imgScroll: json["ImgScroll"],
      msgScroll: json["MsgScroll"],
      logo: json["Logo"],
      speed: json["Speed"],
      country: json["Country"],
      decimal: json["Decimal"],
  );

  Map<String, dynamic> toMap() => {
    "RecNo": recNo,
    "ServerIP": serverIP,
    "PortNo": portNo,
    "CreatedDate":createdDate,
    "UserType": userType,
    "Master": master,
    "ImgScroll": imgScroll,
    "MsgScroll": msgScroll,
    "Logo": logo,
    "Speed": speed,
    "Country": country,
    "Decimal": decimal,
  };

  Config.fromMapObject(Map<String, dynamic> map) {
    recNo = map['RecNo'].toString();
    serverIP = map['ServerIP'];
    portNo = map['PortNo'];
    createdDate = map['CreatedDate'];
    userType = map['UserType'];
    master = map['Master'];
    imgScroll = map['ImgScroll'];
    msgScroll = map['MsgScroll'];
    logo = map['Logo'];
    speed = map['Speed'];
    country = map['Country'];
    decimal = map['Decimal'];
  }
}