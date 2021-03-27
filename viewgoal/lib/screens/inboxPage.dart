import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:viewgoal/config.dart';
import 'package:viewgoal/menu_bar.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'dart:async';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';

import 'giftPage.dart';
import 'sendmessagePage.dart';

var cJsonM = [];

var cJsonN = [
  {
    "img":
        'https://img2.thaipng.com/20180501/stw/kisspng-wireless-security-camera-closed-circuit-television-5ae92ebc8b11e7.1893454715252312925696.jpg',
    "topic": "มีการแสดงความคิดเห็นใหม่",
    "txt": "aaaaaaaaaaaaaaa"
  },
  {
    "img":
        'https://img2.thaipng.com/20180501/stw/kisspng-wireless-security-camera-closed-circuit-television-5ae92ebc8b11e7.1893454715252312925696.jpg',
    "topic": "มีถูกใจกล้องของคุณ",
    "txt": ""
  },
  {
    "img":
        'https://flyerbonus.bangkokair.com/images/icons/icon-how-to-add-points.png',
    "topic": "คุณได้รับรางวัล",
    "txt": "ได้รับ point 50"
  },
  {
    "img":
        'https://e7.pngegg.com/pngimages/305/201/png-clipart-computer-icons-expiration-date-angle-text-thumbnail.png',
    "topic": "ยอดวันใกล้ใช้งานของคุณใกล้จะหมด",
    "txt": "การใช้งานสินสุดวันที่ 12/12/2022"
  }
];

class InboxPage extends StatefulWidget {
  InboxPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InboxPage> {
  int user_id;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id > 0) {
      getMes();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Future<void> getMes() async {
    var request = await http.Request('GET',
        Uri.parse(hostname + '/get_mesAll?user_id=' + user_id.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cJsonM = jsonDecode(receivedJson);
    }
  }

  Future<String> getName(id) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/getname?user_id=' + id.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      return receivedJson;
    }
    return "asd";
  }

  @override
  initState() {
    super.initState();
    ch();
  }

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
        body: SafeArea(
          child: TabBarView(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notification",
                        style:
                            TextStyle(color: Color(0xFFF1771A), fontSize: 20),
                      ),
                      Icon(Icons.search_rounded)
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cJsonN.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SendMessagePage()),
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
                                        backgroundImage:
                                            NetworkImage(cJsonN[index]["img"]),
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
                                          child: Text(cJsonN[index]["topic"]),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Text(
                                            cJsonN[index]["txt"],
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        )
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Massages",
                        style:
                            TextStyle(color: Color(0xFFF1771A), fontSize: 20),
                      ),
                      Icon(Icons.search_rounded)
                    ],
                  ),
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
                                        cJsonM[index]["r_user_id"].toString(),
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
                                            '/images-profile/null.png'),
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
                                          child: Text(cJsonM[index]["r_user_id"].toString()),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Text(
                                            cJsonM[index]["mes"][
                                                cJsonM[index]["mes"].length -
                                                    1]["mes"],
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        )
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
