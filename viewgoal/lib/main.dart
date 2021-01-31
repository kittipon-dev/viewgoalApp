import 'package:flutter/material.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/mePage.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MePage(),
    );
  }
}
