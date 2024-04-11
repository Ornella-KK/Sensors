import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class StepCounter extends StatefulWidget {
  @override
  _StepCounterAppState createState() => _StepCounterAppState();
}

class _StepCounterAppState extends State<StepCounter> {
  int _stepCount = 0;
  late StreamSubscription<AccelerometerEvent> _streamSubscription;
  List<double> _accelerometerValues = <double>[];

  @override
  void initState() {
    super.initState();
    _streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      // Store the accelerometer values
      _accelerometerValues.add(event.x + event.y + event.z);

      // Keep only the last 100 accelerometer values
      if (_accelerometerValues.length > 100) {
        _accelerometerValues.removeAt(0);
      }

      // Detect a peak in the accelerometer data
      if (_isPeak()) {
        setState(() {
          _stepCount++;
        });
      }
    });
  }

  bool _isPeak() {
    if (_accelerometerValues.length < 100) {
      return false;
    }

    // Compute the average of the last 100 accelerometer values
    double average = _accelerometerValues.reduce((a, b) => a + b) / _accelerometerValues.length;

    // Detect a peak if the last value is greater than the average
    return _accelerometerValues.last > average;
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Step Count:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_stepCount',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
