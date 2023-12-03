import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import './model_config.dart';
import 'package:sqflite/sqflite.dart';
import 'model_activation.dart';
import 'model_api_barcode.dart';
import 'package:flutter/foundation.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ArcPC.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ApiData ("
          "RecNo INTEGER PRIMARY KEY AUTOINCREMENT,"
          "ServerIP TEXT NOT NULL,"
          "PortNo TEXT NOT NULL,"
          "CreatedDate TEXT NOT NULL,"
          "UserType TEXT NOT NULL,"
          "Master TEXT NOT NULL,"
          "ImgScroll TEXT NOT NULL,"
          "MsgScroll TEXT NOT NULL,"
          "Logo TEXT NOT NULL,"
          "Speed TEXT NOT NULL,"
          "Country TEXT NOT NULL,"
          "Decimal TEXT NOT NULL"
          ")");
      print("Created table ApiData");
      await db.execute("CREATE TABLE Activation ("
          "RecNo INTEGER PRIMARY KEY AUTOINCREMENT,"
          "DeviceId TEXT NOT NULL,"
          "Salt TEXT NOT NULL,"
          "ActKey TEXT NOT NULL,"
          "TempKey TEXT NOT NULL,"
          "EncryptedKey TEXT NOT NULL"
          ")");
      print("Created table Activation");
    });
  }

////////////////////////////////////////Config Operations////////////////////////////////////////
  Future<String> newConfig(Config newConfig) async {
    //deleteConfig(1);
    final db = await database;
    print('=================================================================');
    //insert to the table using the new id
    var del = await (deleteConfig());
    print("old data deleted $del");
    var raw = await db.rawInsert(
        "INSERT Into ApiData (ServerIP,PortNo,CreatedDate,UserType,Master,ImgScroll,MsgScroll,Logo,Speed,Country,Decimal)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [
          newConfig.serverIP,
          newConfig.portNo,
          newConfig.createdDate,
          newConfig.userType,
          newConfig.master,
          newConfig.imgScroll,
          newConfig.msgScroll,
          newConfig.logo,
          newConfig.speed,
          newConfig.country,
          newConfig.decimal,
        ]);
    print("insert completed $raw");
    return ("Data Saved");
  }

  updateConfig(Config newConfig) async {
    final db = await database;
    var res = await db.update("ApiData", newConfig.toMap());
    return res;
  }

  getConfig() async {
    final db = await database;
    var res = await db.query("ApiData");
    return res.isNotEmpty ? Config.fromMap(res.first) : null;
  }

  getAllConfig() async {
    try {
      final db = await database;
      var res = await db.rawQuery('SELECT * FROM ApiData');
      // print(res.toString());
      // return res;
      return res.isEmpty ? '0': res;
    } catch (e) {
      print("Exception : $e");
      return ("Exception : $e");
    }
  }

  Future<List<Config>> getConfigData() async {
    var configMapList =
        await getConfigMapList(); // Get 'Map List' from database
    int count =
        configMapList.length; // Count the number of map entries in db table
    List<Config> configList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      configList.add(Config.fromMapObject(configMapList[i]));
    }
    return configList;
  }

  Future<List<Map<String, dynamic>>> getConfigMapList() async {
    Database db = await database;
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.rawQuery('SELECT * FROM ApiData');
    return result;
  }

  Future<List<Activation>> getActivationData() async {
    var activationMapList =
    await getActivationMapList(); // Get 'Map List' from database
    int count =
        activationMapList.length; // Count the number of map entries in db table
    List<Activation> activationList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      activationList.add(Activation.fromMapObject(activationMapList[i]));
    }
    return activationList;
  }

  Future<List<Map<String, dynamic>>> getActivationMapList() async {
    try{
      Database db = await database;
      var result = await db.rawQuery('SELECT * FROM Activation');
      return result;
    }
    catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<String> updateActivationDB(Activation newAct) async {
    final db = await database;
    var del = await (db.delete("Activation"));
    print("old data deleted $del");
    var raw = await db.rawInsert(
        "INSERT Into Activation (DeviceId,Salt,ActKey,TempKey,EncryptedKey)"
            " VALUES (?,?,?,?,?)",
        [
          newAct.deviceId,
          newAct.salt,
          newAct.actKey,
          newAct.tempKey,
          newAct.encryptedKey
        ]);
    print("insert completed");
    return ("Data Saved");
  }

  Future<String> getPCActivationData() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Activation");
    List<Activation> list =
    res.isNotEmpty ? res.map((c) => Activation.fromMapObject(c)).toList() : [];
    String jsonTags = jsonEncode(list);
    return jsonTags;
  }

  deleteActivation() async {
    final db = await database;
    // return db.delete("Activation");
    var stat;
    try{
      stat = await db.delete("Activation");
    }
    catch(e){
      print('Exception while deleting Activation. \n $e');
      return e.toString();
    }
    return stat.toString();
  }

  deleteConfig() async {
    final db = await database;
    return db.delete("ApiData");
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("ApiData * from Client");
  }

////////////////////////////////////////Config Operations////////////////////////////////////////
///////////////////////////////////////Initialise Databae///////////////////////////////////////
  Future deleteDb()async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ArcInv.db");
    var stat;
    try{
      await deleteDatabase(path);
    }
    catch(e){
      print('Exception while deleting Db. \n $e');
      return e.toString();
    }
    return 'True';
  }
///////////////////////////////////////Initialise Databae///////////////////////////////////////
}