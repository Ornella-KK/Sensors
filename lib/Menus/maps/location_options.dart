import 'package:flutter/material.dart';
import 'home_location.dart';
import 'maps_location.dart';
import 'current_position.dart';

class LocationPage extends StatelessWidget {
  late String lat;
  late String long;
  final LocationService locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationPosition()),
                );
                /* locationService.getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';
                  locationService.openMap(lat, long);
                }); */
              },
              child: Text('Current Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to home location page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeMap()),
                );
              },
              child: Text('Home Location'),
            ),
          ],
        ),
      ),
    );
  }
}
