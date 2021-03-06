import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

import 'giftPage.dart';

/// This is the stateful widget that the main application instantiates.
class AdvertisingPage extends StatefulWidget {
  AdvertisingPage({Key key, this.aID, this.cA}) : super(key: key);
  String aID;
  var cA = {};

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

var cA = {};

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<AdvertisingPage> {
  int user_id;

  bool f = false;
  bool l = false;

  final txtpost = TextEditingController();

  var img = NetworkImage(hostname + '/images-profile/null.png');

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id != null && user_id > 0) {
      print(cA);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> getComment(id) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/get_comment?idcam=' + id));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cA = jsonDecode(receivedJson);
      setState(() {});
    }
  }

  Future<void> use_point() async {
    var request = await http.Request(
      'GET',
      Uri.parse(hostname +
          '/use_point?user_id=' +
          user_id.toString() +
          '&ref=' +
          cA["ref"]),
    );
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    ch();
    cA = widget.cA;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(cA["topic"]),
        leading: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFF1771A),
        elevation: 0.3,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text("ref. " + cA["ref"].toString()),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height * 0.70,
                child: Text(cA["txt"]),
              ),
              Container(
                child: RaisedButton(
                  onPressed: () {
                    use_point();
                  },
                  child: Text("ใช้ " + cA["use_point"].toString()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
