import 'package:flutter/material.dart';

class EggTimerButton extends StatefulWidget {

  final IconData icon;
  final String text;

  EggTimerButton({
    this.icon,
    this.text,
  });



  @override
  _EggTimerButtonState createState() => _EggTimerButtonState();
}

class _EggTimerButtonState extends State<EggTimerButton> {
  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      splashColor: const Color(0x22000000),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: new Icon(
                widget.icon,
                color: Colors.black,
              ),
            ),
            new Text(
              widget.text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
