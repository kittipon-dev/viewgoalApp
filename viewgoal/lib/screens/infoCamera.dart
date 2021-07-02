import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/main.dart';
import 'package:viewgoal/screens/loginPage.dart';

class InfoCamera extends StatefulWidget {
  InfoCamera({Key key, this.data}) : super(key: key);
  var data;

  @override
  _infoCameraPage createState() => _infoCameraPage();
}

class _infoCameraPage extends State<InfoCamera> {

  Future<void> removedcam() async {
    var request = await http.Request(
        'GET', Uri.parse(hostname + '/removedcam?_id=' + widget.data["_id"]));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      appBar: AppBar(
        leading: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => removedcam(),
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 30,
              ))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text("Titile: " + widget.data["title"]),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text("Like: " + widget.data["like"].toString()),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text("View: " + widget.data["view"].toString()),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text("URL RTSP: " + widget.data["url"]),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                    "Location: Lat ${widget.data["location"]["lat"]} Long ${widget.data["location"]["long"]}"),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  child: Text(
                    'Edit Camera',
                  ),
                  onPressed: () {
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCameraPage(
                            id: user_id.toString()),
                      ),
                    ).then((_) {
                      getMe();
                    });
                     */
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
