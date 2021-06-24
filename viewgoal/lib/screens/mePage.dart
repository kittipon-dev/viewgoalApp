import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:viewgoal/dark_theme_provider.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/playPage.dart';
import 'package:viewgoal/screens/settingsPage.dart';
import 'package:viewgoal/screens/userPage.dart';
import 'package:viewgoal/settings/Account/manage_profile.dart';
import 'package:flutter/foundation.dart';

import '../config.dart';
import '../menu_bar.dart';
import 'addCamera.dart';
import 'giftPage.dart';
import 'homePage.dart';
import 'mapPage.dart';
import 'inboxPage.dart';

List<dynamic> cJson = [];
var req = {};
var myME = {};

var cSave = [];
var namecSave = [];
var cFollowing = [];
var namecFollowing = [];

class MePage extends StatefulWidget {
  MePage({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MePage> {
  String dropdownValue = 'One';

  int user_id;
  var img = NetworkImage(hostname + '/images-profile/null.png');

  int likeme = 0;
  int followers = 0;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id > 0) {
      getMe();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Future<void> getMe() async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/me?user_id=' + user_id.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();

      req = jsonDecode(receivedJson);

      myME = req["user"];
      cJson = req["camera"];
      cSave = req["save"];

      cFollowing = req["following"];
      print(cJson);

/*
      list = await json.decode(receivedJson);
      cJson = await list[1];
       */
      img =
          NetworkImage(hostname + '/images-profile/${user_id.toString()}.png');
      setState(() {});
    } else if (response.statusCode == 401) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('user_id', 0);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> startcam(idcam) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/startcam?_id=' + idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        getMe();
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('snack'),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  Future<void> stopcam(idcam) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/stopcam?_id=' + idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        getMe();
      });
    }
  }

  Future<void> removedcam(idcam) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/removedcam?_id=' + idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        getMe();
      });
    }
  }

  Future<String> getNameCame() async {
    final http.Response response = await http.post(
      Uri.parse(hostname + '/getnamecam/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cSave),
    );

    if (response.statusCode == 200) {
      String receivedJson = await response.body.toString();
      namecSave = jsonDecode(receivedJson);
      print(namecSave);
    }
  }

  Future<String> getName() async {
    final http.Response response = await http.post(
      Uri.parse(hostname + '/getname/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cFollowing),
    );

    if (response.statusCode == 200) {
      String receivedJson = await response.body.toString();
      namecFollowing = jsonDecode(receivedJson);
      print(namecFollowing);
    }
  }

  @override
  void initState() {
    super.initState();
    ch();
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
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                ),
                Text(
                  "Setting",
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
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagerProfile(
                              user_id: user_id,
                              myme: myME,
                            ),
                          ),
                        ).then((_) {
                          getMe();
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: img,
                        radius: 50,
                      ),
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
                              Text(myME["followers"].toString()),
                              Text("ผู้ติดตาม")
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Column(
                            children: [
                              Text(myME["like"].toString()),
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
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: 60,
              margin: EdgeInsets.only(top: 5),
              /*decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),*/
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
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  body: Column(
                    children: [
                      Container(
                        color: Color(0xffF1771A),
                        child: TabBar(
                          tabs: [
                            Tab(
                              child: Text(
                                "Camera",
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Save",
                              ),
                            ),
/*                          Tab(
                            child: Text(
                              "Record",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),*/
                            Tab(
                              child: Text(
                                "Follow",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child:
                                        /*OutlinedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddCameraPage(
                                                id: user_id.toString()),
                                          ),
                                        ).then((_) {
                                          getMe();
                                        });
                                      },
                                      child: Text("Add Camera"),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            width: 10,
                                            style: BorderStyle.solid),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                        ),
                                      ),
                                    ),*/
                                        ElevatedButton(
                                      style: raisedButtonStyle,
                                      child: Text(
                                        'Add Camera',
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddCameraPage(
                                                id: user_id.toString()),
                                          ),
                                        ).then((_) {
                                          getMe();
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: ListView.builder(
                                        itemCount: cJson.length,
                                        itemBuilder: (context, index) {
                                          return FlatButton(
                                            onPressed: () {
                                              if (cJson[index]['status'] ==
                                                  true) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PlayPage(
                                                              idcam:
                                                                  cJson[index]
                                                                      ["_id"])),
                                                );
                                              }
                                            },
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
                                                      child: Image.network(
                                                          hostname +
                                                              '/imageVideo/' +
                                                              cJson[index]
                                                                  ["_id"] +
                                                              '.jpg'),
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
                                                                '${cJson[index]['title']}'),
                                                          ),
                                                          /*
                                                          Container(
                                                            child: Text(cJson[0]['loaction']['name']??''),
                                                          ),
                                                           */
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    1),
                                                            child: Text(
                                                              cJson[index][
                                                                          'status'] ==
                                                                      true
                                                                  ? 'playing...'
                                                                  : 'stop',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: PopupMenuButton(
                                                        onSelected: (result) {
                                                          if (result == 1) {
                                                            startcam(
                                                                cJson[index]
                                                                    ["_id"]);
                                                          } else if (result ==
                                                              2) {
                                                            stopcam(cJson[index]
                                                                ["_id"]);
                                                          } else if (result ==
                                                              3) {
                                                            removedcam(
                                                                cJson[index]
                                                                    ["_id"]);
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (context) => [
                                                          PopupMenuItem(
                                                            value: cJson[index][
                                                                        'status'] ==
                                                                    true
                                                                ? 2
                                                                : 1,
                                                            child: Text(cJson[
                                                                            index]
                                                                        [
                                                                        'status'] ==
                                                                    true
                                                                ? 'Stop'
                                                                : 'Start'),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 3,
                                                            child:
                                                                Text("remove"),
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
                                itemCount: cSave.length,
                                itemBuilder: (context, index) {
                                  return FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PlayPage(
                                                idcam: cSave[index]["idcam"]
                                                    .toString())),
                                      );
                                    },
                                    child: Container(
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 100,
                                              child: Image.network(hostname +
                                                  '/imageVideo/' +
                                                  cSave[index]["idcam"] +
                                                  '.jpg'),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                        cSave[index]["title"]),
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
                            /*Container(
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
                            ),*/
                            Container(
                              child: ListView.builder(
                                itemCount: cFollowing.length,
                                itemBuilder: (context, index) {
                                  return FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserPage(
                                              userid: cFollowing[index]
                                                      ["f_user_id"]
                                                  .toString()),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    hostname +
                                                        '/images-profile/${cFollowing[index]["f_user_id"]}.png'),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                        cFollowing[index]
                                                            ["name"]),
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
