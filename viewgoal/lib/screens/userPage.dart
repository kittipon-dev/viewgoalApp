import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'package:viewgoal/screens/playPage.dart';
import 'package:viewgoal/screens/settingsPage.dart';

import '../config.dart';
import '../menu_bar.dart';
import 'addCamera.dart';
import 'homePage.dart';
import 'mapPage.dart';
import 'inboxPage.dart';

List<dynamic> cJson = [];
var req = {};
var myME = {};

/// This is the stateful widget that the main application instantiates.
class UserPage extends StatefulWidget {
  UserPage({Key key,this.user_id}) : super(key: key);
  final String user_id;
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<UserPage> {
  int _selectedIndex = 3;
  final page = [HomePage(), MapPage(), InboxPage(), MePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => page[_selectedIndex]),
              (Route<dynamic> route) => false);
    });
  }

  int slogin;
  int username;
  String urlimgprofile = hostname + '/images-profile/null.png';

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
      getUser(widget.user_id);
    }
  }

  Future<void> getUser(id) async {
    var request =
        await http.Request('GET', Uri.parse(hostname + '/user?user_id=' + id));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();

      req = jsonDecode(receivedJson);
      myME = req["user"];
      cJson = req["camera"];
      // print(json["user_id"]);
/*
      list = await json.decode(receivedJson);
      cJson = await list[1];
       */
      urlimgprofile = hostname + '/images-profile/${id}.png';
      setState(() {});
    }
  }

  Future<void> startcam(idcam) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/startcam?_id=' + idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        getUser(widget.user_id);
      });
    }
  }

  Future<void> stopcam(idcam) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/stopcam?_id=' + idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        getUser(widget.user_id);
      });
    }
  }

  Future<void> removedcam(idcam) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/removedcam?_id=' + idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        getUser(username.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
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
        actions: [
          FlatButton(
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  Icons.favorite_outline,
                  color: Colors.black54,
                ),
                Text(
                  "Like",
                  style: TextStyle(color: Colors.black54),
                )
              ],
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Colors.black54,
                ),
                Text(
                  "Follow",
                  style: TextStyle(color: Colors.black54),
                )
              ],
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(urlimgprofile),
                      radius: 50,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      myME["name"] != null ? myME["name"].toString() : " ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          child: Column(
                            children: [
                              Text(myME["following"] == null
                                  ? myME["following"].toString()
                                  : '0'),
                              Text("กําลังติดตาม")
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Column(
                            children: [
                              Text(myME["followers"] == null
                                  ? myME["followers"].toString()
                                  : '0'),
                              Text("ผู้ติดตาม")
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Column(
                            children: [
                              Text(myME["like"] == null
                                  ? myME["like"].toString()
                                  : '0'),
                              Text("ถูกใจ")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: 60,
              margin: EdgeInsets.only(top: 5),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: Text(
                myME["note"] ?? "ข้อความ...",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: Container(
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
                      child: Container(
                        child: Card(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                width: 100,
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: Text('${cJson[index]['title']}'),
                                    ),
                                    Container(
                                      child: Text(
                                          '${cJson[index]['location']['name']}'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
