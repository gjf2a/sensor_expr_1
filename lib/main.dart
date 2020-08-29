import 'package:flutter/material.dart';
import 'package:sensor_expr_1/vectors.dart';
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
  Averager acclAvg = Averager();
  Averager userAvg = Averager();
  Averager gyroAvg = Averager();
  bool _accumulating = false;

  @override
  initState() {
    accelerometerEvents.listen((event) {
      _update(acclAvg, event);
    });

    userAccelerometerEvents.listen((event) {
      _update(userAvg, event);
    });

    gyroscopeEvents.listen((event) {
      _update(gyroAvg, event);
    });
  }

  void _update(Averager avg, event) {
    setState(() {
      Value3D v = Value3D(event.x, event.y, event.z);
      if (_accumulating) {
        avg.accumulate(v);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('''Current readings:
    accl: (${acclAvg.last.uiString()})
    user: (${userAvg.last.uiString()})
    gyro: (${gyroAvg.last.uiString()})'''),
      RaisedButton(child: Text("Record"), onPressed: () {
        _accumulating = true;
        acclAvg.reset();
        userAvg.reset();
        gyroAvg.reset();
        },),
      RaisedButton(child: Text("Stop"), onPressed: () {setState(() {
        _accumulating = false;
      });},),
      Text('''Averages:
    accl: (${acclAvg.average.uiString()})
    user: (${userAvg.average.uiString()})
    gyro: (${gyroAvg.average.uiString()})''', overflow: TextOverflow.visible)]);
  }
}

class SensorInfo extends StatefulWidget {
  @override
  SensorState createState() => SensorState();
}
