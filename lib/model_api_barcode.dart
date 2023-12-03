// To parse this JSON data, do
//
//     final barcode = barcodeFromJson(jsonString);
import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<Barcode> barcodeFromJson(String str) => List<Barcode>.from(json.decode(str).map((x) => Barcode.fromJson(x)));
String barcodeToJson(List<Barcode> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Barcode {
  String barcode;
  String itemCode;
  String qty;
  String description;
  String avgCost;
  String retail;
  String priceLevel;
  String priceGroup;
  String packId;
  String locId;
  String lastNetCost;
  String lastRecPrice;
  String lastRecSupp;

  Barcode({
    this.barcode,
    this.itemCode,
    this.qty,
    this.description,
    this.avgCost,
    this.retail,
    this.priceLevel,
    this.priceGroup,
    this.packId,
    this.locId,
    this.lastNetCost,
    this.lastRecPrice,
    this.lastRecSupp,
  });

  factory Barcode.fromJson(Map<String, dynamic> json) =>
      Barcode(
          barcode: json["Barcode"],
          itemCode: json["ItemCode"],
          qty: json["Qty"],
          description: json["Description"],
          avgCost: json["AvgCost"],
          retail: json["Retail"],
          priceLevel: json["PriceLevel"],
          priceGroup: json["PriceGroup"],
          packId: json["PackId"],
          locId: json["LocId"],
          lastNetCost: json['LastNetCost'],
          lastRecPrice: json['LastRecPrice'],
          lastRecSupp :json['LastRecSupp'],
      );

  Map<String, dynamic> toJson() =>
      {
        "Barcode": barcode,
        "ItemCode": itemCode,
        "Qty": qty,
        "Description": description,
        "AvgCost": avgCost,
        "Retail": retail,
        "PriceLevel": priceLevel,
        "PriceGroup": priceGroup,
        "PackId": packId,
        "LocId" : locId,
        "LastNetCost" : lastNetCost,
        "LastRecPrice" : lastRecPrice,
        "LastRecSupp" : lastRecSupp,
      };

  Map<String, dynamic> toMap() =>
      {
        "Barcode": barcode,
        "ItemCode": itemCode,
        "Qty": qty,
        "Description": description,
        "AvgCost": avgCost,
        "Retail": retail,
        "PriceLevel": priceLevel,
        "PriceGroup": priceGroup,
        "PackId": packId,
        "LocId" : locId,
        "LastNetCost" : lastNetCost,
        "LastRecPrice" : lastRecPrice,
        "LastRecSupp" : lastRecSupp,
      };

  Barcode.fromMapObject(Map<String, dynamic> map) {
    barcode = map['Barcode'];
    itemCode = map['ItemCode'];
    qty = map['Qty'];
    description = map['Description'];
    avgCost = map['AvgCost'];
    retail = map['Retail'];
    priceLevel = map['PriceLevel'];
    priceGroup = map['PriceGroup'];
    packId = map['PackId'];
    locId = map['LocId'];
    lastNetCost = map['LastNetCost'];
    lastRecPrice = map['LastRecPrice'];
    lastRecSupp = map['LastRecSupp'];
  }
}

class BarcodeListModel{
  List<Barcode> barcodeList;
  BarcodeListModel({this.barcodeList});
  BarcodeListModel.fromJson(List<dynamic> parsedJson){
    barcodeList=new List<Barcode>();
    parsedJson.forEach((v){
      barcodeList.add(Barcode.fromJson(v));
    });
  }
}

// class BarcodeChangeNotifier with ChangeNotifier {
//   Barcode valuebar;
//   onNewBarcode(Barcode newbarcode){
//     this.valuebar = newbarcode;
//     notifyListeners();
//   }
// }