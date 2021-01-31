import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:viewgoal/config.dart';
import 'package:viewgoal/screens/loginPage.dart';


class registerPage extends StatefulWidget {
  registerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<registerPage> {
  String birthday;

  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();
  final trypassword = TextEditingController();
  final name = TextEditingController();

  String error = "";

  Future<void> register() async {
    print("r");
    if (_formKey.currentState.validate()) {
      print('Form Complete');
      if (password.text == trypassword.text) {
        final http.Response response = await http.post(
          hostname + '/register',
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
          Navigator.pop(context);
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(30),
            child: ListView(
              children: [
                Text(
                  "Register",
                  style: TextStyle(color: Color(0xFFF1771A)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: email,
                    validator: (value) =>
                    value.isEmpty ? 'Input cannot be empty!' : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email or Phone',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
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
                  margin: EdgeInsets.only(top: 10),
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
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: name,
                    validator: (value) =>
                    value.isEmpty ? 'Input cannot be empty!' : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First Name',
                    ),
                  ),
                ),
                Container(
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
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: RaisedButton(
                    color: Color(0xFFF1771A),
                    onPressed: () => register(),
                    child: Text(
                      "Sing Up",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
