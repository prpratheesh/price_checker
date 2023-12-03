import 'dart:convert';

import 'package:flutter/cupertino.dart';

List<IMAGELIST> barcodeFromJson(String str) => List<IMAGELIST>.from(json.decode(str).map((x) => IMAGELIST.fromJson(x)));
String barcodeToJson(List<IMAGELIST> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IMAGELIST {
  String asset;

  IMAGELIST({
    this.asset,
  });

  factory IMAGELIST.fromJson(Map<String, dynamic> json) =>
      IMAGELIST(
        asset: json["Asset"],
      );

  Map<String, dynamic> toJson() =>
      {
        "Asset": asset,
      };

  Map<String, dynamic> toMap() =>
      {
        "Asset": asset,
      };

  IMAGELIST.fromMapObject(Map<String, dynamic> map) {
    asset = map['Asset'];
  }
}