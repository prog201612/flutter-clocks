import 'dart:async';

import 'package:flutter/material.dart';

class DigitalSugarClock extends StatefulWidget {
  final bool showSeconds;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final double? width;
  final double borderWidth;
  final Color? borderColor;
  final bool blinkSeconds;

  const DigitalSugarClock({
    Key? key,
    this.showSeconds = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 0,
    this.width,
    this.borderWidth = 0,
    this.borderColor,
    this.blinkSeconds = false,
  }) : super(key: key);

  @override
  State<DigitalSugarClock> createState() => _DigitalSugarClockState();
}

class _DigitalSugarClockState extends State<DigitalSugarClock> {
  late Timer _timer;
  String hours = '00';
  String minutes = '00';
  String seconds = '00';
  late Color? secondsColor;

  handleTimeout(Timer timer) {
    final now = DateTime.now();
    hours = now.hour.toString().padLeft(2, '0'); // format '01'
    minutes = now.minute.toString().padLeft(2, '0');
    seconds = now.second.toString().padLeft(2, '0');
    if (widget.blinkSeconds) {
      secondsColor = secondsColor == widget.foregroundColor
          ? widget.foregroundColor?.withOpacity(0.5) ?? widget.foregroundColor
          : widget.foregroundColor;
    }
    setState(() {});
  }

  @override
  void initState() {
    secondsColor = widget.foregroundColor;
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
      width: widget.width,
      padding: EdgeInsets.all(widget.borderWidth),
      decoration: BoxDecoration(
        color: widget.borderColor, // Colors.black87,
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: widget.backgroundColor, // Colors.black87,
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // h o u r s

            Text(
              hours,
              style: TextStyle(
                color: widget.foregroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(' : ', style: TextStyle(color: secondsColor)),

            // m i n u t e s

            Text(
              hours,
              style: TextStyle(
                color: widget.foregroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (widget.showSeconds)
              Text(' : ', style: TextStyle(color: secondsColor)),

            // S e c o n d s
            if (widget.showSeconds)
              AnimatedDefaultTextStyle(
                duration: const Duration(microseconds: 300),
                style: TextStyle(color: secondsColor),
                child: Text(seconds),
              ),
          ],
        ),
      ),
    );
  }
}
