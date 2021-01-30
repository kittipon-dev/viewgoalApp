import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/screens/inboxPage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'dart:async';
import 'dart:convert';

import '../menu_bar.dart';

var cJson = [];

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int slogin;
  int user_id;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    slogin = await prefs.get('login');
    if (slogin != 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else if (slogin == 1) {
      user_id = prefs.get('user_id');
    }
  }

  Future<void> list() async {
    var request = http.Request('GET', Uri.parse(hostname + '/list'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      List<dynamic> list = json.decode(receivedJson);
      cJson = list;
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

  int _selectedIndex = 0;
  final page = [HomePage(), MapPage(), InboxPage(), MePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page[_selectedIndex]),
      );
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
                  "Hot",
                  style: TextStyle(color: Color(0xFFF1771A)),
                ),
              ),
              Tab(
                child: Text(
                  "Favorite",
                  style: TextStyle(color: Color(0xFFF1771A)),
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(onPressed: () {}, child: Icon(Icons.search_rounded))
          ],
        ),
        body: TabBarView(
          children: [
            Container(
              child: ListView.builder(
                itemCount: cJson.length,
                itemBuilder: (context, index) {
                  return FlatButton(
                    onPressed: () {},
                    child: Card(
                      margin: EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              color: Color(0xFFF1771A),
                              child: Icon(
                                Icons.play_circle_outline_outlined,
                                color: Colors.white,
                                size: 150,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_circle_outlined,
                                    size: 50,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 3),
                                          child:
                                              Text('${cJson[index]['title']}'),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 3),
                                          child: Text(
                                              '${cJson[index]['loaction']['name']}'),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                  'view ${cJson[index]['view']}'),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 50),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.favorite),
                                                    Text(
                                                        '${cJson[index]['love']}')
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: ListView.builder(
                itemCount: 0,
                itemBuilder: (context, index) {
                  return FlatButton(
                    onPressed: () {},
                    child: Container(
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                              width: 150,
                              height: 100,
                              color: Color(0xFFF1771A),
                              child: Icon(
                                Icons.play_circle_outline_outlined,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text("บ้านข้าเองง"),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text("ลำปาง"),
                                  ),
                                ],
                              ),
                            )
                          ],
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