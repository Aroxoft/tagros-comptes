import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tagros_comptes/common/presentation/flutter_icons.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_components.dart';
import 'package:tagros_comptes/tagros/presentation/entry_view_model.dart';
import 'package:tagros_comptes/tagros/presentation/number_format.dart';
import 'package:tagros_comptes/theme/data/colors.dart';

class PointsComponent extends HookWidget {
  final void Function() onPlus1PointClicked;
  final void Function() onMinus1PointClicked;
  final void Function() onPlus10PointsClicked;
  final void Function() onMinus10PointsClicked;
  final void Function(double input) onPointsUpdated;

  final double points;

  const PointsComponent({
    super.key,
    required this.onPlus1PointClicked,
    required this.onMinus1PointClicked,
    required this.onPlus10PointsClicked,
    required this.onMinus10PointsClicked,
    required this.onPointsUpdated,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: points.toPoints);
    useEffect(() {
      final text = points.toPoints;
      textController.value = textController.value.copyWith(
          text: text, selection: TextSelection.collapsed(offset: text.length));
      return null;
    }, [points]);
    return BoundedSeparatedHorizontalListView(
      separatorWidth: 2,
      children: [
        ElevatedButton(
          onPressed: onMinus10PointsClicked,
          child: const Text("-10"),
        ),
        ElevatedButton(
          onPressed: onMinus1PointClicked,
          child: const Text("-1"),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              points.toPoints,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onPlus1PointClicked,
          child: const Text("+1"),
        ),
        ElevatedButton(
          onPressed: onPlus10PointsClicked,
          child: const Text("+10"),
        ),
      ],
    );
  }
}

class PetitsAuBoutBonus extends StatelessWidget {
  final EntryUIState data;
  final void Function(Camp? camp, int index) onSetPetitAuBout;

  const PetitsAuBoutBonus({
    super.key,
    required this.onSetPetitAuBout,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: data.map(
            classic: (classic) => [
                  _PetitAuBoutComponent(
                      camp: classic.petitAuBout,
                      onSetPetitAuBout: (camp) {
                        onSetPetitAuBout(camp, 0);
                      })
                ],
            fivePlayers: (fivePlayers) => [
                  _PetitAuBoutComponent(
                      camp: fivePlayers.petitAuBout,
                      onSetPetitAuBout: (camp) {
                        onSetPetitAuBout(camp, 0);
                      })
                ],
            tagros: (tagros) => [
                  _PetitAuBoutComponent(
                      camp: tagros.petitsAuBout[0],
                      onSetPetitAuBout: (camp) {
                        onSetPetitAuBout(camp, 0);
                      }),
                  _PetitAuBoutComponent(
                      camp: tagros.petitsAuBout[1],
                      onSetPetitAuBout: (camp) {
                        onSetPetitAuBout(camp, 1);
                      }),
                ]));
  }
}

class _PetitAuBoutComponent extends StatelessWidget {
  const _PetitAuBoutComponent({
    required this.camp,
    required this.onSetPetitAuBout,
  });

  final Camp? camp;
  final void Function(Camp? camp) onSetPetitAuBout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 60,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface,
              width: 2,
            ),
          ),
          child: Center(
            child: Text("1",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
          ),
        ),
        AnimatedToggleSwitch<Camp?>.rolling(
          allowUnlistedValues: true,
          current: camp,
          values: const [Camp.defense, Camp.attack],
          styleBuilder: (camp) {
            switch (camp) {
              case Camp.attack:
                return ToggleStyle(
                  indicatorColor: kColorAttack,
                  backgroundColor: kColorAttack,
                  borderColor: kColorAttack,
                  backgroundGradient: LinearGradient(
                      colors: [kColorDefense.withOpacity(0.2), kColorAttack]),
                );
              case Camp.defense:
                return ToggleStyle(
                  indicatorColor: kColorDefense,
                  backgroundColor: kColorDefense,
                  borderColor: kColorDefense,
                  backgroundGradient: LinearGradient(
                      colors: [kColorDefense, kColorAttack.withOpacity(0.2)]),
                );
              default:
                return ToggleStyle(
                  indicatorColor: Theme.of(context).colorScheme.onSurface,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  borderColor: Theme.of(context).colorScheme.outline,
                  backgroundGradient: LinearGradient(colors: [
                    kColorDefense.withOpacity(0.2),
                    kColorAttack.withOpacity(0.2)
                  ]),
                );
            }
          },
          iconBuilder: (camp, selected) {
            switch (camp) {
              case Camp.attack:
                return Icon(
                  FlutterIcons.attack,
                  color:
                      selected ? Theme.of(context).colorScheme.onPrimary : null,
                );
              case Camp.defense:
                return Icon(FlutterIcons.defense,
                    color: selected
                        ? Theme.of(context).colorScheme.onPrimary
                        : null);
              default:
                return const SizedBox.shrink();
            }
          },
          onChanged: (changed) {
            onSetPetitAuBout(changed);
          },
          onTap: () {
            onSetPetitAuBout(null);
          },
        ),
      ],
    );
  }
}

class PoigneesBonus extends StatelessWidget {
  final EntryUIState data;
  final void Function(PoigneeType? poignee, int index) onSetPoignee;

  const PoigneesBonus({
    super.key,
    required this.data,
    required this.onSetPoignee,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 720,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.poignees.length,
        itemBuilder: (BuildContext context, int index) {
          final poignee = data.poignees[index];
          return _PoigneeComponent(
            poignee: poignee,
            onSetPoignee: (poignee) {
              onSetPoignee(poignee, index);
            },
            nbPlayers: data.allPlayers.length,
          );
        },
      ),
    );
  }
}

class _PoigneeComponent extends StatelessWidget {
  final int nbPlayers;
  final PoigneeType? poignee;
  final void Function(PoigneeType? poignee) onSetPoignee;

  const _PoigneeComponent({
    this.poignee,
    required this.onSetPoignee,
    required this.nbPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: Text(poignee?.displayName ?? ""),
        ),
        AnimatedToggleSwitch.rolling(
          allowUnlistedValues: true,
          current: poignee,
          iconBuilder: (poignee, selected) => IconPoignee(
              size: Size(20, 20), selected: selected, poignee: poignee),
          values: PoigneeType.values,
          onChanged: (changed) {
            onSetPoignee(changed);
          },
          onToggleOff: () {
            onSetPoignee(null);
          },
        ),
      ],
    );
  }
}

class IconPoignee extends StatelessWidget {
  final Size size;
  final PoigneeType? poignee;
  final bool selected;

  const IconPoignee({
    super.key,
    required this.size,
    required this.poignee,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      fallbackWidth: size.width,
      fallbackHeight: size.height,
    );
  }
}

class SelectOudlers extends StatelessWidget {
  final EntryUIState data;
  final void Function(bool on, int index) onPetitClicked;
  final void Function(bool on, int index) onVingtEtUnClicked;
  final void Function(bool on, int index) onExcuseClicked;

  const SelectOudlers(
      {super.key,
      required this.onPetitClicked,
      required this.onVingtEtUnClicked,
      required this.onExcuseClicked,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SegmentedButton(
            multiSelectionEnabled: true,
            emptySelectionAllowed: true,
            segments: [
              ButtonSegment(value: "1_1", label: Text("1")),
              if (data.tagros) ButtonSegment(value: "1_2", label: Text("1")),
              ButtonSegment(value: "21_1", label: Text("21")),
              if (data.tagros) ButtonSegment(value: "21_2", label: Text("21")),
              ButtonSegment(value: "0_1", label: Text("Excuse")),
              if (data.tagros)
                ButtonSegment(value: "0_2", label: Text("Excuse")),
            ],
            selected: {
              if (data.petit) "1_1",
              if (data.maybeMap(orElse: () => false, tagros: (t) => t.petit2))
                "1_2",
              if (data.vingtEtUn) "21_1",
              if (data.maybeMap(
                  orElse: () => false, tagros: (t) => t.vingtEtUn2))
                "21_2",
              if (data.excuse) "0_1",
              if (data.maybeMap(orElse: () => false, tagros: (t) => t.excuse2))
                "0_2",
            },
            onSelectionChanged: (changed) {
              onPetitClicked(changed.contains("1_1"), 0);
              if (data.tagros) {
                onPetitClicked(changed.contains("1_2"), 1);
              }
              onVingtEtUnClicked(changed.contains("21_1"), 0);
              if (data.tagros) {
                onVingtEtUnClicked(changed.contains("21_2"), 1);
              }
              onExcuseClicked(changed.contains("0_1"), 0);
              if (data.tagros) {
                onExcuseClicked(changed.contains("0_2"), 1);
              }
            }),
      ),
    );
  }
}
