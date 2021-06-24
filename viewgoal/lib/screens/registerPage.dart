import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/main.dart';
import 'package:viewgoal/screens/loginPage.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RegisterPage> {
  String birthday;

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
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFF1771A),
        elevation: 0.3,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          child: ListView(children: [Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Register",
                    style: TextStyle(color: Color(0xFFF1771A), fontSize: 20),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: email,
                      validator: (value) =>
                      value.isEmpty || !value.contains("@")
                          ? "enter a valid eamil"
                          : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: password,
                      validator: (value) =>
                      value.isEmpty ? 'Input cannot be empty!' : null,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
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
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: name,
                      validator: (value) =>
                      value.isEmpty ? 'Input cannot be empty!' : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Display Name',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: DateTimePicker(
                      validator: (value) =>
                      value.isEmpty ? 'Input cannot be empty!' : null,
                      type: DateTimePickerType.date,
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2050),
                      initialValue: '',
                      dateLabelText: 'Birth Day',
                      onChanged: (val) => birthday = val,
                      onSaved: (val) => print(val),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: RaisedButton(
                      color: Color(0xFFF1771A),
                      onPressed: () => register(),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )],),
        ),
      ),
    );
  }
}
