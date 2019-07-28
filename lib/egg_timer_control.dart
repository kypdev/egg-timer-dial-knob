import 'package:flutter/material.dart';

import 'egg_timer_button.dart';

class EggTimerControl extends StatefulWidget {
  @override
  _EggTimerControlState createState() => _EggTimerControlState();
}

class _EggTimerControlState extends State<EggTimerControl> {
  @override
  Widget build(BuildContext context) {
    return Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new EggTimerButton(
                      icon: Icons.refresh,
                      text: 'Restart',
                    ),

                    new Expanded(child: new Container()),

                    new EggTimerButton(
                      icon: Icons.pause,
                      text: 'Pause',
                    ),
                  ],
                ),

                new EggTimerButton(
                  icon: Icons.arrow_back,
                  text: 'Reset',
                ),
              ],
            );
  }
}