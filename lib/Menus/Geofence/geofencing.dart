import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocationPosition extends StatefulWidget {
  @override
  _LocationPositionState createState() => _LocationPositionState();
}

class _LocationPositionState extends State<LocationPosition> {
  late GoogleMapController mapController;
  late LatLng currentLocation = LatLng(0.0, 0.0);
  final LatLng targetLocation = LatLng(-1.975115, 30.049011);
  final double radius = 100.0; // Radius in meters
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isInTargetArea = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _initNotifications();
  }

  Future<void> _checkPermissions() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      _getCurrentLocation();
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is required to use this app')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      LatLng newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        currentLocation = newLocation;
      });
      _checkProximity(newLocation);
    });
  }

  void _initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Ensure 'app_icon' exists in drawable
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _checkProximity(LatLng location) {
    double distance = Geolocator.distanceBetween(
      location.latitude,
      location.longitude,
      targetLocation.latitude,
      targetLocation.longitude,
    );

    if (distance <= radius && !isInTargetArea) {
      isInTargetArea = true;
      _showNotification('Entered the target area', 'You have entered the specified location.');
    } else if (distance > radius && isInTargetArea) {
      isInTargetArea = false;
      _showNotification('Left the target area', 'You have left the specified location.');
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: 'app_icon', // Ensure 'app_icon' exists in drawable
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _simulateProximityCheck() {
    // Simulate being within the target location
    LatLng simulatedLocation = LatLng(targetLocation.latitude + 0.0001, targetLocation.longitude + 0.0001);
    setState(() {
      currentLocation = simulatedLocation;
    });
    _checkProximity(simulatedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentLocation.latitude == 0.0 && currentLocation.longitude == 0.0
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
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
                      Marker(
                        markerId: MarkerId('targetLocation'),
                        position: targetLocation,
                        infoWindow: InfoWindow(title: 'Target Location'),
                      ),
                    ],
                  ),
                ),
          Positioned(
            bottom: 50,
            left: 20,
            child: FloatingActionButton(
              onPressed: _simulateProximityCheck,
              child: Icon(Icons.location_searching),
            ),
          ),
        ],
      ),
    );
  }
}
