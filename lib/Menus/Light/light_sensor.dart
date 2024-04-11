import 'dart:async';

import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

class LightSensorPage extends StatefulWidget {
  @override
  State<LightSensorPage> createState() => _LightSensorAppState();
}

class _LightSensorAppState extends State<LightSensorPage> {
  late Stream<int> _luxStream;
  late bool _hasSensor;
  bool _isNearLight = false;
  late StreamSubscription<int> _luxSubscription;

  @override
  void initState() {
    super.initState();
    _hasSensor = false;
    _initSensor();
  }

  @override
  void dispose() {
    _luxSubscription.cancel(); // Cancel the stream subscription
    super.dispose();
  }

  void _initSensor() {
    LightSensor.hasSensor().then((hasSensor) {
      setState(() {
        _hasSensor = hasSensor;
        if (_hasSensor) {
          _luxStream = LightSensor.luxStream();
          _luxSubscription = _luxStream.listen((luxValue) {
            setState(() {
              _isNearLight = luxValue > 100; // Adjust the threshold as needed
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: _hasSensor
              ? _isNearLight
                  ? const Text('Light Detected!')
                  : const Text('No Light Detected')
              : const Text("Your device doesn't have a light sensor"),
        ),
      ),
    );
  }
}
