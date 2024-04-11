import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPosition extends StatefulWidget {
  @override
  _LocationPositionState createState() => _LocationPositionState();
}

class _LocationPositionState extends State<LocationPosition> {
  late GoogleMapController mapController;
  late LatLng currentLocation = LatLng(0.0, 0.0);

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LatLng>(
        future: getCurrentLocation()
            .then((value) => LatLng(value.latitude, value.longitude)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            LatLng currentLocation = snapshot.data!;
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: Set<Marker>.of(
                <Marker>[
                  Marker(
                    markerId: MarkerId('currentLocation'),
                    position: currentLocation,
                    infoWindow: InfoWindow(title: 'Current Location'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
