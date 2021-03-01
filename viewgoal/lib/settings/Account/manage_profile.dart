import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ManagerProfile extends StatefulWidget {
  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<ManagerProfile> {
  bool showPassword = false;

  Io.File _image;
  final picker = ImagePicker();

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
    String img64 = base64Encode(bytes);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
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
                            ? AssetImage("assets/images/default-prof.png")
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
              buildTextField("Full Name", "Full Name", false, 15),
              buildTextField("Email", "Email", false, 30),
              buildTextField("Password", "Password", true, 15),
              buildTextField("Location", "Location", false, 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {},
                    child: Text('CANCEL',
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                      onPressed: () {},
                      color: Colors.amber[800],
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ))
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
        maxLength: maxLength,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
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
                    child: FlatButton(
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
                    child: FlatButton(
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
