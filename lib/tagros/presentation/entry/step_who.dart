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
          child: BoundedSeparatedListView(
            children: List.generate(players.length, (index) {
              final player = players[index];
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: player == taker
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.surface),
                  onPressed: () {
                    onTakerSelected(player);
                  },
                  child: Text(
                    player.name,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: player == taker
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.onSurface),
                  ));
            }),
          ),
        ),
      ],
    );
  }
}
