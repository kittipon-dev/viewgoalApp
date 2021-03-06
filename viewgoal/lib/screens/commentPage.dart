import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

/// This is the stateful widget that the main application instantiates.
class CommentPage extends StatefulWidget {
  CommentPage({Key key, this.idcam, this.cComment}) : super(key: key);
  String idcam;
  var cComment = [];

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

var cComment = [];

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<CommentPage> {
  int slogin;
  int user_id;

  bool f = false;
  bool l = false;

  final txtpost = TextEditingController();

  var img = NetworkImage(hostname + '/images-profile/null.png');

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    slogin = await prefs.get('login');
    if (slogin != 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else if (slogin == 1) {
      user_id = prefs.get('user_id');
      //getComment(widget.idcam);
    }
  }

  Future<void> getComment(id) async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/get_comment?idcam=' + id));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cComment = jsonDecode(receivedJson);
      setState(() {});
    }
  }

  Future<void> PostComment() async {
    var request = await http.Request(
        'POST',
        Uri.parse(hostname +
            '/postcomment?user_id=' +
            user_id.toString() +
            '&idcam=' +
            widget.idcam +
            '&commentTxt=' +
            txtpost.text));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      getComment(widget.idcam);
      txtpost.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    ch();
    getComment(widget.idcam);
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
              padding:
                  EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TextField(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        controller: txtpost,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      PostComment();
                    },
                    child: Text("Post"),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ListView.builder(
                  itemCount: cComment.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Card(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(hostname +
                                  '/images-profile/${cComment[index]["user_id"]}.png'),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserPage(user_id: cComment[index]["user_id"].toString(),)),
                                  );
                                },
                              ),
                            ),
                            Text(cComment[index]["comment"])
                          ],
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
