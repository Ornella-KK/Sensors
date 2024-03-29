import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Drawers/Drawers.dart';
import 'package:navigation/Menus/Quiz/Screen/quiz_screen.dart';
import 'package:navigation/Menus/contacts.dart';
import 'package:navigation/Menus/home.dart';
import 'package:navigation/theme.dart';
import 'package:provider/provider.dart';
import '../Auths/Login/googleIn.dart';
import '../Auths/Login/login.dart';
import '../Auths/SignUp/signup.dart';
import '../Menus/Admin/add_quiz.dart';
import '../Menus/Admin/admin_screen.dart';
import '../Menus/Admin/edit_quiz.dart';
import '../Menus/Admin/view_scores.dart';
import '../Menus/Quiz/Screen/quiz_list.dart';
import '../Menus/calculator.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _MyAdminHomePageState createState() => _MyAdminHomePageState();
}

class _MyAdminHomePageState extends State<AdminHomePage> {
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
    } else if (currentPage == DrawerSections.createQuiz) {
      container = QuizAdminScreen();
    } else if (currentPage == DrawerSections.scores) {
      container = AdminScoresScreen();
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
          menuItem(2, "CreateQuiz", Icons.create,
              currentPage == DrawerSections.createQuiz ? true : false),
          menuItem(3, "Scores", Icons.score,
              currentPage == DrawerSections.scores ? true : false),
          Divider(),
          menuItem(
            4,
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
          if (id == 4) {
            FirebaseAuth.instance.signOut().then((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            }).catchError((error) {
              print('Failed to sign out: $error');
            });
          } else {
            setState(() {
              if (id == 1) {
                currentPage = DrawerSections.home;
                appBarTitle = "Home";
              } else if (id == 2) {
                currentPage = DrawerSections.createQuiz;
                appBarTitle = " Create Quiz";
              } else if (id == 3) {
                currentPage = DrawerSections.scores;
                appBarTitle = " Scores";
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
