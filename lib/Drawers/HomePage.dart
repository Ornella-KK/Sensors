import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Drawers/Drawers.dart';
import 'package:navigation/Menus/contacts.dart';
import 'package:navigation/Menus/home.dart';
import 'package:navigation/Menus/maps/home_location.dart';
import 'package:navigation/theme.dart';
import 'package:provider/provider.dart';
import '../Auths/Login/login.dart';
import '../Menus/Quiz/Screen/quiz_list.dart';
import '../Menus/calculator.dart';
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
      container = HomeMap();
    }/*else if (currentPage == DrawerSections.scores) {
      container = AdminScoresScreen();
    } */
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
          Divider(),
          menuItem(
            6,
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
          if (id == 6) {
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
                appBarTitle = "Home Location";
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
