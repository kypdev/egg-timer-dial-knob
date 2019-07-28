import 'package:egg_timer/egg_timer.dart';
import 'package:flutter/material.dart';

import 'package:fluttery/animations.dart';
import 'package:fluttery/framing.dart';
import 'package:fluttery/gestures.dart';
import 'package:fluttery/layout.dart';

import 'egg_timer_button.dart';
import 'egg_timer_control.dart';
import 'egg_timer_dial.dart';
import 'egg_timer_display.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  EggTimer eggTimer;

  _MainPageState(){
       eggTimer = new EggTimer(
        maxTime: const Duration(minutes: 35),
        onTimerUpdate: _onTimerUpdate,
        );
  }

  _onTimeSelected(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;  
    }); 
  }

  _onDialStopTurning(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
      eggTimer.resume();
    });
  }

  _onTimerUpdate(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
        )),
        child: Center(
          child: new Column(
            children: <Widget>[
              new EggTimerDisplay(
                eggTimerState: eggTimer.state,
                selectionTime: eggTimer.lastStartTime,
                countdownTime: eggTimer.currentTime,
              ),
              new EggTimerDial(
                currentTime: eggTimer.currentTime,
                maxTime: eggTimer.maxTime,
                tickPerSection: 5,
                onTimeSelected: _onTimeSelected,
                onDialStopTurning: _onDialStopTurning,
              ),
              new Expanded(
                child: new Container(),
              ),
              new EggTimerControl(),
            ],
          ),
        ),
      ),
    );
  }
}
