import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import './model_config.dart';
import './db_operations.dart';
import 'api_communication.dart';
import 'flushbar.dart';
import 'login_control.dart';
import 'model_activation.dart';
import 'model_api_barcode.dart';
import 'alert_dialogue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';

class ConfigAPI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConfigAPIState();
}

class ConfigAPIState extends State<ConfigAPI> {
  final GlobalKey<ScaffoldState> _scaffoldKeyAPI =
      new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _ipController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  TextEditingController _keyPairAcontroller = TextEditingController();
  TextEditingController _keyPairBcontroller = TextEditingController();
  var upd = 1;
  var upd_progress = 0;
  var ipAddress = '';
  var portNo = '';
  var progress_bar = 0;
  String uniqueId = "Unknown";
  DateTime now = DateTime.now();
  // final ValueNotifier<double> downloaded = ValueNotifier<double>(0.0);
  // var downloaded = ValueNotifier(0.0);
  // ValueNotifier<double> progress = ValueNotifier<double>(0.0);
  bool isLoading = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController locIdController = TextEditingController();

  Color snColor = Colors.blueAccent.withOpacity(0.8);
  Color snDataColor = Colors.white;
  bool ImgScroll = false;
  bool MsgScroll = false;
  bool Logo = false;
  List<Config> dbDatas;
  Config dbData;
  String _dropDownValueSpeech = 'Speech Speed';
  String _dropDownValueCountry = 'Select Country';
  String _dropDownValueDecimalDigit = 'Select Decimal Digit';
  String Speed = '0.5';
  String Country = 'UAE';
  String Decimal = '2';
  bool licenseUpd = false;
  List<Activation> dbAct;
  Activation actData;
  var cryptor = PlatformStringCryptor();

  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    readConfig();
    super.initState();
  }

  readLicense() async {
    try {
      dbAct = await DBProvider.db.getActivationData();
      actData = await dbAct[0];
      if (actData.tempKey != null) {
        setState(() {
          licenseUpd = false;
          _keyPairAcontroller.text = actData.tempKey;
          _keyPairBcontroller.text = actData.encryptedKey;
        });
      }
    } catch (e) {
      print("Exception : $e");
      return ("Exception : $e");
    }
  }

  readConfig() async {
    try {
      dbDatas = await DBProvider.db.getConfigData();
      dbData = await dbDatas[0];
      if (dbData.serverIP != null) {
        _ipController.text = dbData.serverIP;
        _portController.text = dbData.portNo;
        setState(() {
          upd = 0;
        });
        if (dbData.imgScroll == 'true') {
          setState(() {
            ImgScroll = true;
          });
        } else {
          setState(() {
            ImgScroll = false;
          });
        }
        if (dbData.msgScroll == 'true') {
          setState(() {
            MsgScroll = true;
          });
        } else {
          setState(() {
            MsgScroll = false;
          });
        }
        if (dbData.logo == 'true') {
          setState(() {
            Logo = true;
          });
        } else {
          setState(() {
            Logo = false;
          });
        }
        if (dbData.speed != null)
          setState(() {
            Speed = dbData.speed;
          });
        else {
          setState(() {
            Speed = '1.0';
          });
        }
      } else {
        _ipController.text = ' ';
        _portController.text = ' ';
      }
    } catch (e) {
      print("Exception : $e");
      return ("Exception : $e");
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.green,
        width: 2.0,
      ),
    );
  }

  Widget image() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: new BorderRadius.circular(30.0),
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage('assets/asset13.jpg'),
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
//     return Container(
//         width: MediaQuery.of(context).size.width,
//         padding: EdgeInsets.symmetric(vertical: 13),
//         alignment: Alignment.center,
// //        padding: EdgeInsets.all(10),
//         child: RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               text: 'API CONFIGURATION',
//               style: GoogleFonts.portLligatSans(
//                 textStyle: Theme.of(context).textTheme.headline4,
//                 fontSize: 30,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.white,
//               ),
//             )));
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'S',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 60,
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
          children: [
            TextSpan(
              text: 'ystem ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: 'S',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 60,
                  fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: 'etting',
              style: TextStyle(color: Colors.black, fontSize: 50),
            ),
          ]),
    );
  }

  Widget _serverIP() {
    if (upd == 1) {
      readConfig();
    }
    return Container(
        width: MediaQuery.of(context).size.width / 1.2,
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
//        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: TextFormField(
          controller: _ipController,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Enter Server IP Address',
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              ),
            ),
          ),
        ));
  }

  Widget _portNo() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.2,
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
//        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: TextFormField(
          controller: _portController,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Enter Port Number',
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              ),
            ),
          ),
        ));
  }

  Widget _licenseInfoA() {
    if (licenseUpd == false) {
      readLicense();
    }
    return Container(
        width: MediaQuery.of(context).size.width / 1.2,
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
//        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: TextFormField(
          enabled: false,
          controller: _keyPairAcontroller,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'KeyPairB:',
            hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
              ),
            ),
          ),
        ));
  }

  Widget _saveButton() {
    return InkWell(
      onTap: () async {
        upd = 1;
        var ip = _ipController.text;
        var port = _portController.text;
        print(ip);
        print(port);
        var con = Config(
          serverIP: ip.trim(),
          portNo: port.trim(),
          createdDate: (DateTime.now()).toString(),
          userType: 'API',
          master: '0',
          imgScroll: ImgScroll.toString(),
          msgScroll: MsgScroll.toString(),
          logo: Logo.toString(),
          speed: Speed.toString(),
          country: Country.toString(),
          decimal: Decimal.toString(),
        );
        try {
          var resp = await DBProvider.db.newConfig(con);
          print(resp.toString());
          snackBardata(context, resp.toString(), 2, snColor, snDataColor);
        } catch (e) {
          print(e.toString());
          snackBardata(context, e.toString(), 2, snColor, snDataColor);
        }
        await Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 14,
        // padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.red),
        child: Text(
          'Save',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }

  Widget _testButton() {
    return InkWell(
      onTap: () async {
        var ip = _ipController.text.trim();
        var port = _portController.text.trim();
        var resp = await (testLogIn(ip, port));
        snackBardata(context, resp.toString(), 2, snColor, snDataColor);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 14,
        // padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.green[700]),
        child: Text(
          'Test',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }

  Widget _licenseDeleteButton() {
    return InkWell(
      onTap: () async {
        try {
          var tamp = await (deleteActivationLocalDB());
          snackBardata(
              context, 'License Data Deleted', 4, snColor, snDataColor);
        } catch (e) {
          print('Error: ${e.toString()}');
          snackBardata(
              context, 'Error: ${e.toString()}', 4, snColor, snDataColor);
          return (e);
        }
        await Future.delayed(const Duration(seconds: 3), () {
          Restart.restartApp();
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 14,
        // padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.blue[700]),
        child: Text(
          'Delete License',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }

  Widget _restartButton() {
    return InkWell(
      onTap: () async {
        await Future.delayed(const Duration(seconds: 3), () {
          Restart.restartApp();
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 14,
        // padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.blueAccent),
        child: Text(
          'Restart Device',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }

  Widget _initializeButton() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        // final dialogue = AlertDialogue();
        var stat = await showMyiosDialog(context, "DATABASE DELETE",
            "Existing Database will be deleted!!! \n Do you want to Proceed??");
        // var stat = await dialogue.onAlertWithStylePressed(context);
        print(stat);
        if (stat == 'Y') {
          var resp = await DBProvider.db.deleteDb();
          if (resp == 'True') {
            snackBardata(
                context, 'Database Deleting.....', 2, snColor, snDataColor);
          } else {
            snackBardata(context, 'Error Deleting Database.', 2, Colors.red,
                snDataColor);
          }
          try {
            await DBProvider.db.initDB();
            snackBardata(
                context,
                'Database Initialization Complete. \n Please Exit and Login Again...',
                2,
                snColor,
                snDataColor);
            Future.delayed(Duration(seconds: 5), () {
              Navigator.of(context).pop();
            });
          } catch (e) {
            snackBardata(context, 'Error while Creating Db. \n $e', 2,
                Colors.red, snDataColor);
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.height / 14,
        // padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black45,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 5)
            ],
            color: Colors.green),
        child: Text(
          'Initialize DB',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }

  Widget selectionOptionsFirstRow() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.2,
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: CheckboxListTile(
                  title: Text("Image Scroll",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal)),
                  value: ImgScroll,
                  onChanged: (newValue) {
                    setState(() {
                      ImgScroll = newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )),
            Expanded(
                flex: 1,
                child: CheckboxListTile(
                  title: Text("Message Scroll",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal)),
                  value: MsgScroll,
                  onChanged: (newValue) {
                    setState(() {
                      MsgScroll = newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )),
            Expanded(
                flex: 1,
                child: CheckboxListTile(
                  title: Text("Logo",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal)),
                  value: Logo,
                  onChanged: (newValue) {
                    setState(() {
                      Logo = newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )),
            Expanded(
                flex: 1,
                child: DropdownButton(
                  hint: _dropDownValueSpeech == null
                      ? Center(
                          child: Text(Speed.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal)))
                      : Center(
                          child: Text(
                          _dropDownValueSpeech,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        )),
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  style: TextStyle(color: Colors.black),
                  items: [
                    '0.1',
                    '0.2',
                    '0.3',
                    '0.4',
                    '0.5',
                    '0.6',
                    '0.7',
                    '0.8',
                    '0.9',
                    '1.0'
                  ].map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold)),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        _dropDownValueSpeech = val;
                        Speed = val;
                      },
                    );
                  },
                )),
          ],
        ));
  }

  Widget selectionOptionsSecondRow() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.2,
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: DropdownButton(
                  hint: _dropDownValueCountry == null
                      ? Center(
                          child: Text(Speed.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal)))
                      : Center(
                          child: Text(
                          _dropDownValueCountry,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        )),
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  style: TextStyle(color: Colors.black),
                  items: ['BAHRAIN', 'OMAN', 'QATAR', 'SAUDI', 'UAE'].map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold)),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        _dropDownValueCountry = val;
                        Country = val;
                      },
                    );
                  },
                )),
            Expanded(
                flex: 1,
                child: DropdownButton(
                  isExpanded: true,
                  hint: _dropDownValueDecimalDigit == null
                      ? Center(
                          child: Text(Speed.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal)))
                      : Center(
                          child: Text(
                          _dropDownValueDecimalDigit,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        )),
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  items: ['2', '3'].map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold)),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        _dropDownValueDecimalDigit = val;
                        Decimal = val;
                      },
                    );
                  },
                )),
          ],
        ));
  }

  void generateLicense() async {
    Activation newAct = Activation();
    newAct.deviceId = generateRandomString(50);
    newAct.salt = 'BWZBx71nqahWnmA1o99wkqwDB0zN228Jv8Eq0hGo9fcbzacL';
    newAct.actKey = 'XXX';
    newAct.tempKey = await cryptor.generateKeyFromPassword(newAct.deviceId, newAct.salt);
    newAct.encryptedKey = await cryptor.encrypt(newAct.deviceId, newAct.tempKey);
    try {
      var val = await (updateActivationLocalDB(newAct));
      snackBardata(context, 'Generating License', 2, Colors.red, Colors.white);
      var result = fetchAndSendActivationData();
      snackBardata(context, 'Writing Server Data', 2, Colors.red, Colors.white);
    } catch (e) {
      print(e.toString());
      snackBardata(context, e.toString(), 2, Colors.red, Colors.white);
    }
  }

  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars ='AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();
    return randomString;
  }

  Widget progBar() {}

  loader(double progress, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                    strokeWidth: 5.0,
                    value: progress,
                  ),
                  // ),
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width / 3,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Text(message),
                ),
              ],
            ),
          ),
        );
      },
    );
    // new Future.delayed(new Duration(seconds: 3), () {
    //   Navigator.pop(context); //pop dialog
    // });
    if (progress >= 0.9999) {
      Navigator.pop(context); //pop dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.amber, Colors.yellow])),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _title(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 75,
                ),
                // image(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 75,
                ),
                _serverIP(),
                _portNo(),
                _licenseInfoA(),
                selectionOptionsFirstRow(),
                selectionOptionsSecondRow(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
//                      gradient: LinearGradient(
//                          begin: Alignment.topCenter,
//                          end: Alignment.bottomCenter,
//                          colors: [Colors.blue, Colors.blueAccent])
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _licenseDeleteButton(),
                          _testButton(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _restartButton(),
                          _saveButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void snackBardata(context, String actionMsg, var duration, Color snColour,
      Color snDataColor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        actionMsg,
        style: TextStyle(
          color: snDataColor,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
      backgroundColor: snColour,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ));
  }
}
