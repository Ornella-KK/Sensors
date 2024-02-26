import 'package:flutter/material.dart';
import 'package:navigation/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _MyContactPage();
}

class _MyContactPage extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: themeProvider.getTheme.scaffoldBackgroundColor,
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getContacts(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error loading contacts'),
                );
              }
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Contact contact = snapshot.data[index];
                    return Card(
                      color:
                          themeProvider.getTheme.brightness == Brightness.dark
                              ? Colors.grey[900]
                              : null,
                      child: ListTile(
                        title: Text(
                          contact.displayName ?? '',
                          style: TextStyle(
                            color: themeProvider.getTheme.brightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          contact.phones.isNotEmpty
                              ? contact.phones[0].number
                              : '',
                          style: TextStyle(
                            color: themeProvider.getTheme.brightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No contacts found'),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      return await FastContacts.getAllContacts();
    }
    return [];
  }
}
