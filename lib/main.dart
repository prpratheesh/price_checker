import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;

import 'scan_data.dart';

void main() =>
    {
      // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]),
      WidgetsFlutterBinding.ensureInitialized(),
      runApp(App())
    };

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // DBProvider.db.initDB();
  }

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
        title: "ANDROID PRICE CHECKER",
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
              bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
            )),
        debugShowCheckedModeBanner: false,
        home: ScanData());
  }
}
