import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'package:viewgoal/screens/messagePage.dart';
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
  UserPage({Key key, this.userid}) : super(key: key);
  final String userid;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<UserPage> {
  int slogin;
  int user_id;
  String urlimgprofile = hostname + '/images-profile/null.png';

  int likeme = 0;
  int followers = 0;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id > 0) {
      getUser(widget.userid);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
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

      for (var i = 0; i < myME["likeme"].length; i++) {
        likeme++;
      }
      for (var i = 0; i < myME["followers"].length; i++) {
        followers++;
      }
      print(myME);
/*
      list = await json.decode(receivedJson);
      cJson = await list[1];
       */
      urlimgprofile = hostname + '/images-profile/${id}.png';
      setState(() {});
    }
  }

  Future<void> add_follow() async {
    var request = http.Request(
      'GET',
      Uri.parse(hostname +
          '/add_follow?user_id=' +
          user_id.toString() +
          '&userID=' +
          widget.userid),
    );
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  Future<void> add_like() async {
    var request = http.Request(
      'GET',
      Uri.parse(hostname +
          '/add_like?user_id=' +
          user_id.toString() +
          '&userID=' +
          widget.userid),
    );
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      //print(response.reasonPhrase);
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagePage(),
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.message_outlined,
                  color: Colors.black54,
                ),
                Text(
                  "Message ",
                  style: TextStyle(color: Colors.black54),
                )
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              add_like();
            },
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
            onPressed: () {
              add_follow();
            },
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
                              Text(followers.toString()),
                              Text("ผู้ติดตาม")
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Column(
                            children: [Text(likeme.toString()), Text("ถูกใจ")],
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
