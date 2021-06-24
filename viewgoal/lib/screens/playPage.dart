import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
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
import 'package:webview_flutter/webview_flutter.dart';

import 'giftPage.dart';

var res = {};
var cJson = {};
var list = [];
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
  int user_id;

  bool f = false;
  bool l = false;

  VlcPlayerController _videoPlayerController;

  Future<void> initializePlayer() async {}

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id != null && user_id > 0) {
      getPlay(widget.idcam);
      getComment(widget.idcam);
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
      res = jsonDecode(receivedJson);
      cJson = res["Camera"];
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
      var myobj = jsonDecode(receivedJson);
      list = myobj["listplay"];
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  Future<void> save(id) async {
    if (res["sSave"] == false) {
      var request = http.Request(
        'GET',
        Uri.parse(hostname +
            '/addfavorite?user_id=' +
            user_id.toString() +
            '&idcam=' +
            widget.idcam),
      );
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          getPlay(widget.idcam);
        });
      } else {
        //print(response.reasonPhrase);
      }
    } else if (res["sSave"] == true) {
      var request = http.Request(
        'GET',
        Uri.parse(hostname +
            '/removefavorite?user_id=' +
            user_id.toString() +
            '&idcam=' +
            widget.idcam),
      );
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        getPlay(widget.idcam);
        setState(() {
          getPlay(widget.idcam);
        });
      } else {
        //print(response.reasonPhrase);
      }
    }
  }

  Future<void> like(l) async {
    if (l == false) {
      var request = http.Request(
        'GET',
        Uri.parse(hostname +
            '/like?t_user_id=' +
            user_id.toString() +
            '&idcam=' +
            widget.idcam),
      );
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
            '/unlike?t_user_id=' +
            user_id.toString() +
            '&idcam=' +
            widget.idcam),
      );
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

    _videoPlayerController = VlcPlayerController.network(
      'http://52.77.11.127:8000/live/${widget.idcam}.flv',
      hwAcc: HwAcc.FULL,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
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
        actions: [
          FlatButton(
              onPressed: () {
                save(res["sSave"]);
              },
              child: Row(
                children: [
                  Icon(
                    res["sSave"] == true ? Icons.remove : Icons.add,
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
            Container(
              child: VlcPlayer(
                controller: _videoPlayerController,
                aspectRatio: 16 / 9,
                placeholder: Center(child: CircularProgressIndicator()),
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
                                    userid: cJson["user_id"].toString())),
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
                                //textColor: Colors.black,
                                onPressed: () {
                                  like(res["sLike"]);
                                },
                                child: Row(
                                  children: [
                                    Icon(res["sLike"] == false
                                        ? Icons.favorite_outline
                                        : Icons.favorite),
                                    Text("  " + cJson["like"].toString())
                                  ],
                                ),
                              ),
                              FlatButton(
                                //textColor: Colors.black,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommentPage(
                                        idcam: widget.idcam,
                                        cComment: cComment,
                                      ),
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
                  return list[index]["_id"] != widget.idcam
                      ? FlatButton(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(list[index]["title"]),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text(
                                              list[index]["location"]["name"]),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
