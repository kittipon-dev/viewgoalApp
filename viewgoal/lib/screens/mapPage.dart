import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/screens/giftPage.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/inboxPage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:viewgoal/screens/mePage.dart';
import 'package:viewgoal/screens/playPage.dart';

import 'dart:async';

import '../config.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> _marker = [];
  var cJson = [];

  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;

  BitmapDescriptor customIcon;

  customMarkerIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.5), 'assets/images/pin.png');
  }

  Future<void> getMarker() async {
    var request = await http.Request(
      'GET',
      Uri.parse(hostname + '/getmap'),
    );
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String receivedJson = await response.stream.bytesToString();
      cJson = jsonDecode(receivedJson);
      print(cJson);

      setState(() {
        for (int i = 0; i < cJson.length; i++) {
          _marker.add(
            Marker(
                markerId: MarkerId(cJson[i]['_id']),
                position: LatLng(double.parse(cJson[i]['location']['lat']),
                    double.parse(cJson[i]['location']['long'])),
                infoWindow: InfoWindow(title: cJson[i]['title']),
                icon: customIcon,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayPage(idcam: cJson[i]["_id"])),
                  );
                }),
          );
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  int user_id;

  Future<void> ch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = await prefs.get('user_id');
    if (user_id > 0) {
    } else {
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
    customMarkerIcon();
    getMarker();
    _goToMe();
  }

  // int _currentIndex = 1;
  // List<Widget> _widgetOptions = <Widget>[
  //   HomePage(),
  //   MapPage(),
  //   InboxPage(),
  //   GiftPage(),
  //   MePage(),
  // ];
  // void _onItemTap(int index) {
  //   setState(() {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => _widgetOptions[_currentIndex]),
  //     );
  //     _currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Stack(
            children: [
              Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: TextField(
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        print("123");
                      },
                      iconSize: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //     type: BottomNavigationBarType.fixed,
        //     selectedItemColor: Colors.amber[800],
        //     iconSize: 30,
        //     currentIndex: _currentIndex,
        //     onTap: _onItemTap,
        //     items: bnb),
        body: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition:
              CameraPosition(target: LatLng(13.736717, 100.523186), zoom: 5),
          onMapCreated: _onMapCreated,
          markers: Set.from(_marker),
        ));
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 16,
        ),
      ),
    );
  }

//   Widget _googleMap(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition:
//             CameraPosition(target: LatLng(13.736717, 100.523186), zoom: 5),
//         onMapCreated: _onMapCreated,
//         markers: Set.from(_marker),
//         myLocationButtonEnabled: true,
//       ),
//     );
//   }

}
