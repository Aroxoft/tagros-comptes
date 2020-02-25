import 'package:flutter/material.dart';

class Boxed extends StatelessWidget {
  final Color fillColor;

  final Color color;
  final double borderWidth, radius;

  final Widget child;

  final String title;

  final FontWeight titleWeight;
  final double titleSize;

  const Boxed(
      {Key key,
      this.fillColor = Colors.white,
      this.color = Colors.green,
      this.borderWidth = 3,
      this.radius = 20,
      @required this.child,
      @required this.title, this.titleWeight = FontWeight.w700, this.titleSize = 18})
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
                style: TextStyle(
                    fontSize: titleSize, fontWeight: titleWeight, color: color),
              ),
            ))
      ],
    );
  }
}
