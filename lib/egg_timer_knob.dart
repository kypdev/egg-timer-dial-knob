import 'package:flutter/material.dart';
import 'dart:math' as math;

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerKnob extends StatefulWidget {
  final rotationPercent;

  EggTimerKnob({
    this.rotationPercent,
  });

  @override
  _EggTimerKnobState createState() => _EggTimerKnobState();
}

class _EggTimerKnobState extends State<EggTimerKnob> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          padding: const EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
            ),
            boxShadow: [
              new BoxShadow(
                color: const Color(0x44000000),
                blurRadius: 2.0,
                spreadRadius: 1.0,
                offset: const Offset(0.0, 1.0),
              ),
            ],
          ),
          child: new Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: const Color(0xFFDFDFDF),
                width: 1.5,
              ),
            ),
            child: new Center(
              child: Transform(
                transform: new Matrix4.rotationZ( 2 *math.pi * widget.rotationPercent),
                alignment: Alignment.center,
                child: new Image.asset(
                  'assets/images/bird.png',
                  color: Colors.black,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
        ),
        new Container(
          width: double.infinity,
          height: double.infinity,
          child: new CustomPaint(
            painter: new ArrowPainter(
              rotationPercent: widget.rotationPercent,
            ),
          ),
        ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;
  final double rotationPercent;

  ArrowPainter({
    this.rotationPercent,
  }) : dialArrowPaint = new Paint() {
    dialArrowPaint.color = Colors.black;
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    canvas.save();

    final radius = size.height / 2;
    canvas.translate(radius, radius);
    canvas.rotate(2 * math.pi * rotationPercent);

    Path path = new Path();
    path.moveTo(0.0, -radius - 10.0);
    path.lineTo(10.0, -radius + 5.0);
    path.lineTo(-10.0, -radius + 5.0);
    path.close();

    canvas.drawPath(path, dialArrowPaint);

    canvas.drawShadow(path, Colors.black, 3.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
