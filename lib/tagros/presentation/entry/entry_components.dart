import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/tagros/domain/game/bonuses.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/presentation/number_format.dart';

class BoundedSeparatedListView extends StatelessWidget {
  final List<Widget> children;
  final double maxHeightItem;
  final double minHeightItem;
  final double separatorHeight;
  final double paddingTop;
  final double paddingBottom;

  const BoundedSeparatedListView({
    required this.children,
    this.maxHeightItem = 120,
    this.separatorHeight = 10,
    this.minHeightItem = 60,
    this.paddingTop = 36,
    this.paddingBottom = 36,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final maxHeight = constraints.maxHeight;
      final height = max(
          minHeightItem,
          min(
              maxHeightItem,
              (maxHeight -
                      separatorHeight * (children.length - 1) -
                      paddingTop -
                      paddingBottom) /
                  children.length));
      print('maxHeight: $maxHeight, height: $height');
      return ListView.separated(
          padding: EdgeInsets.only(
              top: paddingTop, bottom: paddingBottom, left: 20, right: 20),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: height,
              child: children[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(height: separatorHeight),
          itemCount: children.length);
    });
  }
}

class BoundedSeparatedHorizontalListView extends StatelessWidget {
  final List<Widget> children;
  final double maxWidthItem;
  final double minWidthItem;
  final double separatorWidth;
  final double paddingLeft;
  final double paddingRight;

  const BoundedSeparatedHorizontalListView({
    super.key,
    required this.children,
    this.maxWidthItem = 100,
    this.minWidthItem = 40,
    this.separatorWidth = 5,
    this.paddingLeft = 16,
    this.paddingRight = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final maxWidth = constraints.maxWidth;
      final width = max(
          minWidthItem,
          min(
              maxWidthItem,
              (maxWidth -
                      separatorWidth * (children.length - 1) -
                      paddingLeft -
                      paddingRight) /
                  children.length));
      print('maxWidth: $maxWidth, width: $width');
      return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
              left: paddingLeft, right: paddingRight, top: 8, bottom: 8),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: width,
              child: children[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(width: separatorWidth),
          itemCount: children.length);
    });
  }
}

class Headline extends StatelessWidget {
  final String text;

  const Headline({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Text(text, style: Theme.of(context).textTheme.displayMedium),
    );
  }
}

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

class AddBonus extends StatelessWidget {
  const AddBonus({
    super.key,
    required this.onAddPoignee,
    required this.onAddPetitAuBout,
    required this.poignees,
    required this.petitAuBout,
    required this.nbPlayers,
    required this.onRemovePetitAuBout,
    required this.onRemovePoignee,
  });

  final void Function(PoigneeType poignee) onAddPoignee;
  final void Function(Camp camp) onAddPetitAuBout;
  final void Function(Camp camp) onRemovePetitAuBout;
  final void Function(PoigneeType poignee) onRemovePoignee;
  final List<PoigneeType> poignees;
  final List<Camp> petitAuBout;
  final int nbPlayers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Headline(text: 'Bonus'),
        if (petitAuBout.isNotEmpty)
          ...List.generate(
            petitAuBout.length,
            (int index) {
              final camp = petitAuBout[index];
              return Chip(
                  onDeleted: () {
                    onRemovePetitAuBout(camp);
                  },
                  label: Text(
                      S.of(context).addModifyPetitAuBout + camp.displayName));
            },
          ),
        if (poignees.isNotEmpty)
          ...List.generate(poignees.length, (index) {
            final poignee = poignees[index];
            return Chip(
                onDeleted: () {
                  onRemovePoignee(poignee);
                },
                label:
                    Text(S.of(context).addModifyPoignee + poignee.displayName));
          }),
        ElevatedButton.icon(
            onPressed: () {
              // todo add bonus
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                        height: 300,
                        child: BonusModal(
                          onAddBonus: (bonusType) {
                            bonusType.when(
                              poignee: (poignee) {
                                onAddPoignee(poignee);
                              },
                              petitAuBout: (forAttack) {
                                onAddPetitAuBout(
                                    forAttack ? Camp.attack : Camp.defense);
                              },
                            );
                            context.pop();
                          },
                        ));
                  });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add bonus')),
      ],
    );
  }
}

class BonusModal extends HookWidget {
  final void Function(BonusType bonusType) onAddBonus;

  const BonusModal({
    super.key,
    required this.onAddBonus,
  });

  @override
  Widget build(BuildContext context) {
    final bonus = useState<_BonusType?>(null);
    final pageController = usePageController();
    return PageView(
      controller: pageController,
      children: [
        BoundedSeparatedListView(children: [
          BonusChoice(
              title: "Poignée",
              onChoose: () {
                bonus.value = _BonusType.poignee;
                pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 35,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).colorScheme.surface),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 1),
                  itemCount: 10)),
          BonusChoice(
            title: "Petit au bout",
            onChoose: () {
              bonus.value = _BonusType.petitAuBout;
              pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2,
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "1",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                )),
          ),
        ]),
        if (bonus.value == _BonusType.poignee)
          BoundedSeparatedListView(
              children: ((PoigneeType.values.toList())
                    ..remove(PoigneeType.none))
                  .map((e) {
            return BonusChoice(
              title: e.displayName,
              onChoose: () {
                onAddBonus(BonusType.poignee(poigneeType: e));
              },
            );
          }).toList())
        else if (bonus.value == _BonusType.petitAuBout)
          BoundedSeparatedListView(
              children: ((Camp.values.toList())..remove(Camp.none)).map((e) {
            return BonusChoice(
              title: e.displayName,
              onChoose: () {
                onAddBonus(BonusType.petitAuBout(forAttack: e == Camp.attack));
              },
            );
          }).toList())
        else
          const SizedBox(),
        Placeholder(),
      ],
    );
  }
}

enum _BonusType {
  poignee,
  petitAuBout,
}

class BonusChoice extends StatelessWidget {
  final String title;
  final Widget? child;
  final void Function() onChoose;

  const BonusChoice({
    super.key,
    required this.title,
    required this.onChoose,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChoose,
      child: Ink(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 2,
              )),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Text(title),
              if (child != null) Flexible(child: child!),
            ],
          )),
    );
  }
}
