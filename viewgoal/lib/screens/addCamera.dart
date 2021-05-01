import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:location/location.dart';
import 'package:viewgoal/config.dart';

import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_location_picker/generated/l10n.dart'
    as location_picker;

import 'generated/i18n.dart';

class AddCameraPage extends StatefulWidget {
  AddCameraPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddCameraPage> {
  final _formAdd = GlobalKey<FormState>();
  LocationResult _pickedLocation;
  var apiKey = 'AIzaSyCajUyewBDJdocFXJeXIHIdbmUrB3j5BqY';
  final _title = TextEditingController();
  final _urlrtsp = TextEditingController();
  final _namecity = TextEditingController();
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  String _lat;
  String _long;
  String _timestart;
  String _timestop;

  Future<void> _save() async {
    if (_formAdd.currentState.validate()) {
      _lat = _pickedLocation.latLng.latitude.toString();
      _long = _pickedLocation.latLng.longitude.toString();
      final http.Response response = await http.post(
        Uri.parse(hostname + '/addcamera'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': widget.id,
          'title': _title.text,
          'url': _urlrtsp.text,
          'l_name': _namecity.text,
          'l_lat': _lat,
          'l_long': _long,
          't_s': '1',
          't_start': _timestart,
          't_stop': _timestop
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    }
  }

  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _marker = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color(0xFFF1771A),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Form(
          key: _formAdd,
          child: Container(
            padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ชื่อ"),
                      TextFormField(
                        controller: _title,
                        validator: (value) =>
                            value.isEmpty ? 'กรุณากรอกข้อมูลให้ครบถ้วน' : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Url: RTSP"),
                          IconButton(
                              icon: Icon(Icons.help_outline), onPressed: () {})
                        ],
                      ),
                      TextFormField(
                        controller: _urlrtsp,
                        validator: (value) =>
                            value.isEmpty ? 'กรุณากรอกข้อมูลให้ครบถ้วน' : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'user:password@domian',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(
                    children: [
                      Text(
                        "ช่วงเวลาที่ แสดง",
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        child: CheckboxListTile(
                          title: Text("ตลอดเวลา"),
                          value: _isChecked1,
                          onChanged: (val) {
                            setState(() {
                              if (_isChecked2 == true) {
                                _isChecked2 = false;
                                _isChecked1 = val;
                              } else {
                                _isChecked1 = val;
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        child: CheckboxListTile(
                          title: Text("บางช่วงเวลา"),
                          value: _isChecked2,
                          onChanged: (val) {
                            setState(() {
                              if (_isChecked1 == true) {
                                _isChecked1 = false;
                                _isChecked2 = val;
                              } else {
                                _isChecked2 = val;
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                              ),
                              child: DateTimePicker(
                                type: DateTimePickerType.time,
                                initialValue: '',
                                dateLabelText: 'Date',
                                onChanged: (val) => _timestart = val,
                                validator: (value) =>
                                    value.isEmpty && _isChecked2 == true
                                        ? 'กรุณากรอกข้อมูลให้ครบถ้วน'
                                        : null,
                                onSaved: (val) => print(val),
                              ),
                            ),
                            Text("-"),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                              ),
                              child: DateTimePicker(
                                type: DateTimePickerType.time,
                                initialValue: '',
                                dateLabelText: 'Date',
                                onChanged: (val) => _timestop = val,
                                validator: (value) =>
                                    value.isEmpty && _isChecked2 == true
                                        ? 'กรุณากรอกข้อมูลให้ครบถ้วน'
                                        : null,
                                onSaved: (val) => print(val),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 500,
                  height: 200,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(13.736717, 100.523186), zoom: 15),
                    onMapCreated: _onMapCreated,
                    markers: Set.from(_marker),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: RaisedButton(
                    onPressed: () async {
                      LocationResult result =
                          await showLocationPicker(context, apiKey,
                              automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                              myLocationButtonEnabled: true,
                              // requiredGPS: true,
                              //layersButtonEnabled: true,
                              countries: ['TH'],
                              resultCardAlignment: Alignment.bottomCenter,
                              language: 'TH');
                      _pickedLocation = result;
                      _marker.add(
                        Marker(
                          markerId: MarkerId("1"),
                          position: _pickedLocation.latLng,
                        ),
                      );
                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(
                          CameraUpdate.newLatLng(_pickedLocation.latLng));
                      setState(() {});
                    },
                    child: Text('Pick location'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    'Location',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    _pickedLocation != null
                        ? 'Lat: ' + _pickedLocation.latLng.latitude.toString()
                        : "",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    _pickedLocation != null
                        ? 'Long: ' + _pickedLocation.latLng.longitude.toString()
                        : "",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: TextFormField(
                    controller: _namecity,
                    validator: (value) =>
                        value.isEmpty ? 'กรุณากรอกข้อมูลให้ครบถ้วน' : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'จังหวัด',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: RaisedButton(
                    color: Color(0xFFF1771A),
                    onPressed: () {
                      _save();
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
