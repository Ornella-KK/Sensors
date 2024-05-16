import 'package:flutter/material.dart';
import 'package:navigation/Drawers/Drawers.dart';
import 'package:navigation/Menus/home.dart';
import 'package:navigation/theme.dart';
import 'package:provider/provider.dart';
import '../Menus/Geofence/geofencing.dart';
import '../Menus/Light/light_sensor.dart';
import '../Menus/Steps/step_counter.dart';

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
    } else if (currentPage == DrawerSections.homeMap) {
      container = LocationPosition();
    } else if (currentPage == DrawerSections.light) {
      container = LightSensorPage();
    } else if (currentPage == DrawerSections.steps) {
      container = StepCounterApp();
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
          menuItem(2, "Geo Tracking", Icons.location_pin,
              currentPage == DrawerSections.homeMap ? true : false),
          menuItem(3, "Light Sensor", Icons.lightbulb,
              currentPage == DrawerSections.light ? true : false),
          menuItem(4, "Motion Detector", Icons.directions_walk,
              currentPage == DrawerSections.steps ? true : false),
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
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.home;
              appBarTitle = "Home";
            } else if (id == 2) {
              currentPage = DrawerSections.homeMap;
              appBarTitle = "Location";
            } else if (id == 3) {
              currentPage = DrawerSections.light;
              appBarTitle = "Light Sensor";
            } else if (id == 4) {
              currentPage = DrawerSections.steps;
              appBarTitle = "Step Counter";
            }
          });
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
