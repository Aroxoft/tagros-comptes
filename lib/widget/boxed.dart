import 'package:flutter/material.dart';

class Boxed extends StatelessWidget {
  final Color fillColor;

  final Color color;
  final double borderWidth, radius;

  final Widget child;

  final String title;
  final TextStyle textStyle;

  const Boxed(
      {Key key,
      this.fillColor = Colors.white,
      this.color = Colors.green,
      this.borderWidth = 2,
      this.radius = 20,
      @required this.child,
      @required this.title,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: color, width: borderWidth),
                borderRadius: BorderRadius.circular(radius),
                color: fillColor),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 18, right: 10, left: 10, bottom: 20),
              child: child,
            ),
          ),
        ),
        Positioned(
            left: 20,
            top: 10,
            child: Container(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              color: fillColor,
              child: Text(
                title,
                style: textStyle,
              ),
            ))
      ],
    );
  }
}
