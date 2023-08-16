import 'package:flutter/material.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_components.dart';

class WhatStep extends StatelessWidget {
  final Prise? prise;
  final void Function(Prise selected) onPriseSelected;

  const WhatStep({
    super.key,
    required this.prise,
    required this.onPriseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Headline(text: 'What?'),
        Expanded(
          flex: 1,
          child: BoundedSeparatedListView(
            children: List.generate(Prise.values.length, (index) {
              final e = Prise.values[index];
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: e == prise
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.surface),
                  onPressed: () {
                    onPriseSelected(e);
                  },
                  child: Text(
                    e.displayName,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: e == prise
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
