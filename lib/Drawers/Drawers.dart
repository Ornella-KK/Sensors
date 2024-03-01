import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';


class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  XFile? _image;
  String? _imagepath;

  @override
  void initState() {
    super.initState();
    LoadImage();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Container(
      color: themeProvider.getTheme.primaryColor,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.brightness_6),
              color: Colors.white,
              onPressed: () {
                ThemeProvider themeProvider = Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                );
                themeProvider.swapTheme();
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    pickImage(context);
                  },
                  child: _imagepath != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(_imagepath!)),
                          radius: 50,
                        )
                      : _image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(File(_image!.path)),
                              radius: 50,
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/images.png')
                                      as ImageProvider<Object>,
                              radius: 50,
                            ),
                ),
                SizedBox(height: 5),
                Text(
                  "Change Profile",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void pickImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedImage != null) {
                    setState(() {
                      _image = pickedImage;
                      SaveImage(_image!.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a picture'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedImage != null) {
                    setState(() {
                      _image = pickedImage;
                      SaveImage(_image!.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void SaveImage(path) async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    saveImage.setString("imagepath", path);
  }

  void LoadImage() async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = saveImage.getString("imagepath");
    });
  }
}

enum DrawerSections { home, calculator, contacts, logout }
