import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({Key? key}) : super(key: key);

  @override
  _HomeMapScreenState createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Marker _homeMarker = Marker(
    markerId: MarkerId("home"),
    position: LatLng(-1.975115, 30.049011),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );

  static const CameraPosition initialPosition =
      CameraPosition(target: LatLng(-1.955630, 30.104156), zoom: 14.0);

  static const CameraPosition targetPosition = CameraPosition(
    target: LatLng(-1.975115, 30.049011),
    zoom: 14.0,
    bearing: 192.0,
    tilt: 60,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        mapType: MapType.normal,
        markers: Set.of([_homeMarker]),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          goHome();
        },
        label: const Text("Home"),
        icon: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> goHome() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));
    setState(() {
      _homeMarker = _homeMarker.copyWith(
        positionParam: targetPosition.target,
      );
    });
  }
}
