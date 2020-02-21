import 'package:flutter/material.dart';

class Tableau extends StatelessWidget {
  static const String routeName = "/tableau";

  @override
  Widget build(BuildContext context) {
    // extract players
    final TableauArguments args = ModalRoute.of(context).settings.arguments;

    return Container(
      child: Text("Players: ${args.players}"),
    );
  }
}

class TableauArguments {
  List<String> players;

  TableauArguments(this.players);
}
