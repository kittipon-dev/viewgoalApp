import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:http/http.dart' as http;
import 'package:viewgoal/screens/loginPage.dart';

class TopUp extends StatefulWidget {
  @override
  _TopUpState createState() => _TopUpState();
}

var cJson = {};

class _TopUpState extends State<TopUp> {
  int slogin;
  int user_id;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    slogin = await prefs.get('login');
    if (slogin != 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else if (slogin == 1) {
      user_id = prefs.get('user_id');
    }
  }

  Future<void> top_up(price) async {
    var request = await http.Request(
        'GET',
        Uri.parse(hostname +
            '/top_up?user_id=' +
            user_id.toString() +
            '&price=' +
            price.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(context);
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
            'เติมเงิน',
            style: TextStyle(
              color: Color(0xffF1771A),
              fontFamily: 'Segoe',
            ),
          ),
          centerTitle: true),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              top_up(10);
            },
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            title: Text(
              '1 วัน',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '10 เหรียญ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '10 บาท',
              style: TextStyle(
                  color: Color(0xFFFE0000), fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            onTap: () {
              top_up(100);
            },
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            title: Text(
              '1 สัปดาห์',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '100 เหรียญ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '59 บาท',
              style: TextStyle(
                  color: Color(0xFFFE0000), fontWeight: FontWeight.bold),
            ),
          ),
          Divider(thickness: 2),
          ListTile(
            onTap: () {
              top_up(100);
            },
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            title: Text(
              '1 เดือน',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '100 เหรียญ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '199 บาท',
              style: TextStyle(
                  color: Color(0xFFFE0000), fontWeight: FontWeight.bold),
            ),
          ),
          Divider(thickness: 2),
          ListTile(
            onTap: () {
              top_up(8000);
            },
            visualDensity: VisualDensity(horizontal: 0, vertical: -3),
            title: Text(
              '1 ปี',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '8,000 เหรียญ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              '1,990 บาท',
              style: TextStyle(
                  color: Color(0xFFFE0000), fontWeight: FontWeight.bold),
            ),
          ),
          Divider(thickness: 2),
        ],
      ),
    );
  }

// ListView _buildListView() {
//   return ListView.builder(
//       itemCount: 4,
//       itemBuilder: (_, index) {
//         return ListTile(
//           title: Text('HI'),
//         );
//       });
// }

}
