import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/menu_bar.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'dart:async';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';

import 'giftPage.dart';

var cJson = [];

class InboxPage extends StatefulWidget {
  InboxPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InboxPage> {
  int slogin;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    slogin = await prefs.get('login');
    if (slogin != 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  initState() {
    super.initState();
    ch();
  }

  int _selectedIndex = 2;
  final page = [HomePage(), MapPage(), InboxPage(),GiftPage(), MePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => page[_selectedIndex]),
              (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: menuBar,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFFF1771A),
                  size: 30,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.mail_outline,
                  color: Color(0xFFF1771A),
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notification",
                        style:
                            TextStyle(color: Color(0xFFF1771A), fontSize: 20),
                      ),
                      Icon(Icons.search_rounded)
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cJson.length,
                      itemBuilder: (context, index) {
                        return FlatButton(
                          onPressed: () {},
                          child: Card(
                            child: Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 100,
                                  color: Color(0xFFF1771A),
                                  child: Icon(
                                    Icons.play_circle_outline_outlined,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text("รายละเอียด…………………………………"),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Massages",
                        style:
                            TextStyle(color: Color(0xFFF1771A), fontSize: 20),
                      ),
                      Icon(Icons.search_rounded)
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cJson.length,
                      itemBuilder: (context, index) {
                        return FlatButton(
                          onPressed: () {},
                          child: Card(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_circle_outlined,
                                  color: Colors.black,
                                  size: 50,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text("รายละเอียด…………………………………"),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
