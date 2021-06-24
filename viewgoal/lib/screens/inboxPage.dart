import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:viewgoal/config.dart';
import 'package:viewgoal/menu_bar.dart';
import 'package:viewgoal/screens/commentPage.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'dart:async';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'package:viewgoal/screens/playPage.dart';
import 'package:viewgoal/screens/userPage.dart';

import 'giftPage.dart';
import 'sendmessagePage.dart';

var cJsonM = [];
var listNameM = [];
var nameM = [];

var cJsonN = [];
var listNameN = [];
var nameN = [];

class InboxPage extends StatefulWidget {
  InboxPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InboxPage> {
  int user_id;
  String name;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id > 0) {
      allget();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Future<void> allget() async {
    await getNotifi();
    await getMes();
    await getNameN();
    await getNameM();
    print(nameM);
    print(nameN);
    setState(() {});
  }

  Future<void> getMes() async {
    var request = await http.Request('GET',
        Uri.parse(hostname + '/get_mesAll?user_id=' + user_id.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cJsonM = jsonDecode(receivedJson);
      listNameM.clear();
      for (int i = 0; i < cJsonM.length; i++) {
        listNameM.add(cJsonM[i]["user_id_2"]);
      }
    }
  }

  Future<void> getNotifi() async {
    var request = await http.Request('GET',
        Uri.parse(hostname + '/get_notifi?user_id=' + user_id.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cJsonN = jsonDecode(receivedJson);
      listNameN.clear();
      for (int i = 0; i < cJsonN.length; i++) {
        listNameN.add(cJsonN[i]["t_user_id"]);
      }
    }
  }

  Future<String> getNameN() async {
    final http.Response response = await http.post(
      Uri.parse(hostname + '/getname/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(listNameN),
    );

    if (response.statusCode == 200) {
      String receivedJson = await response.body.toString();
      nameN = jsonDecode(receivedJson);
    }
  }

  Future<String> getNameM() async {
    final http.Response response = await http.post(
      Uri.parse(hostname + '/getname/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(listNameM),
    );

    if (response.statusCode == 200) {
      String receivedJson = await response.body.toString();
      nameM = jsonDecode(receivedJson);
    }
  }

  @override
  initState() {
    super.initState();
    ch();
  }

  // int _currentIndex = 2;
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFFF1771A),
                  size: 30,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.mail_outline,
                  color: Color(0xFFF1771A),
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //     type: BottomNavigationBarType.fixed,
        //     selectedItemColor: Colors.amber[800],
        //     iconSize: 30,
        //     currentIndex: _currentIndex,
        //     onTap: _onItemTap,
        //     items: bnb),
        body: SafeArea(
          child: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cJsonN.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: FlatButton(
                            onPressed: () {
                              if (cJsonN[index]["type"] == "like") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayPage(
                                      idcam: cJsonN[index]["refid"],
                                    ),
                                  ),
                                );
                              } else if (cJsonN[index]["type"] == "comment") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentPage(
                                      idcam: cJsonN[index]["refid"],
                                    ),
                                  ),
                                );
                              } else if (cJsonN[index]["type"] == "follow") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPage(
                                      userid: cJsonN[index]["t_user_id"],
                                    ),
                                  ),
                                );
                              } else {}
                            },
                            child: Card(
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10, top: 5),
                                      child: Icon(cJsonN[index]["type"] ==
                                              "like"
                                          ? Icons.favorite_outline
                                          : cJsonN[index]["type"] == "comment"
                                              ? Icons.comment_outlined
                                              : cJsonN[index]["type"] ==
                                                      "follow"
                                                  ? Icons.add
                                                  : Icons.android_outlined),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 10, top: 5),
                                          child: Text(cJsonN[index]["type"]),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Text(
                                            nameN[index]
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cJsonM.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SendMessagePage(
                                    ruserid:
                                        cJsonM[index]["user_id_2"].toString(),
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: Container(
                                height: 70,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10, top: 5),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(hostname +
                                            '/images-profile/${cJsonM[index]["user_id_2"]}.png'),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 10, top: 5),
                                          child: Text(nameM[index]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
