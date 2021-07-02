import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_location_picker/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/constant.dart';
import 'package:viewgoal/dark_theme_provider.dart';
import 'package:viewgoal/error/connect_server.dart';
import 'package:viewgoal/screens/addCamera.dart';
import 'package:viewgoal/screens/giftPage.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/inboxPage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'package:viewgoal/screens/registerPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/l10n.dart'
    as location_picker;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        location_picker.S.delegate,
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[Locale('th', ''), Locale('en', '')],
      home: (MainPage()),
    );
  }
}
*/
class MyApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  int user_id = -1;
  bool online;
  bool tOnline = false;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

  //  var url = Uri.http('52.77.11.127:2311', '/check_online');

    var request = await http.Request(
        'GET', Uri.parse(hostname + '/check_online'));
    http.StreamedResponse response = await request.send();

/*
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url).timeout(
      Duration(seconds: 5),
      onTimeout: () {
        startTimer();
        print("aaaaaaaaaaaaaaaaa");
        online = false;
        setState(() {});
      },
    );
  */
    tOnline = true;
    if (response.statusCode == 200) {
      print(" ONline");
      online = true;
      user_id = await prefs.get('user_id');
      user_id == null ? user_id = 0 : 0;
      if (user_id != null && user_id > 0) {
      } else {
/*
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
*/
      }
      setState(() {});
    } else {
      print("OFF");
    }

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    getCurrentAppTheme();
    ch();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.devFestPreferences.getTheme();
  }

  int _currentIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MapPage(),
    InboxPage(),
    GiftPage(),
    MePage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        )
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeChangeProvider.darkTheme == true
                ? ThemeData.dark()
                : ThemeData.light(),
            home: user_id > -1
                ? Scaffold(
                    body: Container(
                      child: _widgetOptions.elementAt(_currentIndex),
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Color(0xFFF1771A),
                      iconSize: 30,
                      currentIndex: _currentIndex,
                      onTap: _onItemTap,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: "Home",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.map),
                          label: "Map",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.inbox),
                          label: "Inbox",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.card_giftcard),
                          label: "Gift",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person_outline),
                          label: "Me",
                        ),
                      ],
                    ),
                  )
                : Scaffold(
                    body: tOnline == false
                        ? Container(
                            color: Color(0xFFF1771A),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    "มีปัญหาในการเชื่อม... กรุณาลองใหม่ในภายหลัง"),
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
        },
      ),
    );
  }
}
