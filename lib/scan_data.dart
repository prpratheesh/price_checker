import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'api_communication.dart';
import 'config_data.dart';
import 'flushbar.dart';
import 'model_activation.dart';
import 'model_api_pos.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'model_config.dart';
import 'model_image.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'dart:ui' as ui;
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
//SALT = BWZBx71nqahWnmA1o99wkqwDB0zN228Jv8Eq0hGo9fcbzacL

class ScanData extends StatefulWidget {
  ScanData({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ScanDataState createState() => _ScanDataState();
}

class _ScanDataState extends State<ScanData> {
  TextEditingController barcodeController = TextEditingController();
  TextEditingController lEngName = TextEditingController();
  TextEditingController sEngName = TextEditingController();
  TextEditingController aRName = TextEditingController();
  TextEditingController retail1 = TextEditingController();
  TextEditingController retail2 = TextEditingController();
  TextEditingController retail3 = TextEditingController();
  TextEditingController promotion = TextEditingController();
  TextEditingController promotion2 = TextEditingController();

  // FocusNode = barcodeController;
  bool loader = false;
  PRICECHECK localList = PRICECHECK();
  IMAGELIST imagelist = IMAGELIST();
  String _barcode;
  bool visible;
  bool enableField = false;
  bool mode = false;
  bool promoMsg = false;
  bool promoMsgM2 = false;
  var disaplyPackMode = false;
  bool packDisplayActive = false;
  List barcode;
  Color mode2spColor = Colors.deepOrange;
  bool mode2indFlag = false;
  bool sp_status = false;
  bool dispStat = false;
  bool nfpluVal = true;
  var upd = 1;
  FocusNode myFocusNode;
  String text = "Item Not Found";
  bool isPlaying = false;
  FlutterTts _flutterTts;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 1.0;
  bool imgLoad = false;
  var imageList;
  String api = '';
  String apiLogo = '';
  Directory appDocsDir;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer timer;
  bool downldStatus = false;
  bool imgConvert = false;
  List imgList = [];
  bool readRoll = false;
  Image shipped;
  File imageFile = File('dir/{imageList[i]}');
  File tempImg = File('dir/{imageList[i]}');
  int i = 0;
  String dir = '';
  String imgPath = '';
  Config config;
  bool dwnldMsgStatus = false;
  String scrlMsg = '';
  bool textScroll = false;
  bool logoDownload = false;
  bool logoFn = false;
  File logo = File('dir/{imageList[i]}');
  String logoPath = '';
  bool editMode = false;
  var deltax;
  String currency = '';
  String deviceId, salt, actKey, tempKey, encryptedKey;
  var key = "null";
  String encryptedS, decryptedS;
  var password = "null";
  // PlatformStringCryptor cryptor;
  var cryptor = PlatformStringCryptor();
  bool chkLicense = false;
  bool licenseStatus = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initializeTts();
    getConfigData(context);
    getActivationData(context);
    getImageList(context);
    myFocusNode = FocusNode();
    getApiData(context);
    getApiLogoData(context);
    downloadImage();
    downloadTextMsg();
    downloadLogo();
    // downloadTextMsg();
    // timer = Timer.periodic(Duration(seconds: 5), (Timer t) => downloadImage());
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => changeImage());
  }

  @override
  void dispose() {
    barcodeController.dispose();
    myFocusNode.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
                key: _scaffoldKey,
                body: Stack(
                    alignment: Alignment.center,
                    // textDirection: TextDirection.,
                    fit: StackFit.loose,
                    overflow: Overflow.visible,
                    clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      Container(
                          child: readRoll
                              ? Image.file(
                                  File(imgPath),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.fill,
                                  repeat: ImageRepeat.noRepeat,
                                  alignment: Alignment.center,
                                  color: Colors.transparent,
                                  colorBlendMode: BlendMode.darken,
                                  gaplessPlayback: true,
                                  // scale: 4,
                                  errorBuilder: (
                                    BuildContext context,
                                    Object error,
                                    StackTrace stackTrace,
                                  ) {
                                    print(error);
                                    print(stackTrace);
                                    return Container(
                                      color: Colors.grey,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Center(
                                        child: Text('Loading Images...',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25.0),
                                            textAlign: TextAlign.center),
                                      ),
                                    );
                                  },
                                  frameBuilder: (
                                    BuildContext context,
                                    Widget imgFrame,
                                    int frame,
                                    bool wasSynchronouslyLoaded,
                                  ) {
                                    return Container(
                                      child: imgFrame,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/asset2.jpg',
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.fill,
                                )),
                      Positioned(
                          bottom: MediaQuery.of(context).size.height / 50,
                          child: Container(
                              child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      color: Colors.black26),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.add_box,
                                              color: editMode == false
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 28),
                                          onPressed: () {
                                            setState(() {
                                              editMode = !editMode;
                                            });
                                            // if(editMode==true)
                                            //   {
                                            //
                                            //   }
                                          },
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20,
                                          // color: Colors.red,
                                          child: Center(
                                            child: BarcodeKeyboardListener(
                                              bufferDuration:
                                                  Duration(milliseconds: 200),
                                              onBarcodeScanned: (barcode) {
                                                setState(() {
                                                  _barcode = barcode;
                                                  barcodeController.text =
                                                      barcode.toString();
                                                  if (verifyBarcode(barcode)) {
                                                    getBarcode(_barcode);
                                                  }
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  editMode == false
                                                      ? Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            _barcode == null
                                                                ? ''
                                                                : '$_barcode',
                                                            // controller: barcodeController,
                                                            // barcodeController.text,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .yellow,
                                                                fontSize: 20,
                                                                letterSpacing:
                                                                    3,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))
                                                      : Expanded(
                                                          flex: 1,
                                                          child: TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller:
                                                                barcodeController,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .yellow,
                                                                fontSize: 20,
                                                                letterSpacing:
                                                                    3,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                            onFieldSubmitted:
                                                                (barcode) {
                                                              setState(() {
                                                                _barcode =
                                                                    barcode;
                                                                barcodeController
                                                                        .text =
                                                                    barcode
                                                                        .toString();
                                                                if (verifyBarcode(
                                                                    barcode)) {
                                                                  getBarcode(
                                                                      _barcode);
                                                                }
                                                              });
                                                            },
                                                          ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //     padding: EdgeInsets.all(10),
                                        //     child: InputWithKeyboardControl(
                                        //       focusNode: InputWithKeyboardControlFocusNode(),
                                        //       onSubmitted: (value) {
                                        //         setState(() {
                                        //           // print(value);
                                        //           if (verifyBarcode(value)) {
                                        //             getBarcode(value);
                                        //           }
                                        //         });
                                        //       },
                                        //       autofocus: true,
                                        //       controller: barcodeController,
                                        //       width: MediaQuery.of(context).size.width / 5,
                                        //       startShowKeyboard: false,
                                        //       buttonColorEnabled: Colors.green,
                                        //       buttonColorDisabled: Colors.blue,
                                        //       underlineColor: Colors.transparent,
                                        //       showUnderline: false,
                                        //       showButton: true,
                                        //     )),//old function not working with latest updates
                                        GestureDetector(
                                            onPanUpdate: (details) {
                                              print(details.delta.dx);
                                              if (details.delta.dx > 8 ||
                                                  details.delta.dx < -8) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ConfigAPI()),
                                                );
                                              }
                                            },
                                            child: Container(
                                              child: Icon(Icons.settings,
                                                  color: Colors.green,
                                                  size: 28),
                                            )),
                                      ])))),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height / 15,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 10,
                          child: textScroll ? _buildComplexMarquee() : null,
                        ),
                      ),
                    ]))),
        onWillPop: () => showDialog<bool>(
              context: context,
              builder: (c) => CupertinoAlertDialog(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Text(
                    'Warning',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 25.0),
                  ),
                  content: Text('Do you really want to exit?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 19.0)),
                  actions: <Widget>[
                    CupertinoDialogAction(
                        child: Text('No'),
                        onPressed: () => Navigator.pop(c, false)),
                    CupertinoDialogAction(
                      child: Text('YES'),
                      onPressed: () => Navigator.pop(c, true),
                    ),
                  ]),
            ));
  }

  Widget _buildComplexMarquee() {
    return Center(
        child: Marquee(
            text: scrlMsg,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.white,
                fontSize: 40),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 100.0,
            pauseAfterRound: Duration(milliseconds: 10),
            startPadding: 10.0,
            accelerationDuration: Duration(seconds: 2),
            accelerationCurve: Curves.easeInOutCubic,
            decelerationDuration: Duration(milliseconds: 10),
            decelerationCurve: Curves.easeInCubic,
            textDirection: ui.TextDirection.ltr));
  }

  bool verifyBarcode(barcode) {
    if ((barcode == null) || ((barcode == ''))) {
      showMyiosGenDialog(context, "Alert!", "Barcode cannot be null");
      return false;
    } else {
      return true;
    }
  }

  void getBarcode(String scanBarcode) async {
    setState(() {
      barcodeController.clear();
      loader = true;
    });
    localList = await (searchPOSBarcode(scanBarcode, context));
///////////////////////////////////valid item///////////////////////////////////
    if (localList != null) {
///////////////////////////////////promo item///////////////////////////////////
      if (checkSpStat(localList) == true) {
        setState(() {
          loader = false;
          dispStat = true;
          lEngName.text = localList.lEngDesc;
          sEngName.text = localList.sEngDesc;
          aRName.text = localList.arDesc;
          retail1.text = localList.spPrice;
          retail2.text = localList.retail2;
          retail3.text = localList.retail3;
          nfpluVal = false;
          promotion.text = 'ITEM UNDER PROMOTION';
          promotion2.text =
              'From     ${localList.spStart}     To     ${localList.spEnd}';
          _barcode = '';
        });
      }
///////////////////////////////////promo item///////////////////////////////////

///////////////////////////////////normal item//////////////////////////////////
      else {
        setState(() {
          loader = false;
          sp_status = false;
          nfpluVal = false;
          lEngName.text = localList.lEngDesc;
          sEngName.text = localList.sEngDesc;
          aRName.text = localList.arDesc;
          retail1.text = localList.retail1;
          retail2.text = localList.retail2;
          retail3.text = localList.retail3;
          _barcode = '';
        });
      }
///////////////////////////////////normal item//////////////////////////////////
    }
///////////////////////////////////valid item///////////////////////////////////

///////////////////////////////////NFPLU item///////////////////////////////////
    else {
      setState(() {
        loader = false;
        dispStat = false;
        nfpluVal = true;
        lEngName.text = '';
        sEngName.text = '';
        aRName.text = '';
        retail1.text = '';
        retail2.text = '';
        retail3.text = '';
        promotion.text = '';
        promotion2.text = '';
        _barcode = '';
      });
    }
///////////////////////////////////NFPLU item///////////////////////////////////
    if (nfpluVal == false) {
      print(sp_status);
      if (sp_status == true) {
        print('-----------------------PROMOTION-----------------------');
        double data = double.parse(localList.spPrice);
        final strValue = data.abs().toString();
        final indexOfDot = strValue.indexOf('.');
        String integer = strValue.substring(0, indexOfDot);
        String decimal = strValue.substring(indexOfDot + 1);
        print(config.country);
        print(decimal.length);
        print(config.decimal);
        if (config.decimal == '3' && (decimal.length == 2)) {
          decimal += '0';
        }
        if (config.decimal == '3' && (decimal.length == 1)) {
          decimal += '00';
        }
        if (config.decimal == '2' && (decimal.length > 2)) {
          decimal = decimal.substring(0, decimal.length - 1);
        }
        if (config.decimal == '2' && (decimal.length == 1)) {
          decimal += '0';
        }
        setState(() {
          localList.spPrice = integer + '.' + decimal;
          if (int.parse(decimal) == 0) {
            if (config.country == 'BAHRAIN') {
              text = "$integer Dinar";
              currency = 'BD';
            }
            if (config.country == 'OMAN') {
              text = "$integer Riyal";
              currency = 'OMR';
            }
            if (config.country == 'QATAR') {
              text = "$integer Riyal";
              currency = 'QR';
            }
            if (config.country == 'SAUDI') {
              text = "$integer Riyal";
              currency = 'SR';
            }
            if (config.country == 'UAE') {
              text = "$integer Dirham";
              currency = 'AED';
            }
          } else {
            if (config.country == 'BAHRAIN') {
              text = "$integer Dinar $decimal Fills";
              currency = 'BD';
            }
            if (config.country == 'OMAN') {
              text = "$integer Riyal $decimal Baisa";
              currency = 'OMR';
            }
            if (config.country == 'QATAR') {
              text = "$integer Riyal $decimal Dirham";
              currency = 'QR';
            }
            if (config.country == 'SAUDI') {
              text = "$integer Riyal $decimal Halalas";
              currency = 'SR';
            }
            if (config.country == 'UAE') {
              text = "$integer Dirham $decimal Fills";
              currency = 'AED';
            }
          }
        });
        print(text);
        showPrice(context, localList, sp_status);
        licenseStatus ? _speak(text) : _speak('Please Activate the product');
        _barcode = '';
        // print('-----------------------PROMOTION-----------------------');
      } else {
        print('-----------------------NORMAL ITEM-----------------------');
        double data = double.parse(localList.retail1);
        final strValue = data.abs().toString();
        final indexOfDot = strValue.indexOf('.');
        String integer = strValue.substring(0, indexOfDot);
        String decimal = strValue.substring(indexOfDot + 1);
        if (config.decimal == '3' && (decimal.length == 2)) {
          decimal += '0';
        }
        if (config.decimal == '3' && (decimal.length == 1)) {
          decimal += '00';
        }
        if (config.decimal == '2' && (decimal.length > 2)) {
          decimal = decimal.substring(0, decimal.length - 1);
        }
        if (config.decimal == '2' && (decimal.length == 1)) {
          decimal += '0';
        }
        setState(() {
          localList.retail1 = integer + '.' + decimal;
          if (int.parse(decimal) == 0) {
            if (config.country == 'BAHRAIN') {
              text = "$integer Dinar";
              currency = 'BD';
            }
            if (config.country == 'OMAN') {
              text = "$integer Riyal";
              currency = 'OMR';
            }
            if (config.country == 'QATAR') {
              text = "$integer Riyal";
              currency = 'QR';
            }
            if (config.country == 'SAUDI') {
              text = "$integer Riyal";
              currency = 'SR';
            }
            if (config.country == 'UAE') {
              text = "$integer Dirham";
              currency = 'AED';
            }
          } else {
            if (config.country == 'BAHRAIN') {
              text = "$integer Dinar $decimal Fills";
              currency = 'BD';
            }
            if (config.country == 'OMAN') {
              text = "$integer Riyal $decimal Baisa";
              currency = 'OMR';
            }
            if (config.country == 'QATAR') {
              text = "$integer Riyal $decimal Dirham";
              currency = 'QR';
            }
            if (config.country == 'SAUDI') {
              text = "$integer Riyal $decimal Halalas";
              currency = 'SR';
            }
            if (config.country == 'UAE') {
              text = "$integer Dirham $decimal Fills";
              currency = 'AED';
            }
          }
        });
        showPrice(context, localList, sp_status);
        licenseStatus ? _speak(text) : _speak('Please Activate the product');
        _barcode = '';
        // print('-----------------------NORMAL ITEM-----------------------');
      }
    } else {
      text = 'Item Not Found';
      licenseStatus ? _speak(text) : _speak('Please Activate the product');
      _barcode = '';
      // print('Item Not Found');
    }
  }

  bool checkSpStat(localList) {
    sp_status = false;
    if (localList.spFlag == '1') {
      // print(localList.retail1);
      var now = DateTime.now();
      String systemDate = DateFormat('MM-dd-yyyy').format(now);
      var spStart = Jiffy(localList.spStart, "MM-dd-yyyy");
      var spEnd = Jiffy(localList.spEnd, "MM-dd-yyyy");
      var sysDt = Jiffy(systemDate, "MM-dd-yyyy");
      int lowLmt = (sysDt.diff(spStart));
      int higLmt = (sysDt.diff(spEnd));
      if (lowLmt >= 0) {
        if (higLmt <= 0) {
          setState(() {
            sp_status = true; //item under promotion
            promoMsg = true;
          });
          return sp_status;
        } else {
          setState(() {
            sp_status = false; //item not under promotion
            promoMsg = false;
          });
          return sp_status;
        }
      }
      //possible condition for special price item
      else {
        setState(() {
          sp_status = false; //item not under promotion
          promoMsg = false;
        });
        return sp_status;
      }
    } else {
      promoMsg = false;
      return sp_status;
    }
  }

  initializeTts() async {
    _flutterTts = FlutterTts();
    // List<dynamic> languages =  await _flutterTts.getLanguages;
    // List<dynamic> voices =  await _flutterTts.getVoices;
    // print('getting languages==============================================================');
    // voices.forEach((element) {
    //   print(element);
    // });
    setTtsLanguage();
    _flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
    _flutterTts.setErrorHandler((err) {
      setState(() {
        print("error occurred: " + err);
        isPlaying = false;
      });
    });
  }

  Future _speak(String text) async {
    await _flutterTts.setVolume(volume);
    await _flutterTts.setSpeechRate(double.parse(config.speed));
    await _flutterTts.setPitch(pitch);
    if (text != null && text.isNotEmpty) {
      var result = await _flutterTts.speak(text);
      if (result == 1)
        setState(() {
          isPlaying = true;
        });
    }
  }

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1)
      setState(() {
        isPlaying = false;
      });
  }

  void setTtsLanguage() async {
    await _flutterTts.setVoice({"name": "en_US-locale", "locale": "en-US"});
    await _flutterTts.setLanguage("en-US");
  }

  Future getImageList(context) async {
    dir = (await getApplicationDocumentsDirectory()).path;
    imageList = await (getImageListAPI2(context));
    if (imageList.length >= 1) {
      setState(() {
        imgLoad = true;
      });
    } else {
      setState(() {
        imgLoad = false;
        readRoll = false;
      });
    }
    // print(imageList.length);
    return await imageList;
  }

  void getApiData(context) async {
    api = await (getAPI(context));
  }

  void getApiLogoData(context) async {
    apiLogo = await (getAPILogo(context));
  }

  void getConfigData(context) async {
    config = await (getConfig(context));
  }

  void getActivationData(context) async {
    Activation localData = Activation();
    Activation serverData = Activation();
    // var tamp = await(deleteActivationLocalDB());
    localData = await (getActivationLocalDB(context));
    if(localData != null)
      {
        if(localData.actKey!='XXX')
            {
            String datax = (localData.encryptedKey).toString();
            String reqData = datax.substring(0,20);
            serverData = await getServerLicense(context, reqData);
            try {
              decryptedS = await cryptor.decrypt(localData.encryptedKey, localData.tempKey);
              if((decryptedS == serverData.actKey) && (decryptedS == localData.actKey)) {
                snackBardata(
                    context, 'License Validated', 2, Colors.red, Colors.white);
                setState(() {
                  chkLicense = true;
                });
              }
              else{
                setState(() {
                  chkLicense = false;
                });
                snackBardata(context, 'License Key Not Found in Server', 1, Colors.red, Colors.white);
              }
            } on MacMismatchException {
              setState(() {
                chkLicense = false;
              });
              print('exception------${e.toString()}');
              snackBardata(context, 'License Validation Error', 2, Colors.red, Colors.white);
            }
          }
        else {
          setState(() {
            chkLicense = false;
          });
          String datax = (localData.encryptedKey).toString();
          String reqData = datax.substring(0, 20);
          Activation valKey = await getServerLicense(context, reqData);
          if (valKey.actKey != null) {
            try {
              decryptedS =
              await cryptor.decrypt(localData.encryptedKey, localData.tempKey);
              if (decryptedS == valKey.actKey) {
                localData.actKey = valKey.actKey;
                snackBardata(
                    context, 'License Validated from Server', 2, Colors.red,
                    Colors.white);
                try {
                  var val = await (updateActivationLocalDB(localData));
                } catch (e) {
                  print(e.toString());
                  snackBardata(
                      context, e.toString(), 2, Colors.red, Colors.white);
                }
              }
              else{
                snackBardata(
                    context, 'Server License Error', 2, Colors.red,
                    Colors.white);
              }
            } on MacMismatchException {
              setState(() {
                chkLicense = false;
              });
              print('exception------${e.toString()}');
              snackBardata(context, 'License Validation Error', 2, Colors.red,
                  Colors.white);
            }
          }
          else{
            snackBardata(context, 'License Key Not Found in Server', 2, Colors.red, Colors.white);
          }
        }
      }
    else{
      setState(() {
        chkLicense = false;
      });
      snackBardata(context, 'Generating License', 2, Colors.red, Colors.white);
      generateLicense();
    }
  }

  Future<Activation> getServerLicense(context, String data) async {
    Activation val;
    try{
      val = await (getActivationFromDB(context, data));
    }
    catch(e){
      snackBardata(
          context, 'Exception getting data from server', 2, Colors.red, Colors.white);
      }
      if(val!=null)
        {
          return val;
        }
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

  File fileFromDocsDir(String filename) {
    String pathName = p.join(appDocsDir.path, filename);
    return File(pathName);
  }

  void showPrice(context, localList, sp_status) {
    // print(licenseStatus);
    licenseStatus ? showDialog(
        context: context,
        builder: (dialogContex) {
          Future.delayed(Duration(seconds: 4), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 50,
                          bottom: MediaQuery.of(context).size.height / 50),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: MediaQuery.of(context).size.height / 4,
                            child: logoFn
                                ? Image.file(File(logoPath))
                                : Image.asset(
                                    'assets/logo2.jpg',
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          Text(
                            '${localList.lEngDesc}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 50.0),
                          ),
                          Text(
                            '${localList.arDesc}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 50.0),
                          ),
                          Text(
                            '${localList.pack}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 50.0),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BarcodeWidget(
                            barcode: Barcode.code128(),
                            // Barcode type and settings
                            data: localList.barcode,
                            // Content
                            width: MediaQuery.of(context).size.width / 5,
                            height: MediaQuery.of(context).size.height / 8,
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            sp_status
                                ? 'Retail : ${localList.spPrice}  $currency'
                                : 'Retail : ${localList.retail1}  $currency',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 60.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            sp_status ? 'Special Price Item' : '',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }) : snackBardata(context, 'Please Activate the Product', 2, Colors.red, Colors.white);
  }

  void downloadImage() async {
    if (downldStatus != true && imageList != null) {
      if (api != null && api != '') {
        final dir2 = Directory(dir);
        final pathImg = await dir;
        imageList.forEach((length) {
          // print(length);
          File file = File('$pathImg/${length}');
          file.delete();
        });
        print('deleting existing data');
        imageList.forEach((length) {
          getImage(context, api, length.toString());
        });
        setState(() {
          downldStatus = true;
        });
      }
    }
    if (downldStatus == true && imgConvert == false) {
      // String dir = (await getApplicationDocumentsDirectory()).path;
      imageList.forEach((length) {
        imageFile = new File('$dir/$length');
        imgList.add(imageFile);
        // getImage(context, api, length.toString());
      });
      setState(() {
        readRoll = true;
        imgConvert = true;
      });
    }
  }

  void downloadLogo() async {
    if (logoDownload != true) {
      if (api != null && api != '') {
        final dir2 = Directory(dir);
        final pathLogo = await dir;
        File file = File('$pathLogo/Logo.jpg');
        // print(file);
        if (file.existsSync()) {
          print('file exists, deleting');
          await file.delete(recursive: true);
        } else {
          // print(apiLogo);
          getLogo(context, apiLogo);
          logo = File('$dir/Logo.jpg');
          setState(() {
            logoDownload = true;
            logoPath = ('$pathLogo/Logo.jpg');
          });
        }
      }
    } else {
      logo = File('$dir/Logo.jpg');
    }
  }

  void downloadTextMsg() async {
    getConfigData(context);
    // print(config.toString());
    // print(config.msgScroll);
    if (config.msgScroll == 'true') {
      if (dwnldMsgStatus != true) {
        scrlMsg = await getScrollMsg(context);
        print(scrlMsg.length);
        if (scrlMsg.length != 0) {
          print('data found');
          setState(() {
            dwnldMsgStatus = true;
          });
        } else {
          String msg = 'Please check the data file';
          print(msg);
          snackBardata(context, msg, 5, snColor, snDataColor);
        }
      }
    }
  }

  void changeImage() async {
    if (config.imgScroll == 'true') {
      downloadImage();
      if (downldStatus == true) {
        if (i < imageList.length) {
          tempImg = File('$dir/${imageList[i]}');
          if (await tempImg.exists()) {
            // print('updated $i');
            setState(() {
              imgPath = ('$dir/${imageList[i]}');
              imageFile = tempImg;
            });
          }
        }
        i += 1;
        if (i == imageList.length) {
          i = 0;
        }
      }
    } else {
      setState(() {
        readRoll = false;
      });
    }
    if (config.msgScroll == 'true') {
      downloadTextMsg();
      setState(() {
        textScroll = true;
      });
    } else {
      textScroll = false;
    }
    if (config.logo == 'true') {
      downloadLogo();
      setState(() {
        logoFn = true;
      });
    } else {
      setState(() {
        logoFn = false;
      });
    }
    validateLicense();
  }

  void validateLicense(){
    print(chkLicense.toString());
    if(chkLicense!=true){
      getActivationData(context);
      setState(() {
        licenseStatus = false;
      });
    }
    else{
      setState(() {
        licenseStatus = true;
      });
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

  void snackBardata(context, String actionMsg, var duration, Color snColour, Color snDataColor) {
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
