import 'package:flutter/material.dart';

class CopyrightPolicy extends StatefulWidget {
  @override
  _CopyrightPolicyState createState() => _CopyrightPolicyState();
}

class _CopyrightPolicyState extends State<CopyrightPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Copyright policy"),
      ),
    );
  }
}
