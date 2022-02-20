import 'package:clock_app/screens/analogic_clock.dart';
import 'package:clock_app/screens/circular_drill_clock.dart';
import 'package:clock_app/screens/digital_sugar_clock.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AnalogicClock(),
              SizedBox(width: 50),
              AnalogicClock(
                radius: 100,
                hourDrillColor: Colors.pink,
                minuteDrillColor: Colors.purple,
                secondDrillColor: Colors.yellow,
                hourTextColor: Colors.white,
                backgroundColor: Colors.black,
                minuteMarkColor: Colors.grey,
              ),
              SizedBox(width: 50),
              DigitalSugarClock(),
              SizedBox(width: 50),
              DigitalSugarClock(
                backgroundColor: Colors.black,
                foregroundColor: Colors.orange,
                borderRadius: 100,
                width: 100,
                borderWidth: 3,
                borderColor: Colors.orange,
                blinkSeconds: true,
              ),
              SizedBox(width: 50),
              CircularDrillClock(),
            ],
          ),
        ),
      ),
    );
  }
}
