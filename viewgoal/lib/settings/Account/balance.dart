import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/settings/Account/top_up.dart';
import 'package:http/http.dart' as http;

class Balance extends StatefulWidget {
  @override
  _BalanceState createState() => _BalanceState();
}

var cUser = {};

class _BalanceState extends State<Balance> {
  int user_id;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id > 0) {
      get_point(user_id.toString());
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> get_point(id) async {
    var request =
        http.Request('GET', Uri.parse(hostname + '/get_point?user_id=' + id));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cUser = jsonDecode(receivedJson);
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  @override
  initState() {
    super.initState();
    ch();
    //print(chLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: Color(0xff707070)),
          ),
          title: Text(
            'Balance',
            style: TextStyle(
              color: Color(0xffF1771A),
              fontFamily: 'Segoe',
            ),
          ),
          centerTitle: true),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 15, right: 16),
        child: ListView(
          children: [
            Text('จำนวนเหรียญ'),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.attach_money),
                Text(
                  cUser["point"].toString(),
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopUp(),
                      ),
                    );
                  },
                  child: Text(
                    'เติมเงิน',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFFff0000),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'โปรโมชั่น',
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_sharp)
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'กิจกรรม',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_sharp)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
