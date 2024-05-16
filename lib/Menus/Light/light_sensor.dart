import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LightSensorPage extends StatefulWidget {
  @override
  _LightSensorAppState createState() => _LightSensorAppState();
}

class _LightSensorAppState extends State<LightSensorPage> {
  late Stream<int> _luxStream;
  late bool _hasSensor;
  bool _isNearLight = false;
  late StreamSubscription<int> _luxSubscription;
  int _lastLuxValue = 0;
  List<_LightData> lightDataPoints = [];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _hasSensor = false;
    _initSensor();
    _initializeNotifications();
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
              _handleLightChange(luxValue);
              _lastLuxValue = luxValue;
            });
          });
        }
      });
    });
  }

  void _initializeNotifications() {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _handleLightChange(int luxValue) {
    if ((_lastLuxValue <= 100 && luxValue > 100) ||
        (_lastLuxValue > 100 && luxValue <= 100)) {
      // Light level changed significantly
      _showNotification(
          'Light Level Changed',
          luxValue > 100
              ? 'The Environment\'s Light is bright.'
              : 'The Environment\'s Light is low.');
      _adjustSmartLights(luxValue);
    }
    // Add new data point to the list and update the chart
    setState(() {
      lightDataPoints.add(_LightData(DateTime.now(), luxValue.toDouble()));
    });
  }

  void _showNotification(String title, String body) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  void _adjustSmartLights(int luxValue) {
    // Simulate adjusting smart lights by displaying a message
    if (luxValue > 100) {
      print('Turning off the smart lights.');
    } else {
      print('Turning on the smart lights.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: _hasSensor
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Light Level: $_lastLuxValue lux\n${_isNearLight ? 'Light Detected!' : 'No Light Detected'}'),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: SfCartesianChart(
                        primaryXAxis: DateTimeAxis(),
                        primaryYAxis: NumericAxis(minimum: 0, maximum: 1000),
                        series: <LineSeries<_LightData, DateTime>>[
                          LineSeries<_LightData, DateTime>(
                            dataSource: lightDataPoints,
                            xValueMapper: (_LightData data, _) => data.time,
                            yValueMapper: (_LightData data, _) => data.value,
                            name: 'Light Level',
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : const Text("Your device doesn't have a light sensor"),
        ),
      ),
    );
  }
}

class _LightData {
  _LightData(this.time, this.value);
  final DateTime time;
  final double value;
}
