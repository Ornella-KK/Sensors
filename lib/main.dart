import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigation/Network/dependency_injection.dart';
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
