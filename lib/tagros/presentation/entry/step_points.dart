import 'package:flutter/material.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_components.dart';

class PointsStep extends StatelessWidget {
  final double points;
  final bool petit;
  final bool vingtEtUn;
  final bool excuse;
  final bool petit2;
  final bool vingtEtUn2;
  final bool excuse2;
  final bool forAttack;
  final List<PoigneeType> poignees;
  final List<Camp> petitAuBout;
  final int nbPlayers;

  final void Function(double points) onPointsUpdated;

  final void Function(bool on) onPetitClicked;
  final void Function(bool on) onVingtEtUnClicked;
  final void Function(bool on) onExcuseClicked;
  final void Function(bool on) onPetit2Clicked;
  final void Function(bool on) onVingtEtUn2Clicked;
  final void Function(bool on) onExcuse2Clicked;
  final void Function(bool forAttack) onForAttackChanged;

  final void Function(Camp camp) onPetitAuBoutAdded;
  final void Function(PoigneeType poignee) onPoigneeAdded;
  final void Function(PoigneeType poignee) onPoigneeRemoved;
  final void Function(Camp camp) onPetitAuBoutRemoved;

  const PointsStep({
    super.key,
    required this.points,
    required this.petit,
    required this.vingtEtUn,
    required this.excuse,
    required this.forAttack,
    required this.poignees,
    required this.petitAuBout,
    required this.onPetitClicked,
    required this.onVingtEtUnClicked,
    required this.onExcuseClicked,
    required this.onForAttackChanged,
    required this.onPetit2Clicked,
    required this.onVingtEtUn2Clicked,
    required this.onExcuse2Clicked,
    required this.petit2,
    required this.vingtEtUn2,
    required this.excuse2,
    required this.nbPlayers,
    required this.onPointsUpdated,
    required this.onPetitAuBoutAdded,
    required this.onPoigneeAdded,
    required this.onPetitAuBoutRemoved,
    required this.onPoigneeRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Headline(text: 'Combien ?'),
          SegmentedButton(
            segments: const [
              ButtonSegment(value: true, label: Text('Attaque')),
              ButtonSegment(value: false, label: Text('Défense'))
            ],
            selected: {forAttack},
            onSelectionChanged: (changed) {
              onForAttackChanged(changed.first);
            },
          ),
          Headline(text: 'Points'),
          SizedBox(
            height: 100,
            child: PointsComponent(
              onPlus1PointClicked: () {
                onPointsUpdated(points + 1);
              },
              onMinus1PointClicked: () {
                onPointsUpdated(points - 1);
              },
              onPlus10PointsClicked: () {
                onPointsUpdated(points + 10);
              },
              onMinus10PointsClicked: () {
                onPointsUpdated(points - 10);
              },
              onPointsUpdated: onPointsUpdated,
              points: points,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SegmentedButton<int>(
                  emptySelectionAllowed: true,
                  multiSelectionEnabled: true,
                  segments: [
                    ButtonSegment(value: 1, label: Text("1")),
                    ButtonSegment(value: 21, label: Text("21")),
                    ButtonSegment(value: 0, label: Text("Excuse"))
                  ],
                  selected: {if (petit) 1, if (vingtEtUn) 21, if (excuse) 0},
                  onSelectionChanged: (changed) {
                    onPetitClicked(changed.contains(1));
                    onVingtEtUnClicked(changed.contains(21));
                    onExcuseClicked(changed.contains(0));
                  }),
            ),
          ),
          if (nbPlayers >= 7)
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SegmentedButton<int>(
                    emptySelectionAllowed: true,
                    multiSelectionEnabled: true,
                    segments: [
                      ButtonSegment(value: 1, label: Text("1")),
                      ButtonSegment(value: 21, label: Text("21")),
                      ButtonSegment(value: 0, label: Text("Excuse"))
                    ],
                    selected: {
                      if (petit2) 1,
                      if (vingtEtUn2) 21,
                      if (excuse2) 0
                    },
                    onSelectionChanged: (changed) {
                      onPetit2Clicked(changed.contains(1));
                      onVingtEtUn2Clicked(changed.contains(21));
                      onExcuse2Clicked(changed.contains(0));
                    }),
              ),
            ),
          AddBonus(
            onAddPoignee: (PoigneeType poignee) {
              // add poignee
              onPoigneeAdded(poignee);
            },
            onAddPetitAuBout: (Camp camp) {
              // add petit au bout
              onPetitAuBoutAdded(camp);
            },
            onRemovePoignee: (PoigneeType poignee) {
              // remove poignee
              onPoigneeRemoved(poignee);
            },
            onRemovePetitAuBout: (Camp camp) {
              // remove petit au bout
              onPetitAuBoutRemoved(camp);
            },
            poignees: poignees,
            petitAuBout: petitAuBout,
            nbPlayers: nbPlayers,
          ),
        ],
      ),
    );
  }
}
