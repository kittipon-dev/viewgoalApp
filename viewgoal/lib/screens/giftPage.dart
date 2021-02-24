import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
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

class GiftPage extends StatefulWidget {
  GiftPage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GiftPage> {
  int slogin;
  int user_id;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    slogin = await prefs.get('login');
    if (slogin != 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else if (slogin == 1) {
      user_id = prefs.get('user_id');
      listplaying(user_id.toString());
    }
  }

  Future<void> listplaying(id) async {
    var request =
        http.Request('GET', Uri.parse(hostname + '/listplaying?user_id=' + id));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      var req = {};
      req = jsonDecode(receivedJson);
      cJson = req["listplay"];
      cJsonF = req["favorite"];
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

  int _selectedIndex = 3;
  final page = [HomePage(), MapPage(), InboxPage(), GiftPage(), MePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => page[_selectedIndex]),
          (Route<dynamic> route) => false);
    });
  }

  String asd;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: menuBar,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
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
          actions: [FlatButton(onPressed: () {}, child: Text("100 P"))],
        ),
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
                                PlayPage(idcam: cJson[index]["_id"])),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          color: Color(0xFFF1771A),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlayPage(idcam: cJsonF[index]["_id"]),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          color: Color(0xFFF1771A),
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
