import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: SensorInfo(),
        ),
      ),
    );
  }
}

class SensorState extends State<SensorInfo> {
  double acclX, acclY, acclZ;
  double userX, userY, userZ;
  double gyroX, gyroY, gyroZ;

  @override
  initState() {
    accelerometerEvents.listen((event) {
      setState(() {
        acclX = event.x;
        acclY = event.y;
        acclZ = event.z;
      });
    });

    userAccelerometerEvents.listen((event) {
      setState(() {
        userX = event.x;
        userY = event.y;
        userZ = event.z;
      });
    });

    gyroscopeEvents.listen((event) {
      setState(() {
        gyroX = event.x;
        gyroY = event.y;
        gyroZ = event.z;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('''accl: ($acclX, $acclY, $acclZ)
    user: ($userX, $userY, $userZ)
    gyro: ($gyroX, $gyroY, $gyroZ)''', overflow: TextOverflow.visible);
  }
}

class SensorInfo extends StatefulWidget {
  @override
  SensorState createState() => SensorState();
}
