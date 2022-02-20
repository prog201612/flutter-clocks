import 'dart:math';

import 'package:flutter/material.dart';

class CircularDrillClock extends StatefulWidget {
  const CircularDrillClock({Key? key}) : super(key: key);

  @override
  _CircularDrillClockState createState() => _CircularDrillClockState();
}

class _CircularDrillClockState extends State<CircularDrillClock>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  final radius = 50.0;

  //late Timer _timer;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    // Controlador de l'animació
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Listener animació
    controller.addListener(() {
      final now = DateTime.now();
      hours = now.hour > 12 ? now.hour - 12 : now.hour;
      minutes = now.minute;
      seconds = now.second;
      setState(() {});
      controller.repeat();
    });

    super.initState();

    controller.reset();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          width: radius * 2,
          height: radius * 2,
          //color: Colors.grey.withOpacity(0.2),
          child: CustomPaint(
            painter: _BackgroundDrawer(radius),
            foregroundPainter: _DrillDrawer(radius, hours, minutes, seconds),
          ),
        );
      },
    );
  }
}

// B a c k g r o u n d   D r a w e r

class _BackgroundDrawer extends CustomPainter {
  final double radius;
  final double strokeWidth = 12;

  _BackgroundDrawer(this.radius);

  _drawBackgroundDrill(Canvas canvas, Color color, double drillRadius) {
    // Llapis de l'arc
    final paintArc = Paint()
      ..strokeWidth = strokeWidth
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke;

    // Arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: drillRadius),
      -pi / 2, // angle inicial
      pi * 2, // angle de relleno
      false,
      paintArc, // llapis
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = this.radius - strokeWidth / 2;
    _drawBackgroundDrill(canvas, Colors.orange, radius - strokeWidth * 2);
    _drawBackgroundDrill(canvas, Colors.green, radius - strokeWidth);
    _drawBackgroundDrill(canvas, Colors.purple, radius);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// D r i l l   D r a w e r

class _DrillDrawer extends CustomPainter {
  final double radius;
  final int hours;
  final int minutes;
  final int seconds;
  final double strokeWidth = 12;

  _DrillDrawer(this.radius, this.hours, this.minutes, this.seconds);

  _drawDrill(
    Canvas canvas,
    int value,
    double drillRadius,
    Color color,
    int circleDivisions,
  ) {
    // Llapis de l'arc
    final paintArc = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..style = PaintingStyle.stroke;

    // Arc
    // Dibuixem el percentatge desitjat de l'arc
    double arcAngle = pi * value * (360 / circleDivisions) / 180;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: drillRadius),
      -pi / 2, // angle inicial
      arcAngle, // angle de relleno
      false,
      paintArc, // llapis
    );

    // Begin Circle
    paintArc.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(
        drillRadius * cos(-90 * pi / 180) + radius,
        drillRadius * sin(-90 * pi / 180) + radius,
      ),
      strokeWidth * 0.5,
      paintArc,
    );
  }

  _drawValueCircle(
    Canvas canvas,
    int value,
    double drillRadius,
    Color color,
    int circleDivisions,
  ) {
    // Llapis de l'arc
    final paintArc = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..style = PaintingStyle.fill;

    final radians = (value * 360 / circleDivisions - 90) * pi / 180;

    // Circle color
    canvas.drawCircle(
      Offset(
        drillRadius * cos(radians) + radius,
        drillRadius * sin(radians) + radius,
      ),
      strokeWidth, // * 0.5,
      paintArc,
    );

    // Circle white
    paintArc.color = Colors.white;
    canvas.drawCircle(
      Offset(
        drillRadius * cos(radians) + radius,
        drillRadius * sin(radians) + radius,
      ),
      strokeWidth * 0.75, // * 0.5,
      paintArc,
    );

    // Text value
    TextSpan span = TextSpan(
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      text: '$value',
    );
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
      canvas,
      Offset(
        drillRadius * cos(radians) + radius - 3.25 * '$value'.length,
        drillRadius * sin(radians) + radius - 6,
      ),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = this.radius - strokeWidth / 2;

    // Draw drills
    _drawDrill(canvas, hours, radius - strokeWidth * 2, Colors.orange, 12);
    _drawDrill(canvas, minutes, radius - strokeWidth, Colors.green, 60);
    _drawDrill(canvas, seconds, radius, Colors.purple, 60);

    // Draw value circles
    _drawValueCircle(
        canvas, hours, radius - strokeWidth * 2, Colors.orange, 12);
    _drawValueCircle(canvas, minutes, radius - strokeWidth, Colors.green, 60);
    _drawValueCircle(canvas, seconds, radius, Colors.purple, 60);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
