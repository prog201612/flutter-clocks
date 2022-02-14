import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class AnalogicClock extends StatefulWidget {
  final int radius;
  final Color hourDrillColor;
  final Color minuteDrillColor;
  final Color secondDrillColor;
  final Color hourTextColor;
  final Color backgroundColor;
  final Color minuteMarkColor;

  const AnalogicClock({
    Key? key,
    this.radius = 75,
    this.hourDrillColor = Colors.deepPurple,
    this.minuteDrillColor = Colors.green,
    this.secondDrillColor = Colors.orange,
    this.hourTextColor = Colors.black,
    this.backgroundColor = Colors.transparent,
    this.minuteMarkColor = Colors.grey,
  }) : super(key: key);

  @override
  State<AnalogicClock> createState() => _AnalogicClockState();
}

class _AnalogicClockState extends State<AnalogicClock> {
  late Timer _timer;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  handleTimeout(Timer timer) {
    final now = DateTime.now();
    hours = now.hour > 12 ? now.hour - 12 : now.hour;
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
    return ClipOval(
      child: Container(
        color: widget.backgroundColor,
        width: widget.radius * 2,
        child: CustomPaint(
          size: Size(widget.radius * 2, widget.radius * 2),
          painter: _FacePainter(
            widget.radius,
            widget.hourTextColor,
            widget.minuteMarkColor,
          ),
          foregroundPainter: _ClockPainter(
            hours,
            minutes,
            seconds,
            widget.radius,
            widget.hourDrillColor,
            widget.minuteDrillColor,
            widget.secondDrillColor,
          ),
        ),
      ),
    );
  }
}

// _ F a c e   P a i n t e r

class _FacePainter extends CustomPainter {
  final int radius;
  final Color hourTextColor;
  final Color minuteMarkColor;

  _FacePainter(this.radius, this.hourTextColor, this.minuteMarkColor);

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.drawColor(Colors.black, BlendMode.src);
    // p e n
    final pen = Paint();
    pen.color = minuteMarkColor;
    //pen.style = PaintingStyle.values.single; // .stroke per dibuixar línies
    pen.strokeWidth = 1.0; // gruixudària del llapis

    // 360 / 60 = 6 || -90, 0 starts at 12 position
    for (var i = 1; i <= 60; i++) {
      // M i n u t e   l i n e s

      pen.strokeWidth = i % 5 == 0 ? 3.0 : 1.0;
      final radians = (i * 6 - 90) * pi / 180;
      final offsetRadius = radius - 10;
      canvas.drawLine(
        Offset(
          // + radius to center
          offsetRadius * cos(radians) + radius,
          offsetRadius * sin(radians) + radius,
        ),
        Offset(
          // + radius to center
          radius * cos(radians) + radius,
          radius * sin(radians) + radius,
        ),
        pen,
      );

      // H o u r   n u m b e r s
      if (i % 5 == 0) {
        final textRadius = radius - 20;
        TextSpan span = TextSpan(
          style: TextStyle(
            color: hourTextColor,
            fontWeight: i % 3 == 0 ? FontWeight.bold : FontWeight.normal,
          ),
          text: '${i / 5}',
        );
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr);
        tp.layout();
        // moure les dotze una mica més a l'esquerra
        final xOffset = i == 60 ? 8 : 4;
        tp.paint(
          canvas,
          Offset(
            // + radius to center
            textRadius * cos(radians) - xOffset + radius,
            textRadius * sin(radians) - 7 + radius,
          ),
        );
      }

      // Circle
      final penCircle = Paint();
      penCircle.color = minuteMarkColor.withOpacity(0.2);
      penCircle.style = PaintingStyle.stroke;
      canvas.drawCircle(
        Offset(radius.toDouble(), radius.toDouble()),
        radius.toDouble(),
        penCircle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// _ C l o c k   P a i n t e r

class _ClockPainter extends CustomPainter {
  final int radius;
  final int hours;
  final int minutes;
  final int seconds;
  final Color hourDrillColor;
  final Color minuteDrillColor;
  final Color secondDrillColor;

  _ClockPainter(
    this.hours,
    this.minutes,
    this.seconds,
    this.radius,
    this.hourDrillColor,
    this.minuteDrillColor,
    this.secondDrillColor,
  );

  _drillDrawer(Canvas canvas, Color color, double width, int radius, int grades,
      int circleSlices) {
    // instanciem un llapis
    final pen = Paint();
    pen.color = color;
    pen.style = PaintingStyle.fill; // .stroke per dibuixar línies
    pen.strokeWidth = width; // gruixudària del llapis

    // 360 / 60 = 6 || -90, 0 starts at 12 position
    final radians = (grades * 360 / circleSlices - 90) * pi / 180;
    final circlePointOfset = Offset(
      // + radius to center
      radius * cos(radians) + this.radius,
      radius * sin(radians) + this.radius,
    );
    canvas.drawLine(
      // + radius to center
      Offset(this.radius.toDouble(), this.radius.toDouble()),
      circlePointOfset,
      pen,
    );
    canvas.drawCircle(circlePointOfset, pen.strokeWidth / 2, pen);

    // C i r c l e   c e n t e r
    canvas.drawCircle(Offset(this.radius.toDouble(), this.radius.toDouble()),
        max(width, 4), pen);

    // S h a d o w
    final shadowWidth = max(width, 3.0);
    final path = Path()
      ..moveTo(this.radius.toDouble(), this.radius.toDouble())
      ..lineTo(
        radius * cos(radians) + this.radius,
        radius * sin(radians) + this.radius,
      )
      ..lineTo(
        radius * cos(radians) + this.radius + shadowWidth,
        radius * sin(radians) + this.radius + shadowWidth,
      )
      ..lineTo(
        this.radius.toDouble() + shadowWidth,
        this.radius.toDouble() + shadowWidth,
      );
    canvas.drawShadow(path, Colors.black, 3.0, false);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // H o u r s
    // 360 / 12 = 6 || -90, 0 starts at 12 position
    _drillDrawer(canvas, hourDrillColor, 10.0, radius - 38, hours, 12);

    // M i n u t e s
    // 360 / 60 = 6 || -90, 0 starts at 12 position
    _drillDrawer(canvas, minuteDrillColor, 7.0, radius - 15, minutes, 60);

    // S e c o n d s
    // 360 / 60 = 6 || -90, 0 starts at 12 position
    _drillDrawer(canvas, secondDrillColor, 1.0, radius, seconds, 60);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
