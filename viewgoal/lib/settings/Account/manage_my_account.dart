import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/main.dart';
import 'package:viewgoal/screens/loginPage.dart';

class ManageMyAccount extends StatefulWidget {
  ManageMyAccount({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ManageMyAccountState createState() => _ManageMyAccountState();
}

class _ManageMyAccountState extends State<ManageMyAccount> {
  String birthday;
  var req = {};
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();
  final trypassword = TextEditingController();
  final name = TextEditingController();

  String error = "";

  Future<void> register() async {
    if (_formKey.currentState.validate()) {
      if (password.text == trypassword.text) {
        final http.Response response = await http.post(
          Uri.parse(hostname + '/register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': email.text,
            'password': password.text,
            'name': name.text,
            'birthday': birthday
          }),
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> r = jsonDecode(response.body);
          print(response.body);
          if (r["login"] == 1) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setInt('user_id', r["user_id"]);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false);
          }
        } else {
          print("NO ok");
        }
      } else {
        setState(() {
          error = "รหัสผ่านไม่ตรงกัน";
        });
      }
    }
  }

  Future<void> getMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user_id = await prefs.get('user_id');
    if (user_id != null && user_id > 0) {
      var request = await http.Request(
          'GET', Uri.parse(hostname + '/getmail?user_id=' + user_id.toString()));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        email.text = await response.stream.bytesToString();
        setState(() {});
      }else{
        Navigator.pop(context);
      }
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMe();
  }

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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(30),
            child: ListView(
              children: [
                Text(
                  "Manage my account",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: TextFormField(
                    controller: email,
                    validator: (value) => value.isEmpty || !value.contains("@")
                        ? "enter a valid eamil"
                        : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: TextFormField(
                    controller: password,
                    validator: (value) =>
                    value.isEmpty ? 'Input cannot be empty!' : null,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Password',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: TextFormField(
                    controller: trypassword,
                    validator: (value) =>
                    value.isEmpty ? 'Input cannot be empty!' : null,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: TextFormField(
                    controller: name,
                    validator: (value) =>
                    value.isEmpty ? 'Input cannot be empty!' : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Old Password',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: RaisedButton(
                    color: Color(0xFFF1771A),
                    onPressed: () => register(),
                    child: Text(
                      "Save changes",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
