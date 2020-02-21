import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tagros_comptes/types/functions.dart';

class SelectableTag extends StatelessWidget {
  final String text;
  final OnPressed onPressed;
  final bool selected;
  final Color color;

  const SelectableTag(
      {Key key, @required this.text, @required this.onPressed, this.selected, this.color = Colors
          .pink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: selected ? color : Colors.transparent,
            border: Border.all(
                color: color, style: BorderStyle.solid, width: 2)),
        child: Text(text),
      ),
    );
  }
}
