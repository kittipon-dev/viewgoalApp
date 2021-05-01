import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/screens/advertisingPage.dart';
import 'package:viewgoal/screens/inboxPage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'package:viewgoal/screens/playPage.dart';
import 'dart:async';
import 'dart:convert';

import '../menu_bar.dart';
import 'homePage.dart';

var cJson = [];
var cJsonF = [];
var cUser = {};

class GiftPage extends StatefulWidget {
  GiftPage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GiftPage> {
  int user_id;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id > 0) {
      listplaying(user_id.toString());
      get_point(user_id.toString());
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> get_point(id) async {
    var request =
        http.Request('GET', Uri.parse(hostname + '/get_point?user_id=' + id));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cUser = jsonDecode(receivedJson);
      cJsonF = cUser["activity"];
      print(cJsonF);
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  Future<void> listplaying(id) async {
    var request = http.Request('GET', Uri.parse(hostname + '/getall_gift'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      var req = {};
      cJson = jsonDecode(receivedJson);
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  @override
  initState() {
    super.initState();
    ch();
    //print(chLogin);
  }

  // int _currentIndex = 3;
  // List<Widget> _widgetOptions = <Widget>[
  //   HomePage(),
  //   MapPage(),
  //   InboxPage(),
  //   GiftPage(),
  //   MePage(),
  // ];
  // void _onItemTap(int index) {
  //   setState(() {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => _widgetOptions[_currentIndex]),
  //     );
  //     _currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Gift",
                  style: TextStyle(color: Color(0xFFF1771A)),
                ),
              ),
              Tab(
                child: Text(
                  "My Gift",
                  style: TextStyle(color: Color(0xFFF1771A)),
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(onPressed: () {}, child: Text(cUser["point"].toString()))
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //     type: BottomNavigationBarType.fixed,
        //     selectedItemColor: Colors.amber[800],
        //     iconSize: 30,
        //     currentIndex: _currentIndex,
        //     onTap: _onItemTap,
        //     items: bnb),
        body: TabBarView(
          children: [
            Container(
              child: ListView.builder(
                itemCount: cJson.length,
                itemBuilder: (context, index) {
                  return FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdvertisingPage(cA: cJson[index]),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        child: Container(
                          width: double.infinity,
                          color: Color(0xFFF1771A),
                          child: Image.network(
                              hostname + cJson[index]["urlimg"].toString()),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: ListView.builder(
                itemCount: cJsonF.length,
                itemBuilder: (context, index) {
                  return FlatButton(
                    onPressed: () {},
                    child: Card(
                      margin: EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        child: Container(
                          width: double.infinity,
                          color: Color(0xFFF1771A),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Topic: " + cJsonF[index]["topic"].toString(),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "ref: " + cJsonF[index]["ref"].toString(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
