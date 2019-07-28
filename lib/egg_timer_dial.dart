import 'package:flutter/material.dart';
import 'package:fluttery/gestures.dart';
import 'dart:math' as math;

import 'egg_timer_knob.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDial extends StatefulWidget {

  final Duration currentTime;
  final Duration maxTime;
  final int tickPerSection;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  EggTimerDial({
    this.currentTime = const Duration(minutes: 0),
    this.maxTime =  const Duration(minutes: 35),
    this.tickPerSection = 5,
    this.onTimeSelected,
    this.onDialStopTurning,
  });


  @override
  _EggTimerDialState createState() => _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial> {

  _rotationPercent () {
    return widget.currentTime.inSeconds / widget.maxTime.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return new DialTurnGestureDetector(
      currentTime: widget.currentTime,
      maxTime: widget.maxTime,
      onTimeSelected: widget.onTimeSelected,
      onDialStopTurning: widget.onDialStopTurning,
          child: new Container(
        width: double.infinity,
        child: new Padding(
          padding: const EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          child: new AspectRatio(
            aspectRatio: 1.0,
            child: new Container(
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
              child: new Stack(
                children: <Widget>[
                  new Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(55.0),
                    child: new CustomPaint(
                      painter: new TickPainter(
                        tickCount: widget.maxTime.inMinutes,
                        tickPerSection: widget.tickPerSection,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(65.0),
                    child: new EggTimerKnob(
                      rotationPercent: _rotationPercent() ,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialTurnGestureDetector extends StatefulWidget {

  final currentTime;
  final maxTime;
  final child;
  final Function(Duration) onTimeSelected;
  final c;
  final Function(Duration) onDialStopTurning;

  DialTurnGestureDetector({
    this.currentTime,
    this.maxTime,
    this.child,
    this.onTimeSelected,
    this.onDialStopTurning,
    this.c,
  });

  @override
  _DialTurnGestureDetectorState createState() => _DialTurnGestureDetectorState();
}

class _DialTurnGestureDetectorState extends State<DialTurnGestureDetector> {

  PolarCoord startDragCoord;
  Duration startDragTime;
  Duration selectedTime;

  _onRadialDragStart(PolarCoord coord){
    startDragCoord = coord;
    startDragTime = widget.currentTime;
  }

  _onRadialDragUpdate(PolarCoord coord){
    print('Radial drag coord : $coord');
    if(startDragCoord != null){
      final angleDiff = coord.angle - startDragCoord.angle;
      final anglePercent = angleDiff / (2 * math.pi);
      final timeDiffInSeconds = (anglePercent * widget.maxTime.inSeconds).round();
      selectedTime = new Duration(seconds: startDragTime.inSeconds + timeDiffInSeconds);
      print('New time : ${selectedTime.inMinutes}');

      widget.onTimeSelected(selectedTime);
    }
  }

  _onRadialDragEnd(){
    widget.onDialStopTurning(selectedTime);
    
    startDragCoord = null;
    startDragTime = null;
    selectedTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: _onRadialDragEnd,
      child: widget.child,
    );
  }
}

class TickPainter extends CustomPainter {
  final long_tick = 14.0;
  final short_tick = 4.0;

  final tickCount;
  final tickPerSection;
  final tickInset;
  final tickPaint;
  final textPainter;
  final textStyle;

  TickPainter({
    this.tickCount = 35,
    this.tickPerSection = 5,
    this.tickInset = 0.0,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'BebaNeue',
          fontSize: 20.0,
        ) {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    final radius = size.width / 2;
    for (var i = 0; i < tickCount; ++i) {
      final tickLength = i % tickPerSection == 0 ? long_tick : short_tick;

      canvas.drawLine(
        new Offset(0.0, -radius),
        new Offset(0.0, -radius - tickLength),
        tickPaint,
      );

      if (i % tickPerSection == 0) {
        //paint text
        canvas.save();
        canvas.translate(0.0, -(size.width / 2) - 30.0);

        textPainter.text = new TextSpan(
          text: '$i',
          style: textStyle,
        );

        textPainter.layout();

        final tickPercent = i / tickCount;
        var quadrant;
        if (tickPercent < 0.25) {
          quadrant = 1;
        } else if (tickPercent < 0.5) {
          quadrant = 4;
        } else if (tickPercent < 0.75) {
          quadrant = 3;
        } else {
          quadrant = 2;
        }

        switch (quadrant) {
          case 4:
            canvas.rotate(-math.pi / 2);
            break;
          case 2:
          case 3:
            canvas.rotate(math.pi / 2);
            break;
        }
        textPainter.paint(
          canvas,
          new Offset(
            -textPainter.width / 2,
            -textPainter.height / 2,
          ),
        );
        canvas.restore();
        
        
      }
      
      canvas.rotate(2 * math.pi / tickCount);
    
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
