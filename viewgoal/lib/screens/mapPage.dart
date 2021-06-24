import 'dart:convert';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewgoal/screens/giftPage.dart';
import 'package:viewgoal/screens/homePage.dart';
import 'package:viewgoal/screens/inboxPage.dart';
import 'package:viewgoal/screens/loginPage.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

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

const kGoogleApiKey = "AIzaSyD2PyV-Twc60XZs2y9eFhKwkxmDmc2FGsk";

class _MapPageState extends State<MapPage> {
  List<Marker> _marker = [];
  var cJson = [];

  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  CameraPosition _initialPosition = CameraPosition(target: LatLng(13.736717,100.523186), zoom: 5);
  double _lat = 13.736717;
  double _lng = 100.523186;
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

  GoogleMapController controller;

  void _onMapCreated(controller) {
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
    //_goToMe();
  }

  double _zoom = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                size: 35,
                color: Color(0xffF1771A),
              ),
              onPressed: _handlePressButton)
        ],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        initialCameraPosition:_initialPosition,
        onMapCreated: _onMapCreated,
        markers: Set.from(_marker),
      ),
      /*
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _handlePressButton,
              child: Text('Search places'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/search');
              },
              child: Text('Custom'),
            ),
          ],
        ),
      ),
      */
    );
  }

  Mode _mode = Mode.overlay;

  Future<void> _handlePressButton() async {
    void onError(PlacesAutocompleteResponse response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.errorMessage ?? 'Unknown error'),
        ),
      );
    }

    // show input autocomplete with selected mode
    // then get the Prediction selected
    final p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: 'th',
      components: [Component(Component.country, 'th')],
    );

    final _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    final detail = await _places.getDetailsByPlaceId(p.placeId);
    final geometry = detail.result.geometry;
    final lat = geometry.location.lat;
    final lng = geometry.location.lng;

    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: 20,
    )));

    //print(lat);
    //await displayPrediction(p, ScaffoldMessenger.of(context));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldMessengerState messengerState) async {
    if (p == null) {
      return;
    }
    // get detail (lat/lng)
    final _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );

    final detail = await _places.getDetailsByPlaceId(p.placeId);
    final geometry = detail.result.geometry;
    final lat = geometry.location.lat;
    final lng = geometry.location.lng;

    var newPosition = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 30);

    CameraUpdate update =CameraUpdate.newCameraPosition(newPosition);

    messengerState.showSnackBar(
      SnackBar(
        content: Text('${p.description} - $lat/$lng'),
      ),
    );
    controller.moveCamera(update);
    _controller.complete(controller);

    print(p.description);


    /*
    messengerState.showSnackBar(
      SnackBar(
        content: Text('${p.description} - $lat/$lng'),
      ),
    );
    */
  }

/*
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
*/
/*
  Future<void> maptest() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay, // Mode.fullscreen
        language: "th",
        components: [new Component(Component.country, "th")]);
  }
*/
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
