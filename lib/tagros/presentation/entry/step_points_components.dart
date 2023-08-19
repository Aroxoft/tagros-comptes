import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tagros_comptes/common/presentation/flutter_icons.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_components.dart';
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
  final List<Camp?> petitAuBout;
  final void Function(Camp? camp, int index) onSetPetitAuBout;

  const PetitsAuBoutBonus({
    super.key,
    required this.petitAuBout,
    required this.onSetPetitAuBout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(petitAuBout.length, (index) {
        final camp = petitAuBout[index];
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
              colorBuilder: (camp) {
                switch (camp) {
                  case Camp.attack:
                    return kColorAttack;
                  case Camp.defense:
                    return kColorDefense;
                  default:
                    return Theme.of(context).colorScheme.surface;
                }
              },
              borderColorBuilder: (camp) {
                switch (camp) {
                  case Camp.attack:
                    return kColorAttack;
                  case Camp.defense:
                    return kColorDefense;
                  default:
                    return Theme.of(context).colorScheme.outline;
                }
              },
              innerGradient:
                  LinearGradient(colors: [kColorBrokenHearts1, Colors.grey]),
              iconBuilder: (camp, size, selected) {
                switch (camp) {
                  case Camp.attack:
                    return Icon(
                      FlutterIcons.attack,
                      size: size.longestSide,
                      color: selected
                          ? Theme.of(context).colorScheme.onPrimary
                          : null,
                    );
                  case Camp.defense:
                    return Icon(FlutterIcons.defense,
                        size: size.longestSide,
                        color: selected
                            ? Theme.of(context).colorScheme.onPrimary
                            : null);
                  default:
                    return const SizedBox.shrink();
                }
              },
              onChanged: (changed) {
                onSetPetitAuBout(changed, index);
              },
              onTap: () {
                onSetPetitAuBout(null, index);
              },
            ),
          ],
        );
      }),
    );
  }
}
