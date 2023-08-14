import 'package:flutter/material.dart';
import 'package:tagros_comptes/generated/l10n.dart';

class DisplayAdvantages extends StatelessWidget {
  const DisplayAdvantages({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FixedColumnWidth(60),
              1: FlexColumnWidth(3),
            },
            children: [
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.app_blocking, size: 40),
                ),
                Text(S.of(context).subscription_advantages_noAds,
                    style: const TextStyle(fontSize: 16)),
              ]),
              TableRow(children: [
                const Icon(Icons.draw, size: 40),
                Text(S.of(context).subscription_advantages_moreThemes,
                    style: const TextStyle(fontSize: 16)),
              ]),
              // TableRow(children: [
              //   Icon(Icons.auto_graph, size: 40),
              //   Text("Graphes de statistiques", style: TextStyle(fontSize: 16)),
              // ]),
              TableRow(children: [
                const Icon(Icons.forest, size: 40),
                Text(S.of(context).subscription_advantages_noLimits,
                    style: const TextStyle(fontSize: 16)),
              ]),
              TableRow(children: [
                const Icon(Icons.auto_awesome, size: 40),
                Text(S.of(context).subscription_advantages_supportDev,
                    style: const TextStyle(fontSize: 16)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
