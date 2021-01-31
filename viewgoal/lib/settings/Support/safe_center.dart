import 'package:flutter/material.dart';

class SafeCenter extends StatefulWidget {
  @override
  _SafeCenterState createState() => _SafeCenterState();
}

class _SafeCenterState extends State<SafeCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Safe Center"),
      ),
    );
  }
}
