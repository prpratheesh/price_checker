import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<PRICECHECK> barcodeFromJson(String str) => List<PRICECHECK>.from(json.decode(str).map((x) => PRICECHECK.fromJson(x)));
String barcodeToJson(List<PRICECHECK> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PRICECHECK {
  String barcode;
  String retail1;
  String retail2;
  String retail3;
  String pack;
  String packing;
  String spPrice;
  String lEngDesc;
  String sEngDesc;
  String arDesc;
  String spFlag;
  String spStart;
  String spEnd;
  bool stat;

  PRICECHECK({
    this.barcode,
    this.retail1,
    this.retail2,
    this.retail3,
    this.pack,
    this.packing,
    this.spPrice,
    this.lEngDesc,
    this.sEngDesc,
    this.arDesc,
    this.spFlag,
    this.spStart,
    this.spEnd,
    bool stat,
  });

  factory PRICECHECK.fromJson(Map<String, dynamic> json) =>
      PRICECHECK(
        barcode: json["Barcode"],
        retail1: json["Retail1"],
        retail2: json["Retail2"],
        retail3: json["Retail3"],
        pack: json["Pack"],
        packing: json["Packing"],
        spPrice: json["SpPrice"],
        lEngDesc: json["LEngDesc"],
        sEngDesc: json["SEngDesc"],
        arDesc: json["ArDesc"],
        spFlag: json["SpFlag"],
        spStart: json["SpStart"],
        spEnd: json["SpEnd"],
        stat: json['Stat'],
      );

  Map<String, dynamic> toJson() =>
      {
        "Barcode": barcode,
        "Retail1": retail1,
        "Retail2": retail2,
        "Retail3": retail3,
        "Pack": pack,
        "Packing": packing,
        "SpPrice": spPrice,
        "LEngDesc": lEngDesc,
        "SEngDesc": sEngDesc,
        "ArDesc": arDesc,
        "SpFlag": spFlag,
        "SpStart": spStart,
        "SpEnd": spEnd,
        "Stat": stat,
      };

  Map<String, dynamic> toMap() =>
      {
        "Barcode": barcode,
        "Retail1": retail1,
        "Retail2": retail2,
        "Retail3": retail3,
        "Pack": pack,
        "Packing": packing,
        "SpPrice": spPrice,
        "LEngDesc": lEngDesc,
        "SEngDesc": sEngDesc,
        "ArDesc": arDesc,
        "SpFlag": spFlag,
        "SpStart": spStart,
        "SpEnd": spEnd,
        "Stat": stat,
      };

  PRICECHECK.fromMapObject(Map<String, dynamic> map) {
    barcode = map['Barcode'];
    retail1 = map['Retail1'];
    retail2 = map['Retail2'];
    retail3 = map['Retail3'];
    pack = map['Pack'];
    packing = map['Packing'];
    spPrice = map['SpPrice'];
    lEngDesc = map['LEngDesc'];
    sEngDesc = map['SEngDesc'];
    arDesc = map['ArDesc'];
    spFlag = map['SpFlag'];
    spStart = map['SpStart'];
    spEnd = map['SpEnd'];
    stat = map['Stat'];
  }
}