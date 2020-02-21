import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tagros_comptes/types/functions.dart';

class SelectableTag extends StatefulWidget {
  final String text;
  final OnPressed onPressed;
  final bool initialSelected;

  const SelectableTag(
      {Key key, @required this.text, @required this.onPressed, this.initialSelected})
      : super(key: key);

  @override
  _SelectableTagState createState() => _SelectableTagState();
}

class _SelectableTagState extends State<SelectableTag> {
  bool selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        return widget.onPressed;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: selected ? Colors.pink : Colors.transparent,
            border: Border.all(
                color: Colors.pink, style: BorderStyle.solid, width: 2)),
        child: Text(widget.text),
      ),
    );
  }
}
