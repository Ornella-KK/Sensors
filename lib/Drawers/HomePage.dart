import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Drawers/Drawers.dart';
import 'package:navigation/Menus/contacts.dart';
import 'package:navigation/Menus/home.dart';
import 'package:navigation/theme.dart';
import 'package:provider/provider.dart';
import '../Auths/Login/googleIn.dart';
import '../Auths/SignUp/signup.dart';
import '../Menus/calculator.dart';

class HomePage extends StatefulWidget {

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
      container = WelcomePage();
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
            /* LoginAPI.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUp())); */
            FirebaseAuth.instance.signOut();
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
