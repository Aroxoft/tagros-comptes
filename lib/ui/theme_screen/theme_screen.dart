import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/model/game/info_entry.dart';
import 'package:tagros_comptes/model/game/info_entry_player.dart';
import 'package:tagros_comptes/model/game/player.dart';
import 'package:tagros_comptes/model/game/prise.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/services/db/games_dao.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/entry_screen/add_modify.dart';
import 'package:tagros_comptes/ui/screen/menu.dart';
import 'package:tagros_comptes/ui/table_screen/tableau.dart';
import 'package:tagros_comptes/ui/theme_screen/preset_themes.dart';
import 'package:tagros_comptes/ui/theme_screen/theme_customization.dart';
import 'package:tagros_comptes/ui/widget/background_gradient.dart';

class ThemeScreen extends HookConsumerWidget {
  const ThemeScreen({Key? key}) : super(key: key);
  static const routeName = '/theme';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: BackgroundGradient(
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).themeScreenTitle),
            bottom: TabBar(
                indicatorColor: ref.watch(themeColorProvider
                    .select((value) => value.value?.sliderColor)),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                tabs: ["Preset themes", "Customize"]
                    .map((e) => Tab(text: e))
                    .toList()),
          ),
          body: Column(
            children: const [
              ThemePreview(),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    PresetThemes(),
                    ThemeCustomization(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _fakeDbProvider = Provider((ref) {
  final db = FakeDatabase();
  ref.onDispose(() {
    db.close();
  });
  return db;
});

class ThemePreview extends HookConsumerWidget {
  const ThemePreview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = GameWithPlayers(players: [
      Player(pseudo: "Alice"),
      Player(pseudo: "Bob"),
      Player(pseudo: "Charline")
    ], game: Game(id: 1, nbPlayers: 3, date: DateTime.now()).toCompanion(true));
    return SizedBox(
      height: 200,
      child: ProviderScope(
        overrides: [
          gameProvider.overrideWithValue(game),
          databaseProvider.overrideWithValue(ref.watch(_fakeDbProvider)),
          navigationPrefixProvider.overrideWithValue("theme-preview-"),
        ],
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            PreviewScreen(child: MenuScreen()),
            PreviewScreen(child: TableauPage()),
            PreviewScreen(child: AddModifyEntry()),
          ],
        ),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        child: FittedBox(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: child)));
  }
}

class FakeDatabase extends AppDatabase {
  FakeDatabase() : super(NativeDatabase.memory());

  @override
  GamesDao get gamesDao => FakeGamesDao(this);
}

class FakeGamesDao extends GamesDao {
  FakeGamesDao(AppDatabase db) : super(db);

  @override
  Stream<List<InfoEntryPlayerBean>> watchInfoEntriesInGame(int gameId) {
    return Stream.value([
      InfoEntryPlayerBean(
        infoEntry: InfoEntryBean(
          points: 36,
          nbBouts: 3,
          pointsForAttack: true,
        ),
        player: PlayerBean(name: "Alice"),
      ),
      InfoEntryPlayerBean(
        infoEntry: InfoEntryBean(
          points: 55,
          nbBouts: 2,
          prise: Prise.garde,
          pointsForAttack: true,
        ),
        player: PlayerBean(name: "Bob"),
      ),
    ]);
  }
}
