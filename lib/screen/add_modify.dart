import 'package:flutter/material.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';

class AddModifyEntry extends StatefulWidget {
  static String routeName = "/addModify";

  @override
  _AddModifyEntryState createState() => _AddModifyEntryState();
}

class _AddModifyEntryState extends State<AddModifyEntry> {
  InfoEntry infoEntry;
  bool add;

  @override
  Widget build(BuildContext context) {
    final AddModifyArguments args = ModalRoute
        .of(context)
        .settings
        .arguments;
    infoEntry = args.infoEntry;
    add = false;
    if (infoEntry == null) {
      add = true;
      infoEntry = InfoEntry(player: "", points: 0, nbBouts: 0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${(add ? "Ajout" : "Modification")} d'une partie"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            Navigator.of(context).pop(infoEntry);
          }),
      body: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[],
            ),
          )),
    );
  }
}

class AddModifyArguments {
  InfoEntry infoEntry;

  AddModifyArguments({this.infoEntry});
}
