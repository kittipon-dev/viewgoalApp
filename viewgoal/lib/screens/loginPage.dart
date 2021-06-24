import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/main.dart';
import 'package:viewgoal/screens/generated/repassPage.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/registerPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  int user_id;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    print(user_id);
    if (user_id != null && user_id > 0) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyApp()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    ch();
  }

  Future<void> login() async {
    final http.Response response = await http.post(
      Uri.parse(hostname + '/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': email.text, 'password': password.text}),
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
    } else if (response.statusCode == 401) {
      password.text = "";
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Sending Message"),
      ));
    }
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 15),
              Text(
                'ViewGoal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                'After You View >...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(112, 112, 112, 1),
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Text(
                  'Login to ViewGoal',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(241, 119, 26, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Email',
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Password',
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                //color: Colors.amber,
                child: Column(
                  children: [
                    TextButton(
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 16,
                          //color: Colors.black45
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RePassPage()),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => login(),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              /*Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      textColor: Colors.white,
                      color: Color.fromRGBO(241, 119, 26, 1),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => login(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    RaisedButton(
                      textColor: Colors.white,
                      color: Color.fromRGBO(241, 119, 26, 1),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
