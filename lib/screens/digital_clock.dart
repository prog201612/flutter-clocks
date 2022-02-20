import 'dart:async';

import 'package:flutter/material.dart';

class DigitalClock extends StatefulWidget {
  final bool showSeconds;
  const DigitalClock({Key? key, this.showSeconds = true}) : super(key: key);

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late Timer _timer;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  handleTimeout(Timer timer) {
    final now = DateTime.now();
    print(now);
    hours = now.hour;
    minutes = now.minute;
    seconds = now.second;
    setState(() {});
  }

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), handleTimeout);
    super.initState();
  }

  @override
  void deactivate() {
    if (_timer.isActive) _timer.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.showSeconds
          ? Text('$hours.$minutes.$seconds')
          : Text('$hours.$minutes'),
    );
  }
}
