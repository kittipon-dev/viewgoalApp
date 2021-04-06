import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:viewgoal/config.dart';

class AddCameraPage extends StatefulWidget {
  AddCameraPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddCameraPage> {
  final _formAdd = GlobalKey<FormState>();

  /*
  LocationResult _pickedLocation;


  LatLng _initialcameraposition = LatLng(13.7650836, 100.537966);
  GoogleMapController _controller;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
  }

   */
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
                            value.isEmpty ? 'Input cannot be empty!' : null,
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
                            value.isEmpty ? 'Input cannot be empty!' : null,
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
                  child: ElevatedButton(
                    onPressed: () async {
                      /*
                      LocationResult result = await showLocationPicker(
                        context, "AIzaSyCWtedlwiDnC1gSiVs3RHCf6CVrnpxPl4Q",
                        initialCenter: LatLng(31.1975844, 29.9598339),
//                      automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                        myLocationButtonEnabled: true,
                        // requiredGPS: true,
                        layersButtonEnabled: true,
                        // countries: ['AE', 'NG']

//                      resultCardAlignment: Alignment.bottomCenter,
                        desiredAccuracy: LocationAccuracy.best,
                      );
                      print("result = $result");
                      setState(() => _pickedLocation = result);
                      */
                    },
                    child: Text('Pick location GPS'),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: _namecity,
                    validator: (value) =>
                        value.isEmpty ? 'Input cannot be empty!' : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'name city',
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'GPS   ',
                    style: TextStyle(fontSize: 15),
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
                              child: DateTimePicker(
                                type: DateTimePickerType.time,
                                initialValue: '',
                                dateLabelText: 'Date',
                                onChanged: (val) => _timestart = val,
                                validator: (value) =>
                                    value.isEmpty && _isChecked2 == true
                                        ? 'Input cannot be empty!'
                                        : null,
                                onSaved: (val) => print(val),
                              ),
                            ),
                            Text("-"),
                            Container(
                              width: 150,
                              child: DateTimePicker(
                                type: DateTimePickerType.time,
                                initialValue: '',
                                dateLabelText: 'Date',
                                onChanged: (val) => _timestop = val,
                                validator: (value) =>
                                    value.isEmpty && _isChecked2 == true
                                        ? 'Input cannot be empty!'
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
                  child: ElevatedButton(
                    child: Text('Add',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber[800])),
                    onPressed: () {
                      _save();
                    },
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
