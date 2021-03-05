import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/screens/loginPage.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'dart:async';
import 'dart:convert';

import '../menu_bar.dart';
import 'giftPage.dart';
import 'mePage.dart';
import 'inboxPage.dart';
import 'homePage.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  /*
  LatLng _initialcameraposition = LatLng(13.7650836, 100.537966);
  GoogleMapController _controller;
  Location _location = Location();
*/

  Completer<GoogleMapController> _controller = Completer();

  LocationData currentLocation;

  // int slogin;

  // Future<void> ch() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   slogin = await prefs.get('s');
  //   if (slogin != 1) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => LoginPage(),
  //       ),
  //     );
  //   }
  // }

  @override
  initState() {
    super.initState();
    // ch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          _googleMap(context),
          Positioned(
            top: 50.0,
            right: 40.0,
            left: 40.0,
            child: Container(
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
                    onPressed: () {},
                    iconSize: 30,
                    color: Colors.grey,
                  ),
                ),
              ),
            ), //search bar
          ),
          Positioned(
            // left: 10,
            right: -13,
            bottom: 105,
            child: RawMaterialButton(
              onPressed: () {
                // _goToMe();
              },
              elevation: 0,

              fillColor: Colors.white.withOpacity(0.7),
              child: Icon(
                Icons.my_location_sharp,
                size: 25.0,
                color: Color.fromRGBO(101, 101, 103, 1),
              ),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
    );
  }

  // void getCurrentLocation() async {
  //   var position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   var lastPosition = await Geolocator.getLastKnownPosition();
  //   double lat = position.latitude;
  //   double long = position.longitude;
  //   print("$lat , $long");
  //   print(lastPosition);
  // }

  // Future<LocationData> getCurrentLocation() async {
  //   Location location = Location();
  //   try {
  //     return await location.getLocation();
  //   } on PlatformException catch (e) {
  //     if (e.code == 'PERMISSION_DENIED') {
  //       // Permission denied
  //     }
  //     return null;
  //   }
  // }

  // Future _goToMe() async {
  //   final GoogleMapController controller = await _controller.future;
  //   currentLocation = await getCurrentLocation();
  //   controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(currentLocation.latitude, currentLocation.longitude),
  //         zoom: 16,
  //       ),
  //     ),
  //   );
  // }

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition:
        CameraPosition(target: LatLng(13.736717, 100.523186), zoom: 5),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {},
      ),
    );
  }
}
