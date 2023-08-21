import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tagros_comptes/common/presentation/flutter_icons.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_components.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_ui_state.dart';
import 'package:tagros_comptes/tagros/presentation/number_format.dart';
import 'package:tagros_comptes/theme/data/colors.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';

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
        GestureDetector(
          onTap: () {
            final nextCamp = switch (camp) {
              Camp.attack => Camp.defense,
              Camp.defense => null,
              null => Camp.attack
            };
            onSetPetitAuBout(nextCamp);
          },
          child: Container(
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
            if (changed != camp) {
              onSetPetitAuBout(changed);
            }
          },
          onTap: (tapped) {
            if (tapped.tappedValue == camp) {
              onSetPetitAuBout(null);
            }
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
    final gradientColors = [
      Theme.of(context).colorScheme.primary.withOpacity(0.2),
      Theme.of(context).colorScheme.primary.withOpacity(0.5),
      Theme.of(context).colorScheme.primary.withOpacity(1),
    ];
    final gradient = LinearGradient(colors: gradientColors);
    final gradient2 = LinearGradient(
        colors: gradientColors.map((e) => e.lighten(0.7)).toList());
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            final nextPoignee = switch (poignee) {
              PoigneeType.simple => PoigneeType.double,
              PoigneeType.double => PoigneeType.triple,
              PoigneeType.triple => null,
              null => PoigneeType.simple
            };
            onSetPoignee(nextPoignee);
          },
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconPoignee(poignee: poignee, nbPlayers: nbPlayers),
                Text(
                  "poignée\n${poignee?.displayName ?? ''}",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        RotatedBox(
          quarterTurns: 1,
          child: AnimatedToggleSwitch.rolling(
            allowUnlistedValues: true,
            current: poignee,
            iconBuilder: (poignee, selected) {
              if (poignee == null) return const SizedBox.shrink();
              return RotatedBox(
                quarterTurns: 3,
                child: _IconIndicatorPoignee(
                  size: Size(20, 20),
                  selected: selected,
                  poignee: poignee,
                  nbPlayers: nbPlayers,
                ),
              );
            },
            styleBuilder: (poignee) {
              switch (poignee) {
                case PoigneeType.simple:
                  return ToggleStyle(
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    borderColor: Theme.of(context).colorScheme.secondary,
                    backgroundGradient: gradient,
                  );
                case PoigneeType.double:
                  return ToggleStyle(
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    borderColor: Theme.of(context).colorScheme.secondary,
                    backgroundGradient: gradient,
                  );
                case PoigneeType.triple:
                  return ToggleStyle(
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    borderColor: Theme.of(context).colorScheme.secondary,
                    backgroundGradient: gradient,
                  );
                default:
                  return ToggleStyle(
                    borderColor: Theme.of(context).colorScheme.onSurface,
                    backgroundGradient: gradient2,
                  );
              }
            },
            values: PoigneeType.values,
            onChanged: (changed) {
              if (changed != poignee) {
                onSetPoignee(changed);
              }
            },
            onTap: (tap) {
              if (tap.tappedValue == poignee) {
                onSetPoignee(null);
              }
            },
          ),
        )
      ],
    );
  }
}

class IconPoignee extends StatelessWidget {
  final double widthCard;
  final double heightCard;
  final PoigneeType? poignee;
  final int nbPlayers;

  const IconPoignee(
      {super.key,
      required this.poignee,
      required this.nbPlayers,
      this.widthCard = 30,
      this.heightCard = 50});

  @override
  Widget build(BuildContext context) {
    final heightWidget =
        (widthCard + sqrt2 * sqrt(pow(widthCard, 2) + 4 * pow(heightCard, 2))) /
            (2 * sqrt2);
    final widthWidget = (2 * heightCard + widthCard) / sqrt2;
    if (kDebugMode) {
      print("heightWidget $heightWidget, widthWidget $widthWidget");
    }
    final text =
        poignee != null ? getNbAtouts(poignee!, nbPlayers).toString() : "0";
    final nbCards = switch (poignee) {
      PoigneeType.simple => 3,
      PoigneeType.double => 4,
      PoigneeType.triple => 5,
      null => 3,
    };
    return SizedBox(
      width: widthWidget,
      height: heightWidget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(nbCards, (index) {
            return Positioned(
              bottom: widthCard / (2 * sqrt2),
              left: (widthWidget - widthCard) / 2,
              child: Transform(
                  transform: Matrix4.rotationZ(
                      pi / 4 - (index * pi / (2 * (nbCards - 1)))),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        color: poignee != null
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.surface,
                        border: Border.all(
                            color: poignee != null
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.onSurface),
                        borderRadius: BorderRadius.circular(8)),
                    width: widthCard,
                    height: heightCard,
                  )),
            );
          }),
          Positioned(
            bottom: -5,
            right: 0,
            left: 0,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..color = Theme.of(context).colorScheme.surface
                        ..strokeWidth = 10
                        ..style = PaintingStyle.stroke),
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..color = Theme.of(context).colorScheme.onSurface
                      ..strokeWidth = 3
                      ..style = PaintingStyle.fill,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconIndicatorPoignee extends StatelessWidget {
  final Size size;
  final PoigneeType poignee;
  final int nbPlayers;
  final bool selected;

  const _IconIndicatorPoignee({
    super.key,
    required this.size,
    required this.poignee,
    required this.selected,
    required this.nbPlayers,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        getNbAtouts(poignee, nbPlayers).toString(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface),
        textAlign: TextAlign.center,
      ),
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
