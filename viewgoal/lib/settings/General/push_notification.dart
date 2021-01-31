import 'package:flutter/material.dart';

class PushNotification extends StatefulWidget {
  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Push notifications"),
      ),
    );
  }
}
