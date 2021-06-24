import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/screens/inboxPage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'package:viewgoal/screens/playPage.dart';
import 'package:viewgoal/screens/userPage.dart';
import 'dart:async';
import 'dart:convert';

import '../menu_bar.dart';
import 'giftPage.dart';

var cJson = [];
var cJsonF = [];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int user_id;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id != null && user_id > 0) {
      listplaying(user_id.toString());
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> listplaying(id) async {
    var request =
        http.Request('GET', Uri.parse(hostname + '/listplaying?user_id=' + id));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      var req = {};
      req = jsonDecode(receivedJson);
      cJson = req["listplay"];
      cJsonF = req["listSave"];
      //print(cJsonF);
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  Future<void> listplayingS(id, text) async {
    var request = http.Request(
        'GET', Uri.parse(hostname + '/listS?user_id=' + id + '&text=' + text));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cJson = jsonDecode(receivedJson);
      setState(() {});
    } else {
      //print(response.reasonPhrase);
    }
  }

  @override
  initState() {
    super.initState();
    ch();
    //print(chLogin);
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    ch();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    ch();
    setState(() {});
    _refreshController.loadComplete();
  }

  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: TabBar(
        tabs: [
          Tab(
            child: Text(
              "Hot",
              style: TextStyle(color: Color(0xFFF1771A)),
            ),
          ),
          Tab(
            child: Text(
              "Save",
              style: TextStyle(color: Color(0xFFF1771A)),
            ),
          ),
        ],
      ),
      actions: [
        Container(
          child: searchBar.getSearchAction(context),
          color: Color(0xFFF1771A),
        )
      ],
    );
  }

  void onSubmitted(String value) {
    listplayingS(user_id.toString(), value);
  }

  _HomePageState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          //print("cleared");
        },
        onClosed: () {
          //print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: searchBar.build(context),
        key: _scaffoldKey,
        body: TabBarView(
          children: [
            SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text(" ");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: cJson.length,
                itemBuilder: (context, index) {
                  return FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PlayPage(idcam: cJson[index]["_id"])),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Color(0xFFF1771A),
                              child: Image.network(hostname +
                                  '/imageVideo/' +
                                  cJson[index]["_id"] +
                                  '.jpg'),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserPage(
                                                  userid: cJson[index]
                                                          ["user_id"]
                                                      .toString())),
                                        );
                                      },
                                    ),
                                    backgroundImage: NetworkImage(hostname +
                                        "/images-profile/" +
                                        cJson[index]["user_id"].toString() +
                                        ".png"),
                                    radius: 30,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 3),
                                          child: Text("title: " +
                                              cJson[index]['title']),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 3),
                                          child: Text("TAG: " +
                                              cJson[index]['location']['name']),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                  'view ${cJson[index]['view']}'),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 50),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.favorite),
                                                    Text(
                                                        '${cJson[index]['like']}')
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text(" ");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: cJsonF.length,
                itemBuilder: (context, index) {
                  return FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PlayPage(idcam: cJsonF[index]["idcam"])),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Color(0xFFF1771A),
                              child: Image.network(hostname +
                                  '/imageVideo/' +
                                  cJson[index]["_id"] +
                                  '.jpg'),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 3),
                                          child: Text("title: " +
                                              cJson[index]["title"].toString()),
                                        ),
                                        /*Container(
                                          margin: EdgeInsets.only(top: 3),
                                          child: Text("city: "),
                                        ),*/
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
