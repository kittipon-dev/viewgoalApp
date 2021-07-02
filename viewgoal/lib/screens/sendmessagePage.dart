import 'dart:convert';
import 'dart:io';

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
import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'giftPage.dart';
import 'package:socket_io_client/socket_io_client.dart';

var cJson = {};
var list = [];
String urlimgprofile = hostname + '/images-profile/null.png';

/// This is the stateful widget that the main application instantiates.
class SendMessagePage extends StatefulWidget {
  SendMessagePage({Key key, this.ruserid}) : super(key: key);
  String ruserid;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<SendMessagePage> {
  int slogin;
  int user_id;
  bool f = false;
  bool l = false;

  final txtpost = TextEditingController();

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id != null && user_id > 0) {
      getMes();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> initializePlayer() async {}

  Future<void> sendMes() async {
    final http.Response response = await http.post(
      Uri.parse(hostname + '/sendmes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        't_user_id': user_id.toString(),
        'r_user_id': widget.ruserid,
        'mes': txtpost.text,
      }),
    );
    if (response.statusCode == 200) {
      list.add({
        't_user_id': user_id.toString(),
        'r_user_id': widget.ruserid,
        'mes': txtpost.text,
      });
      txtpost.text = "";
      setState(() {});
    }
  }

  Future<void> getMes() async {
    var request = await http.Request(
        'GET',
        Uri.parse(hostname +
            '/get_mes?r_user_id=' +
            widget.ruserid +
            '&t_user_id=' +
            user_id.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cJson = jsonDecode(receivedJson);
      list = cJson["data"];
      setState(() {
        txtpost.text = "";
      });
    }
  }

  void io() {
    print('IO');
    // Dart client
    IO.Socket socket = IO.io(
        'http://192.168.2.14:3000',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.close();
    socket.connect();
    socket.onConnect((data) {
      print("connected");
      socket.emit("message");
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('2', (_) => ioadd(_));
  }

  void ioadd(_) {
    list.add(_);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ch();
    io();
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
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return list[index]["t_user_id"] == user_id.toString()
                        ? Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 200),
                            child: Card(
                              color: Colors.indigoAccent,
                              child: Text(
                                list[index]["mes"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 50,
                            padding: EdgeInsets.only(right: 200),
                            child: Card(
                              child: Text(
                                list[index]["mes"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TextField(
                        style: TextStyle(fontSize: 20),
                        controller: txtpost,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (txtpost.text != "") {
                        sendMes();
                      }
                    },
                    child: Text("Send"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
