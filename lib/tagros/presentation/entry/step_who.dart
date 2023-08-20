import 'package:flutter/material.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_components.dart';

class WhoStep extends StatelessWidget {
  final String title;
  final PlayerBean? taker;
  final void Function(PlayerBean player) onTakerSelected;
  final List<PlayerBean> players;

  const WhoStep({
    super.key,
    required this.taker,
    required this.onTakerSelected,
    required this.title,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Headline(text: title),
        Expanded(
          child: SelectPlayerInList(
            players: players,
            selected: taker,
            onPlayerSelected: onTakerSelected,
          ),
        ),
      ],
    );
  }
}

class KingStep extends StatelessWidget {
  final String title;
  final PlayerBean? king1;
  final PlayerBean? king2;
  final void Function(PlayerBean player) onKing1Selected;
  final void Function(PlayerBean player) onKing2Selected;
  final List<PlayerBean> players;

  const KingStep({
    super.key,
    required this.title,
    required this.king1,
    required this.king2,
    required this.onKing1Selected,
    required this.onKing2Selected,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Headline(text: title),
        Expanded(
          child: (players.length == 5)
              ? SelectPlayerInList(
                  players: players,
                  selected: king1,
                  onPlayerSelected: onKing1Selected)
              : Row(
                  children: [
                    Expanded(
                      child: SelectPlayerInList(
                        players: players,
                        selected: king1,
                        onPlayerSelected: onKing1Selected,
                      ),
                    ),
                    Expanded(
                      child: SelectPlayerInList(
                        players: players,
                        selected: king2,
                        onPlayerSelected: onKing2Selected,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class SelectPlayerInList extends StatelessWidget {
  const SelectPlayerInList({
    super.key,
    required this.players,
    required this.selected,
    required this.onPlayerSelected,
  });

  final List<PlayerBean> players;
  final PlayerBean? selected;
  final void Function(PlayerBean player) onPlayerSelected;

  @override
  Widget build(BuildContext context) {
    return BoundedSeparatedListView(
      children: List.generate(players.length, (index) {
        final player = players[index];
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: player == selected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surface),
            onPressed: () {
              onPlayerSelected(player);
            },
            child: Text(
              player.name,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: player == selected
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onSurface),
            ));
      }),
    );
  }
}
