import 'package:flutter/material.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_components.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_ui_state.dart';
import 'package:tagros_comptes/tagros/presentation/entry/step_points_components.dart';

class PointsStep extends StatelessWidget {
  final void Function(double points) onPointsUpdated;

  final void Function(bool on, int index) onPetitClicked;
  final void Function(bool on, int index) onVingtEtUnClicked;
  final void Function(bool on, int index) onExcuseClicked;
  final void Function(bool forAttack) onForAttackChanged;

  final void Function(Camp? camp, int index) onSetPetitAuBout;
  final void Function(PoigneeType? poignee, int index) onSetPoignee;
  final EntryUIState data;

  const PointsStep({
    super.key,
    required this.onPetitClicked,
    required this.onVingtEtUnClicked,
    required this.onExcuseClicked,
    required this.onForAttackChanged,
    required this.onPointsUpdated,
    required this.onSetPetitAuBout,
    required this.onSetPoignee,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Headline(text: 'Combien ?'),
          SegmentedButton(
            segments: [
              ButtonSegment(
                  value: true, label: Text(S.of(context).campTypeAttack)),
              ButtonSegment(
                  value: false, label: Text(S.of(context).campTypeDefense))
            ],
            selected: {data.pointsForAttack},
            onSelectionChanged: (changed) {
              onForAttackChanged(changed.first);
            },
          ),
          Headline(text: S.of(context).points),
          SizedBox(
            height: 100,
            child: PointsComponent(
              onPlus1PointClicked: () {
                onPointsUpdated(data.points + 1);
              },
              onMinus1PointClicked: () {
                onPointsUpdated(data.points - 1);
              },
              onPlus10PointsClicked: () {
                onPointsUpdated(data.points + 10);
              },
              onMinus10PointsClicked: () {
                onPointsUpdated(data.points - 10);
              },
              onPointsUpdated: onPointsUpdated,
              points: data.points,
            ),
          ),
          SelectOudlers(
            data: data,
            onPetitClicked: (on, index) {
              onPetitClicked(on, index);
            },
            onVingtEtUnClicked: (on, index) {
              onVingtEtUnClicked(on, index);
            },
            onExcuseClicked: (on, index) {
              onExcuseClicked(on, index);
            },
          ),
          PoigneesBonus(data: data, onSetPoignee: onSetPoignee),
          PetitsAuBoutBonus(data: data, onSetPetitAuBout: onSetPetitAuBout),
        ],
      ),
    );
  }
}
