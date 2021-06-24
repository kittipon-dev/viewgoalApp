import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class ErrorConnectServer extends StatefulWidget {
  @override
  _ErrorConnectServer createState() => _ErrorConnectServer();
}

class _ErrorConnectServer extends State<ErrorConnectServer> {
  Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          exit(0);
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("มีปัญหาในการเชื่อม... กรุณาลองใหม่ในภายหลัง"),
              Container(
                height: 70,
              ),
              RaisedButton(
                onPressed: () {
                  exit(0);
                },
                child: Text("Close ($_start s)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
