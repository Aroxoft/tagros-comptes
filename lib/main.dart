import 'package:appspector/appspector.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/bloc/entry_db_bloc.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/screen/add_modify.dart';
import 'package:tagros_comptes/screen/menu.dart';
import 'package:tagros_comptes/screen/tableau.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runAppSpector();
  runApp(MyApp());
}

void runAppSpector() {
  var config = Config();
  config.androidApiKey =
      "android_YjE3ODM3ZDctZTdiMC00ZjRlLWJiMWMtZTJjOTg2ZjNjZjEz";
  AppSpectorPlugin.run(config);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(),
      routes: <String, WidgetBuilder>{
//        Tableau.routeName: (context) => Tableau(),
        MenuScreen.routeName: (context) => MenuScreen(),
        AddModifyEntry.routeName: (context) => AddModifyEntry(),
      },
    );
  }
}

Future<T> navigateToTableau<T>(BuildContext context,
    {@required GameWithPlayers game}) async {
  if (game.id == null) {
    var idGame = await MyDatabase.db.newGame(game);
    game.id = idGame;
  }
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BlocProvider(
            bloc: EntriesDbBloc(game),
            child: TableauPage(
              game: game,
            ),
          )));
}
