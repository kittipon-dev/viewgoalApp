import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/config.dart';
import 'package:viewgoal/screens/inboxPage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:viewgoal/screens/mapPage.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'package:viewgoal/screens/playPage.dart';
import 'dart:async';
import 'dart:convert';

import '../menu_bar.dart';
import 'giftPage.dart';

var cJson = [];
var cJsonF = [];

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int user_id;


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
      cJsonF = req["favorite"];
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

  int _currentIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Home(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[800],
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
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    print("OnRef");
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length+1).toString());
    print("OnLoad");
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
            FlatButton(onPressed: () {}, child: Icon(Icons.search_rounded))
          ],
        ),
        body: TabBarView(
          children: [
            SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context,LoadStatus mode){
                  Widget body ;
                  if(mode==LoadStatus.idle){
                    body =  Text("pull up load");
                  }
                  else if(mode==LoadStatus.loading){
                    body =  CupertinoActivityIndicator();
                  }
                  else if(mode == LoadStatus.failed){
                    body = Text("Load Failed!Click retry!");
                  }
                  else if(mode == LoadStatus.canLoading){
                    body = Text("release to load more");
                  }
                  else{
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child:body),
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
                              height: 200,
                              color: Color(0xFFF1771A),
                              child: Icon(
                                Icons.play_circle_outline_outlined,
                                color: Colors.white,
                                size: 150,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50.00),
                                    child: Image.network(
                                      hostname +
                                          "/images-profile/" +
                                          cJson[index]["user_id"].toString() +
                                          ".png",
                                      width: 40,
                                    ),
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
                                          child: Text("city: " +
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
            Container(
              child: ListView.builder(
                itemCount: cJsonF.length,
                itemBuilder: (context, index) {
                  return FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PlayPage(idcam: cJsonF[index]["_id"])),
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
                              height: 200,
                              color: Color(0xFFF1771A),
                              child: Icon(
                                Icons.play_circle_outline_outlined,
                                color: Colors.white,
                                size: 150,
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50.00),
                                    child: Image.network(
                                      hostname +
                                          "/images-profile/" +
                                          cJsonF[index]["user_id"].toString() +
                                          ".png",
                                      width: 40,
                                    ),
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
                                              cJsonF[index]['title']),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 3),
                                          child: Text("city: " +
                                              cJsonF[index]['location']
                                                  ['name']),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                  'view ${cJsonF[index]['view']}'),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 50),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.favorite),
                                                    Text(
                                                        '${cJsonF[index]['like']}')
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
          ],
        ),
      ),
    );
  }
}
