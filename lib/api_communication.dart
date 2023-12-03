import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import './model_config.dart';
import './db_operations.dart';
import './model_api_barcode.dart';
import 'flushbar.dart';
import 'model_activation.dart';
import 'model_api_barcode.dart';
import 'db_operations.dart';
import 'model_api_pos.dart';
import 'model_image.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Color snColor = Colors.red;
Color snDataColor = Colors.white;
var ipAddr;
var portNo;

////////////////////////////////////////Search Barcode from SQL SERVER////////////////////////////////////////
Future<PRICECHECK> searchPOSBarcode(String barcode, context) async {
  var ip ='0';
  var port ='0';
  var msg ='NA';
  PRICECHECK item = null;
  var val = await DBProvider.db.getAllConfig();
  if (val != null) {
    ip = val[0]['ServerIP'];
    port = val[0]['PortNo'];
  }
  else if ((val == null) || (val == '0')) {
    msg = 'Please configure Server Login Details';
    snackBardata(context, 'Configure API', 2, snColor, snDataColor);
    return null;
  }
  // print("http://"+serverDetails.serverIP+":"+serverDetails.portNo+"/API/GetSinglePOS/"+barcode);
  final uri = Uri.http('$ip'+':'+'$port','/API/GetProfileForPC/$barcode');
  print(uri);
  try {
    final res = await http.get(uri);
    print(res.statusCode);
    if (res.statusCode == 201) {
      var str = res.body;
      item = PRICECHECK.fromJson(json.decode(res.body));
      return item;
    } else{
      print('item nof found ---------------------------------------------');
      item = null;
      return item;
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    snackBardata(context, 'Error: ${e.toString()}', 4, snColor, snDataColor);
   return (e);
  }
}

Future<List<dynamic>>searchPOSBarcodePack(String barcode, context) async {
  var ip ='0';
  var port ='0';
  var msg ='NA';
  List<PRICECHECK> items;
  var bcode;
  var response;
  var val = await DBProvider.db.getAllConfig();
  if (val != null) {
    ip = val[0]['ServerIP'];
    port = val[0]['PortNo'];
  }
  else if ((val == null) || (val == '0')) {
    msg = 'Please configure Server Login Details';
    showMyiosGenDialog(context, 'Alert', 'Please configure Server Login Details');
  }
  // print("http://"+serverDetails.serverIP+":"+serverDetails.portNo+"/API/GetSinglePOS/"+barcode);
  final uri = Uri.http('$ip'+':'+'$port','/API/GetPackingPOS/$barcode');
  print(uri);
  try {
    response = await get(uri);
  }
  catch(e)
  {
    print('Error happened------------------------------------------------${e.toString()}');
    showMyiosGenDialog(context, 'Alert', 'Failed to load data');
  }
  if (response.statusCode == 201) {
    //method 1
    // If the call to the server was successful, parse the JSON
    // List<dynamic> values = [];
    // values = json.decode(response.body);
    // if (values.length > 0) {
    //   for (int i = 0; i < values.length; i++) {
    //     if (values[i] != null) {
    //       Map<String, dynamic> map = values[i];
    //       BarcodeList.add(Barcode.fromJson(map));
    //     }
    //   }
    // }
    //method 1
    items = await (json.decode(response.body) as List).map((i) =>
        PRICECHECK.fromJson(i)).toList();
    return items;
    //method 2
    // bcode = await (json.decode(response.body));
    // return await bcode;
  }
  else if(response.statusCode == 204)
  {
    return null;
    // throw Exception('Source database Empty');
  }
  else {
    // If that call was not successful, throw an error.
    showMyiosGenDialog(context, 'Alert', 'Failed to load data');
    // throw Exception('Failed to load data');
  }
}
////////////////////////////////////////Search Barcode from SQL SERVER////////////////////////////////////////

///////////////////////////////////////////Get Image List from API////////////////////////////////////////////
Future<List<IMAGELIST>> getImageListAPI(context) async {
  var ip ='0';
  var port ='0';
  var msg ='NA';
  IMAGELIST item = null;
  var val = await DBProvider.db.getAllConfig();
  if (val != null) {
    ip = val[0]['ServerIP'];
    port = val[0]['PortNo'];
  }
  else if ((val == null) || (val == '0')) {
    msg = 'Please configure Server Login Details';
    snackBardata(context, 'Configure API', 2, snColor, snDataColor);
    return null;
  }
  // print("http://"+serverDetails.serverIP+":"+serverDetails.portNo+"/API/GetSinglePOS/"+barcode);
  final uri = Uri.http('$ip'+':'+'$port','/API/GetPriceCheckerImagesList');
  print(uri);
  try {
    final res = await http.get(uri);
    print(res.statusCode);
    if (res.statusCode == 201) {
      var str = res.body;
      print(str);
      item = IMAGELIST.fromJson(json.decode(res.body));
      // return item;
    } else{
      print('item nof found ---------------------------------------------');
      item = null;
      // return item;
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    snackBardata(context, 'Error: ${e.toString()}', 4, snColor, snDataColor);
    return (e);
  }
}
///////////////////////////////////////////Get Image List from API////////////////////////////////////////////
Future<List<dynamic>> getImageListAPI2(context) async {
  var ip = '0';
  var port = '0';
  var msg = 'NA';
  int i = 0;
  var val = await DBProvider.db.getAllConfig();
  if (val != '0') {
    ip = val[0]['ServerIP'];
    port = val[0]['PortNo'];
  }
  else if ((val == null) || (val == '0') || val == '[]') {
    msg = 'Please Configure API';
    snackBardata(context, msg , 5, snColor, snDataColor);
    return null;
  }
  final uri = Uri.http('$ip' + ':' + '$port', '/API/GetPriceCheckerImagesList');
  // print(uri);
  try {
    final res = await http.get(uri);
    print(res.statusCode);
    if (res.statusCode == 201) {
      var data = jsonDecode(res.body);
      data = data['Asset'];
      print(data.runtimeType);
      return data;
      // for(i=0;i<data.length;i++)
      //   {
      //     print(data[i]);
      //   }
    }
    else {
      print(res.body.toString());
    }
  }
  catch (e) {
    return e;
  }
}

Future<String> getAPI(context) async {
  var ip ='0';
  var port ='0';
  String api = '';
  var val = await DBProvider.db.getAllConfig();
  if (val != null) {
    ip = val[0]['ServerIP'];
    port = val[0]['PortNo'];
    api = "http://"+ip+":"+port+"/API/GetPriceCheckerImage/";
    return api;
  }
  else if ((val == null) || (val == '0')) {
    api = '';
    snackBardata(context, 'Configure API', 2, snColor, snDataColor);
    return api;
  }
}

Future<String> getAPILogo(context) async {
  var ip ='0';
  var port ='0';
  String apiLogo = '';
  var val = await DBProvider.db.getAllConfig();
  if (val != null) {
    ip = val[0]['ServerIP'];
    port = val[0]['PortNo'];
    apiLogo = "http://"+ip+":"+port+"/API/GetPriceCheckerLogo/";
    return apiLogo;
  }
  else if ((val == null) || (val == '0')) {
    apiLogo = '';
    snackBardata(context, 'Configure API', 2, snColor, snDataColor);
    return apiLogo;
  }
}

Future<Config>  getConfig(context) async {
  var val = await DBProvider.db.getConfigData();
  return val[0];
  // var val = await DBProvider.db.getAllConfig();
  // if (val != null) {
  //   return val;
  // }
  // else if ((val == null) || (val == '0')) {
  //   value = '';
  //   snackBardata(context, 'Configure API', 2, snColor, snDataColor);
  //   return value;
  // }
}

Future<dynamic> getImage(context, String api, String img) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/$img');
  // final uri = (Uri.parse('$api' + 'API/GetPriceCheckerImage/$img'));
  final uri = (Uri.parse('$api' + '$img'));
  if (file.existsSync()) {
    print('file already exist');
    var image = await file.readAsBytes();
    return image;
  } else {
    print('file not found downloading from server');
    var request = await http.get(uri);
    // var request = await http.get(url,img);
    var bytes = await request.bodyBytes;//close();
    await file.writeAsBytes(bytes);
    print(file.path);
    return bytes;
  }
}

Future<dynamic> getLogo(context, apiLogo) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/Logo.jpg');
  // final uri = (Uri.parse('$api' + 'API/GetPriceCheckerImage/$img'));
  final uri = (Uri.parse('$apiLogo'));
  if (file.existsSync()) {
    print('file already exist');
    var image = await file.readAsBytes();
    return image;
  } else {
    print('file not found downloading from server');
    var request = await http.get(uri);
    // var request = await http.get(url,img);
    var bytes = await request.bodyBytes;//close();
    await file.writeAsBytes(bytes);
    print(file.path);
    return bytes;
  }
}

Future<String> getScrollMsg(context) async {
  var message = null;
  var ip ='0';
  var port ='0';
  var val = await DBProvider.db.getAllConfig();
  if (val != null) {
    ip = val[0]['ServerIP'];
    port = val[0]['PortNo'];
    final uri = Uri.http('$ip'+':'+'$port','/API/GetPriceCheckerMsg');
    final res = await http.get(uri);
    try {
      final res = await http.get(uri);
      if (res.statusCode == 201) {
        message = (json.decode(utf8.decode(res.bodyBytes)));
        return message['Data'];
      } else{
        message = '';
        return 'Cannot Load Messages';
      }
    }catch (e) {
      print('Error: ${e.toString()}');
      snackBardata(context, 'Error: ${e.toString()}', 4, snColor, snDataColor);
      return (e);
    }
  }
  else if ((val == null) || (val == '0')) {
    message = '';
    snackBardata(context, 'Configure API', 2, snColor, snDataColor);
    return message;
  }
}
////////////////////////////////////////Activation Data from Local DB ////////////////////////////////////////
Future <String>fetchAndSendActivationData() async {
  Config serverDetails  = await DBProvider.db.getConfig();
  String payload = await DBProvider.db.getPCActivationData();
  print(payload.toString());
  // String data = jsonEncode(payload);
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"title": "Hello", "body": "body text", "userId": 1}';
  // var responseJson = "http://"+serverDetails.serverIP+":"+serverDetails.portNo+"/API/SaveStockData";
  var ip = serverDetails.serverIP;
  var port=serverDetails.portNo;
  final uri = Uri.http('$ip'+':'+'$port','/API/SavePCActivationData');
  try {
    final res = await post(uri, headers: headers, body: payload);
    if(res.statusCode == 201)
    {
      var paylodBkup = jsonDecode(payload);
      final parsed = jsonDecode(res.body);
      var value = parsed['RowCount'];
      int i = value;
      // print(("Success Updated $i Records"));
      return ("Success \n Updated $i Records");
    }
    else{
      return ("Server Update Failure");
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    return ('Error: ${e.toString()}');
  }
}

Future<Activation> getActivationLocalDB(context) async {
  var val = await DBProvider.db.getActivationData();
  print(val.toString());
  return val.isNotEmpty ? val[0]:null;
}

Future<String> updateActivationLocalDB(Activation newAct) async{
  var val = await DBProvider.db.updateActivationDB(newAct);
  return val.isEmpty ? val : null;
}

Future<String> deleteActivationLocalDB() async{
  var val = await DBProvider.db.deleteActivation();
  // print(val.toString());
  return '';
}

Future<Activation> getActivationFromDB(context, String deviceId) async {
  Activation item;
  var ip ='0';
  var port ='0';
  var msg ='NA';
  var val = await DBProvider.db.getAllConfig();
  if (val != null) {
    ip = val[0]['ServerIP'];
    port = val[0]['PortNo'];
  }
  else if ((val == null) || (val == '0')) {
    msg = 'Please configure Server Login Details';
    snackBardata(context, 'Configure API', 2, snColor, snDataColor);
    return null;
  }
  // print("http://"+serverDetails.serverIP+":"+serverDetails.portNo+"/API/GetSinglePOS/"+barcode);
  print('--------------------------------------------------');
  print(deviceId);
  print('--------------------------------------------------');
  final uri = Uri.http('$ip'+':'+'$port',"/API/GetActivationDataForPC/${deviceId.toString()}");
  print(uri);
  try {
    final res = await http.get(uri);
    print(res.statusCode);
    if (res.statusCode == 201) {
      var str = res.body;
      // print(str);
      item = Activation.fromJson(json.decode(res.body));
      return item;
    } else{
      snackBardata(context, 'Activation Data not found in server', 4, snColor, snDataColor);
      try {
        var result = fetchAndSendActivationData();
        snackBardata(
            context, 'Writing Server Data', 2, Colors.red, Colors.white);
      }
      catch(e) {
        snackBardata(
            context, 'Please Reinstall the application', 2, Colors.red, Colors.white);
      }
      item = null;
      return item;
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    snackBardata(context, 'Error: ${e.toString()}', 4, snColor, snDataColor);
    return (e);
  }
}
////////////////////////////////////////Activation Data from Local DB ////////////////////////////////////////