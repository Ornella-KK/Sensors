import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Drawers/Drawers.dart';
import 'package:navigation/Menus/contacts.dart';
import 'package:navigation/Menus/home.dart';
import 'package:navigation/Menus/maps/home_location.dart';
import 'package:navigation/theme.dart';
import 'package:provider/provider.dart';
import '../Auths/Login/login.dart';
import '../Menus/Compass/compass.dart';
import '../Menus/Light/light_sensor.dart';
import '../Menus/Quiz/Screen/quiz_list.dart';
import '../Menus/Steps/step_counter.dart';
import '../Menus/Steps/steps_count.dart';
import '../Menus/calculator.dart';
import '../Menus/maps/location_options.dart';
import '../session.dart';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  var currentPage = DrawerSections.home;
  String appBarTitle = "Home";

  @override
  void initState() {
    super.initState();
    currentPage = DrawerSections.home;
    appBarTitle = "Home";
  }

  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var container;
    if (currentPage == DrawerSections.home) {
      container = WelcomePage();
    } else if (currentPage == DrawerSections.calculator) {
      container = Calculator();
    } else if (currentPage == DrawerSections.contacts) {
      container = ContactPage();
    } else if (currentPage == DrawerSections.quiz) {
      container = QuizListPage();
    }  else if (currentPage == DrawerSections.homeMap) {
      container = LocationPage();
    } else if (currentPage == DrawerSections.light) {
      container = LightSensorPage();
    } else if (currentPage == DrawerSections.steps) {
      container = StepCounterApp();
    } else if (currentPage == DrawerSections.compass) {
      container = CompassWidget();
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
          menuItem(4, "Quiz", Icons.quiz,
              currentPage == DrawerSections.quiz ? true : false),
          menuItem(5, "Maps", Icons.location_pin,
              currentPage == DrawerSections.homeMap ? true : false),
          menuItem(6, "Light Sensor", Icons.lightbulb,
              currentPage == DrawerSections.light ? true : false),
          menuItem(7, "Step Counter", Icons.directions_walk,
              currentPage == DrawerSections.steps ? true : false),
          menuItem(8, "Compass", Icons.compass_calibration,
              currentPage == DrawerSections.compass ? true : false),
          Divider(),
          menuItem(
            9,
            "Logout",
            Icons.logout,
            false,
          ),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          if (id == 9) {
            FirebaseAuth.instance.signOut().then((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
              SessionManager.endSession();
            }).catchError((error) {
              print('Failed to sign out: $error');
            });
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
              } else if (id == 4) {
                currentPage = DrawerSections.quiz;
                appBarTitle = "Quiz";
              }else if (id == 5) {
                currentPage = DrawerSections.homeMap;
                appBarTitle = "Location";
              }
              else if (id == 6) {
                currentPage = DrawerSections.light;
                appBarTitle = "Light Sensor";
              }
              else if (id == 7) {
                currentPage = DrawerSections.steps;
                appBarTitle = "Step Counter";
              }
              else if (id == 8) {
                currentPage = DrawerSections.compass;
                appBarTitle = "Compass";
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
