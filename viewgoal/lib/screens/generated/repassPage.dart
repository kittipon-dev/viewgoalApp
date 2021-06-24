import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/menu_bar.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/inboxPage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'package:viewgoal/screens/userPage.dart';
import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

var cJson = {};
var list = [];
String urlimgprofile = hostname + '/images-profile/null.png';

/// This is the stateful widget that the main application instantiates.
class RePassPage extends StatefulWidget {
  RePassPage({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<RePassPage> {
  final emailText = TextEditingController();

  Future<void> initializePlayer() async {}

  Future<void> ResetPass() async {
    final http.Response response = await http.post(
      Uri.parse(hostname + '/resetpass'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailText.text,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Color.fromRGBO(241, 119, 26, 1),
    minimumSize: Size(120, 40),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.amber[800],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text("Reset Password",style: TextStyle(fontSize: 30),),
              ),
              Container(
                padding: EdgeInsets.only(top: 40,right: 20, left: 20),
                child: TextField(
                  controller: emailText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Email',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => ResetPass(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
