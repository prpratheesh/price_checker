import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import './model_config.dart';
import './db_operations.dart';
import 'alert_dialogue.dart';

Future<String> attemptLogIn(String username, String password) async {
  Config serverDetails = await DBProvider.db.getConfig();
  // var responseJson = "http://"+serverDetails.serverIP+":"+serverDetails.portNo+"/API_Login";
  var ip = serverDetails.serverIP;
  var port=serverDetails.portNo;
  final uri = Uri.http('$ip'+':'+'$port','/API_Login');
  print(uri);
  try {
    final res = await post(uri, body: {"username": username, "password": password});
    print(res.statusCode);
    if (res.statusCode == 201) {
      print("Success");
      return "Success";
    } else {
      print("Error");
      return "Error";
    }
  } catch (e) {
    print('Exception: ${e.toString()}');
    return ('Exception');
  }
}

Future<List<dynamic>> compareDb() async {
  Config serverDetails;
  int serverCnt;
  int sqliteCnt;
  List val = [int,int];

  try {
    serverDetails = await DBProvider.db.getConfig();
    // print("Got local db config");
  }
  catch(e){
    print("Error while getting local db config +$e");
  }
  try {
    // val[1] = (await DBProvider.db.getAllBarcodeCount()).toString();
  }
  catch(e) {
    print("Error while getting local db barcode count +$e");
  }
  var ip = serverDetails.serverIP;
  var port=serverDetails.portNo;
  // final client = await ("http://" + serverDetails.serverIP + ":" + serverDetails.portNo + "/API/GetProfileCount");
  final uri = Uri.http('$ip'+':'+'$port','/API/GetProfileCount');
  print(uri.toString());
  try {
    final res = await get(uri);
    if (res.statusCode == 200) {
      val[0] = (json.decode(res.body)).toString();
    } else {
      return ['Error'];
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    return [serverCnt,];
  }
  return val;
}

Future<String> testLogIn(String serverIP, String portNo) async {
  // var addr = await ("http://" + serverIP + ":" + portNo + "/API_Test")as Uri;
  final uri = Uri.http('$serverIP'+':'+'$portNo','/API_Test');
  // print(uri);
  try {
    final res = await post(uri);
    // print(res);
    if (res.statusCode == 201) {
      return "Server Connected";
    } else {
      return "Error";
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    return ('Error Connecting Server');
  }
}

Future<String> getDate() async{
  Config serverDetails = await DBProvider.db.getConfig();
  // var responseJson = "http://" +serverDetails.serverIP +":" +serverDetails.portNo +"/GetDate";
  var ip = serverDetails.serverIP;
  var port=serverDetails.portNo;
  final uri = Uri.http('$ip'+':'+'$port','/GetDate');
  print(uri);
  try {
    final res = await post(uri);
    var val =  (await(res.body.toString()));
    return val;
  } catch (e) {
    print('Error: ${e.toString()}');
    return ('Error');
  }
}

Future<String> testServerConnection() async {
  Config serverDetails = await DBProvider.db.getConfig();
  // var addr = "http://" +serverDetails.serverIP +":" +serverDetails.portNo +"/API_Test";
  var ip = serverDetails.serverIP;
  var port=serverDetails.portNo;
  // final client = await ("http://" + serverDetails.serverIP + ":" + serverDetails.portNo + "/API/GetProfileCount");
  final uri = Uri.http('$ip'+':'+'$port','/API_Test');
  print(uri);
  try {
    final res = await http.post(uri);
    print(res);
    if (res.statusCode == 201) {
      return "Ok";
    } else {
      return "Error";
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    return ("Exception");
  }
}
