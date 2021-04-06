import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:viewgoal/config.dart';

class ManagerProfile extends StatefulWidget {
  ManagerProfile({Key key, this.user_id, this.myme}) : super(key: key);
  var user_id;
  var myme;

  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<ManagerProfile> {
  bool showPassword = false;

  final textName = TextEditingController();
  final textNote = TextEditingController();

  Io.File _image;
  final picker = ImagePicker();

  String img64;

  @override
  void initState() {
    super.initState();
    print(widget.myme);
    textName.text = widget.myme["name"];
    textNote.text = widget.myme["note"];
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);

    String path = pickedFile.path;

    setState(() {
      if (pickedFile != null) {
        _cropImage(path);
      } else {
        print('No image selected.');
      }
    });

    // to base 64
    final bytes = Io.File(path).readAsBytesSync();
    img64 = base64Encode(bytes);
    print(img64);
  }

  _getCam() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    final path = pickedFile.path;

    setState(() {
      _cropImage(path);
    });

    // to base 64
    final bytes = Io.File(path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    print(img64);
  }

  _cropImage(filePath) async {
    Io.File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,
        cropStyle: CropStyle.circle);
    if (croppedImage != null) {
      _image = croppedImage;
      setState(() {});
    }
  }

  Future<void> setProfile() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(hostname + '/editprofile'));
    request.body =
        '''{\r\n    "user_id":"${widget.user_id}",\r\n    "name":"${textName.text}",\r\n    "note":"${textNote.text}"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      if (img64 == null) {
        Navigator.pop(context);
      } else {
        upload(_image);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  upload(File imageFile) async {
    // open a bytestream
    var stream = new http.ByteStream(imageFile.openRead());
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(hostname + "/editprofile-upimg");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('myFile', stream, length,
        filename: imageFile.path);

    // add file to multipart
    request.files.add(multipartFile);
    request.fields['user_id'] = widget.user_id.toString();

    // send
    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.amber[800],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: _image == null
                            ? NetworkImage(hostname +
                                '/images-profile/${widget.user_id}.png')
                            : FileImage(
                                Io.File(_image.path),
                              ),
                      ),
                    ),
                    // CircleAvatar(
                    //   radius: 80.0,
                    //   backgroundImage: _image == null
                    //       ? Text("0")
                    //       : FileImage(
                    //           File(_image.path),
                    //         ),
                    // ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            _showDialog();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.amber[800]),
                            child: Icon(Icons.edit, color: Colors.white),
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                child: Column(
                  children: [
                    TextField(
                      controller: textName,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Full Name",
                        labelStyle: TextStyle(fontSize: 20),
                        hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    TextField(
                      controller: textNote,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Note",
                        labelStyle: TextStyle(fontSize: 20),
                        hintStyle: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 50),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('CANCEL',
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  // RaisedButton(
                  //   onPressed: () {
                  //     setProfile();
                  //   },
                  //   color: Colors.amber[800],
                  //   padding: EdgeInsets.symmetric(horizontal: 50),
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20)),
                  //   child: Text(
                  //     'SAVE',
                  //     style: TextStyle(
                  //         fontSize: 14,
                  //         letterSpacing: 2.2,
                  //         color: Colors.white),
                  //   ),
                  // )
                  ElevatedButton(
                    onPressed: () {
                      setProfile();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.amber[800]),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 50),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Form Builder Widget
  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, int maxLength) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: textName,
        maxLength: maxLength,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 3),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 20),
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Set profile photo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: ButtonTheme(
                    child: TextButton(
                      onPressed: () {
                        _getCam();
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Take photo',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: ButtonTheme(
                    child: TextButton(
                      onPressed: () {
                        getImage();
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Choose photo',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
