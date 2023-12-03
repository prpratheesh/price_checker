import 'dart:convert';

List<Activation> barcodeFromJson(String str) => List<Activation>.from(json.decode(str).map((x) => Activation.fromJson(x)));
String barcodeToJson(List<Activation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Activation {
  String recNo;
  String deviceId;
  String salt;
  String actKey;
  String tempKey;
  String encryptedKey;

  Activation({
    this.recNo,
    this.deviceId,
    this.salt,
    this.actKey,
    this.tempKey,
    this.encryptedKey,
  });

  factory Activation.fromJson(Map<String, dynamic> json) =>
      Activation(
        recNo: json["RecNo"],
        deviceId: json["DeviceId"],
        salt: json["Salt"],
        actKey: json["ActKey"],
        tempKey: json["TempKey"],
        encryptedKey: json["EncryptedKey"],
      );

  Map<String, dynamic> toJson() =>
      {
        "RecNo": recNo,
        "DeviceId": deviceId,
        "Salt": salt,
        "ActKey": actKey,
        "TempKey": tempKey,
        "EncryptedKey": encryptedKey,
      };

  Map<String, dynamic> toMap() =>
      {
        "RecNo": recNo,
        "DeviceId": deviceId,
        "Salt": salt,
        "ActKey": actKey,
        "TempKey": tempKey,
        "EncryptedKey": encryptedKey,
      };

  Activation.fromMapObject(Map<String, dynamic> map) {
    recNo = map['RecNo'].toString();
    deviceId = map['DeviceId'];
    salt = map['Salt'];
    actKey = map['ActKey'];
    tempKey = map['TempKey'];
    encryptedKey = map['EncryptedKey'];
  }
}

class ActivationListModel{
  List<Activation> ActivationList;
  ActivationListModel({this.ActivationList});
  ActivationListModel.fromJson(List<dynamic> parsedJson){
    ActivationList=new List<Activation>();
    parsedJson.forEach((v){
      ActivationList.add(Activation.fromJson(v));
    });
  }
}