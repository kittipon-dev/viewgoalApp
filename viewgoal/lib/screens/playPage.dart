import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/menu_bar.dart';
import 'package:viewgoal/screens/commentPage.dart';
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
var cComment = [];
String urlimgprofile = hostname + '/images-profile/null.png';

/// This is the stateful widget that the main application instantiates.
class PlayPage extends StatefulWidget {
  PlayPage({Key key, this.idcam}) : super(key: key);
  String idcam;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<PlayPage> {
  int slogin;
  int user_id;

  bool f = false;
  bool l = false;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    slogin = await prefs.get('login');
    if (slogin != 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else if (slogin == 1) {
      user_id = prefs.get('user_id');
      getPlay(widget.idcam);
      getComment(widget.idcam);
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

  Future<void> getPlay(id) async {
    var request = await http.Request(
        'GET',
        Uri.parse(hostname +
            '/getplay?_id=' +
            id +
            '&user_id=' +
            user_id.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cJson = jsonDecode(receivedJson);
      urlimgprofile = hostname + '/images-profile/${cJson["user_id"]}.png';
      listplaying(user_id.toString());
    }
  }

  Future<void> listplaying(id) async {
    var request =
        http.Request('GET', Uri.parse(hostname + '/listplaying?user_id=' + id));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      var req = {};
      req = jsonDecode(receivedJson);
      list = req["listplay"];
      listF = req["favorite"];
      listLike = req["user"]["like"];
      for (var i = 0; i < listLike.length; i++) {
        if (listLike[i] == widget.idcam) {
          l = true;
        } else {
          l = false;
        }
      }
      for (var i = 0; i < listF.length; i++) {
        if (listF[i]["_id"] == widget.idcam) {
          f = true;
        } else {
          f = false;
        }
      }
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  Future<void> add_favorite(id) async {
    var request = http.Request(
        'GET',
        Uri.parse(hostname +
            '/addfavorite?user_id=' +
            id +
            '&idcam=' +
            widget.idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      getPlay(widget.idcam);
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  Future<void> remove_favorite(id) async {
    var request = http.Request(
        'GET',
        Uri.parse(hostname +
            '/removefavorite?user_id=' +
            id +
            '&idcam=' +
            widget.idcam));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      getPlay(widget.idcam);
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  Future<void> like() async {
    if (l == false) {
      var request = http.Request(
          'GET',
          Uri.parse(hostname +
              '/like?user_id=' +
              user_id.toString() +
              '&idcam=' +
              widget.idcam));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        getPlay(widget.idcam);
        setState(() {});
      } else {
        //print(response.reasonPhrase);
      }
    } else if (l == true) {
      var request = http.Request(
          'GET',
          Uri.parse(hostname +
              '/unlike?user_id=' +
              user_id.toString() +
              '&idcam=' +
              widget.idcam));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        getPlay(widget.idcam);
        setState(() {});
      } else {
        //print(response.reasonPhrase);
      }
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
        actions: [
          FlatButton(
              onPressed: () {
                if (f == false) {
                  add_favorite(user_id.toString());
                } else {
                  remove_favorite(user_id.toString());
                }
              },
              child: Row(
                children: [
                  Icon(
                    f == true ? Icons.remove : Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ))
        ],
        backgroundColor: Color(0xFFF1771A),
        elevation: 0.3,
      ),
      body: SafeArea(
        child: Column(
          children: [
            /*
            Container(
              child: VlcPlayer(
                controller: _videoPlayerController,
                aspectRatio: 16 / 9,
                placeholder: Center(child: CircularProgressIndicator()),
              ),
            ),
             */
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(50),
              color: Colors.blue,
              child: Icon(
                Icons.play_circle_outline_outlined,
                color: Colors.white,
                size: 150,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Container(
                    child: CircleAvatar(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserPage(
                                    user_id: cJson["user_id"].toString())),
                          );
                        },
                      ),
                      backgroundImage: NetworkImage(urlimgprofile),
                      radius: 30,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(cJson["title"] ?? "title"),
                        ),
                        Container(
                          child: ButtonBar(
                            children: [
                              Text(cJson["view"].toString() + " view"),
                              FlatButton(
                                textColor: Colors.black,
                                onPressed: () {
                                  like();
                                },
                                child: Row(
                                  children: [
                                    Icon(l == false
                                        ? Icons.favorite_outline
                                        : Icons.favorite),
                                    Text("  " + cJson["like"].toString())
                                  ],
                                ),
                              ),
                              FlatButton(
                                textColor: Colors.black,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CommentPage(idcam: widget.idcam,cComment: cComment,),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.comment_outlined),
                                    Text(" " + cComment.length.toString())
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
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PlayPage(idcam: list[index]["_id"])),
                      );
                    },
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
