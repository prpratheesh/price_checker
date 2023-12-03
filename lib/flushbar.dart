import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void show_Custom_Flushbar(BuildContext context, String title, String msg) {
  Flushbar(
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.all(10),
    borderRadius: 8,
    backgroundGradient: LinearGradient(
      colors: [Colors.green.shade800, Colors.greenAccent.shade700],
      stops: [0.6, 1],
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],
    // All of the previous Flushbars could be dismissed by swiping down
    // now we want to swipe to the sides
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    // The default curve is Curves.easeOut
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: title,
    message: msg,
  )..show(context);
}

Future<String> showMyDialog(BuildContext context, String title, String msg) async {
  String nfplu = 'N';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          elevation: 10,
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            height: 1,
            color: Colors.red,
            fontWeight: FontWeight.w900,
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
              child: Center(
            child: ListBody(
              children: <Widget>[
//                    Text(title),
                Text(msg),
              ],
            ),
          )),
          actions: <Widget>[
            TextButton(
                child: Text('Continue'),
                onPressed: () {
                  nfplu='Y';
                  Navigator.of(context).pop(nfplu);
                }),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                nfplu='N';
                Navigator.of(context).pop(nfplu);
              },
            ),
          ]);
    },
  );
}

Future<void> showMyAlertDialog(BuildContext context, String title, String msg) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
              child: Center(
            child: ListBody(
              children: <Widget>[
//                    Text(title),
                Text(msg),
              ],
            ),
          )),
          actions: <Widget>[
            FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ]);
    },
  );
}

Future<String> showMyiosDialog(BuildContext context, String title, String msg) async {
  String nfplu = 'N';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Text(msg),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  nfplu='N';
                  Navigator.of(context).pop(nfplu);
                }
            ),
            CupertinoDialogAction(
                child: Text('YES'),
                onPressed: ()
                {
                  nfplu='Y';
                  Navigator.of(context).pop(nfplu);
                }
            ),
          ]
      );
    },
  );
}

void showMyiosGenDialog(BuildContext context, String title, String msg) async {
  return showDialog(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop(true);
      });
      return CupertinoAlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Text(msg),
      );
    },
  );
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

void snackBardataWithAction(context, String actionMsg, var duration, Color snColour, Color snDataColor) {
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