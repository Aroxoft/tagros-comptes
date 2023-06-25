import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/tableau_repository_impl.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/presentation/widget/tableau_body.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';

class TableauPage extends ConsumerWidget {
  const TableauPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final tableauRepository =
        ref.watch(tableauRepositoryProvider(game.game.id.value));
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.nbPlayers(game.players.length)),
        ),
        floatingActionButton: FloatingActionButton(
            // key: ValueKey("${ref.watch(navigationPrefixProvider)}tableau-fab"),
            heroTag: UniqueKey(),
            onPressed: () async {
              final info = await navigateToAddModify(context,
                  game: game, infoEntry: null);
              if (info != null) {
                ref.read(entriesProvider).inAddEntry.add(info);
                final theme = ref.read(themeColorProvider).maybeWhen(
                    orElse: () => ThemeColor.defaultTheme(),
                    data: (data) => data);
                if (!context.mounted) return;
                Flushbar(
                  flushbarStyle: FlushbarStyle.GROUNDED,
                  flushbarPosition: FlushbarPosition.TOP,
                  title: S.of(context).successAddingGame,
                  duration: const Duration(seconds: 2),
                  titleColor: theme.textColor,
                  messageColor: theme.textColor,
                  message: info.toString(),
                  backgroundGradient: LinearGradient(
                    colors: [
                      if (theme.backgroundGradient1.opacity != 0)
                        theme.backgroundGradient1
                      else
                        theme.averageBackgroundColor.darken(0.3),
                      if (theme.backgroundGradient2.opacity != 0)
                        theme.backgroundGradient2
                      else
                        theme.averageBackgroundColor.lighten(0.3),
                    ],
                  ),
                ).show(context);
                if (kDebugMode) {
                  print(info);
                }
              }
            },
            child: const Icon(Icons.add)),
        body: TableauBody(
            players: game.players
                .map((e) => PlayerBean.fromDb(e))
                .whereNotNull()
                .toList()),
      ),
    );
  }
}
