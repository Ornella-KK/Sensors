import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigation/Auths/googleIn.dart';
import 'package:navigation/Auths/login.dart';
import 'package:navigation/Auths/logout.dart';
import 'package:navigation/Auths/welcome.dart';
import 'package:navigation/about.dart';
import 'package:navigation/calculator.dart';
import 'package:navigation/contacts.dart';
import 'package:navigation/controller/dependency_injection.dart';
import 'package:navigation/home.dart';
import 'package:navigation/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auths/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  DependencyInjection.init();
  return runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (BuildContext context) => ThemeProvider(
      isDarkMode: prefs.getBool("isDarkTheme"),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GetMaterialApp(
          theme: themeProvider.getTheme,
          debugShowCheckedModeBanner: false,
          home: SignUp(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final String name;
  final String email;
  const HomePage({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  var currentPage = DrawerSections.home;
  String appBarTitle = "Home";

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var container;
    if (currentPage == DrawerSections.home) {
      container = WelcomePage(name: widget.name, email: widget.email);
    } else if (currentPage == DrawerSections.calculator) {
      container = Calculator();
    } else if (currentPage == DrawerSections.contacts) {
      container = ContactPage();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.getTheme.primaryColor,
        title: Text(appBarTitle),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        //shows the menu on drawer
        children: [
          menuItem(1, "Home", Icons.home_filled,
              currentPage == DrawerSections.home ? true : false),
          menuItem(2, "Calculator", Icons.calculate_rounded,
              currentPage == DrawerSections.calculator ? true : false),
          menuItem(3, "Contacts", Icons.contacts,
              currentPage == DrawerSections.contacts ? true : false),
          Divider(),
          menuItem(
            4,
            "Logout",
            Icons.logout,
            false,
          )
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Close the drawer
          if (id == 4) {
            LoginAPI.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUp()));
          } else {
            setState(() {
              if (id == 1) {
                currentPage = DrawerSections.home;
                appBarTitle = "Home";
              } else if (id == 2) {
                currentPage = DrawerSections.calculator;
                appBarTitle = "Calculator";
              } else if (id == 3) {
                currentPage = DrawerSections.contacts;
                appBarTitle = "Contacts";
              }
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
                SizedBox(height: 10),
                Text(
                  "Welcome",
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
