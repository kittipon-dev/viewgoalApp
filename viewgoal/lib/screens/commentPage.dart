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
  int user_id;
  bool f = false;
  bool l = false;

  final txtpost = TextEditingController();

  var img = NetworkImage(hostname + '/images-profile/null.png');

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id != null && user_id > 0) {
      getComment(widget.idcam.toString());
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
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
                      margin: EdgeInsets.only(top: 15),
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
                                      builder: (context) => UserPage(
                                            userid: cComment[index]["user_id"]
                                                .toString(),
                                          )),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Text(cComment[index]["comment"]),
                            ),
                          ),
                        ],
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
