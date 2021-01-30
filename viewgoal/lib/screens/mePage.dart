import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:viewgoal/screens/loginPage.dart';

import '../config.dart';
import '../menu_bar.dart';
import 'addCamera.dart';
import 'homePage.dart';
import 'mapPage.dart';
import 'inboxPage.dart';

List<dynamic> cJson = [];
List<dynamic> list = [{
  'data': {'fname': ''},
  's': {'f': '','s': '','l': ''},
}];


/// This is the stateful widget that the main application instantiates.
class MePage extends StatefulWidget {
  MePage({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MePage> {
  int _selectedIndex = 3;
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

  String dropdownValue = 'One';

  int slogin;
  String username;

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
      username = prefs.get('user_id');
      //getMe(username);
    }
  }

  Future<void> getMe(id) async {
    var request =
    await http.Request('GET', Uri.parse(hostname + '/getid?id=' + id));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      list = await json.decode(receivedJson);
      cJson = await list[1];
      setState(() {});
    }
  }

  Future<void> startcam(idcam) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/startcam?idcam=' + idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {setState(() {});}
  }

  Future<void> stopcam(idcam) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/stopcam?idcam=' + idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future<void> removedcam(idcam) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/removedcam?idcam=' + idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {setState(() {});}
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
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              //logoutClear();
              ch();
            },
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
                Text(
                  "Setting",
                  style: TextStyle(color: Colors.black54),
                )
              ],
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: 100,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      '${list[0]['data']['fname']}',
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
                              Text('${list[0]['s']['f']}'),
                              Text("กําลังติดตาม")
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Column(
                            children: [
                              Text('${list[0]['s']['s']}'),
                              Text("ผู้ติดตาม")
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Column(
                            children: [
                              Text('${list[0]['s']['l']}'),
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
              margin: EdgeInsets.only(top: 20),
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  body: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              "Camera",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Record",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: OutlineButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                addCameraPage(id: username),
                                          ),
                                        );
                                      },
                                      child: Text("Add Camera"),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.blue,
                                            width: 10,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: ListView.builder(
                                        itemCount: cJson.length,
                                        itemBuilder: (context, index) {
                                          return FlatButton(
                                            child: Container(
                                              child: Card(
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 150,
                                                      height: 100,
                                                      color: Color(0xFFF1771A),
                                                      child: Icon(
                                                        Icons
                                                            .play_circle_outline_outlined,
                                                        color: Colors.white,
                                                        size: 50,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                                '${cJson[0]['title']}'),
                                                          ),
                                                          Container(
                                                            child: Text(
                                                                '${cJson[0]['loaction']['name']}'),
                                                          ),
                                                          Container(
                                                            padding:
                                                            EdgeInsets.all(
                                                                1),
                                                            child: Text(
                                                              cJson[0]['s'] == 1
                                                                  ? 'playing...'
                                                                  : 'stop',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black45),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: PopupMenuButton(
                                                        onSelected: (result) {
                                                          print(result);
                                                          if(result==1){
                                                            startcam(cJson[0]['wowza']['live_stream']['id']);
                                                          }else if(result==2){
                                                            stopcam(cJson[0]['wowza']['live_stream']['id']);
                                                          }else if(result==3){
                                                            removedcam(cJson[0]['wowza']['live_stream']['id']);
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (context) =>
                                                        [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child: Text("Start"),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child: Text("Stop"),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 3,
                                                            child: Text("Removed"),
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
                                                Icons
                                                    .play_circle_outline_outlined,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(''),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(''),
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
