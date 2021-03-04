import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
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

var cJson = {};
var list = [];
var listF = [];
var listLike = [];
String urlimgprofile = hostname + '/images-profile/null.png';

/// This is the stateful widget that the main application instantiates.
class CommentPage extends StatefulWidget {
  CommentPage({Key key, this.idcam}) : super(key: key);
  String idcam;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<CommentPage> {
  int slogin;
  int user_id;

  bool f = false;
  bool l = false;

  final txtpost = TextEditingController();

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    slogin = await prefs.get('login');
    if (slogin != 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else if (slogin == 1) {
      user_id = prefs.get('user_id');
      getComment(widget.idcam);
    }
  }

  Future<void> initializePlayer() async {}

  Future<void> getComment(id) async {
    var request = await http.Request(
        'GET',
        Uri.parse(hostname +
            '/comment?_id=' +
            id +
            '&user_id=' +
            user_id.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cJson = jsonDecode(receivedJson);
      /*
      urlimgprofile = hostname + '/images-profile/${cJson["user_id"]}.png';
      listplaying(user_id.toString());
       */
    }
  }

  @override
  void initState() {
    super.initState();
    ch();
  }

  int _selectedIndex = 0;
  final page = [HomePage(), MapPage(), InboxPage(), GiftPage(), MePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => page[_selectedIndex]),
          (Route<dynamic> route) => false);
    });
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
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFF1771A),
        elevation: 0.3,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: txtpost,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'ข้อความ',
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                ),
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: () {},
                child: Text("Post"),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
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
                                    child: Text(list[index]["title"]),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child:
                                        Text(list[index]["location"]["name"]),
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
