import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';
import 'package:tagros_comptes/tagros/presentation/entry_view_model.dart';

const nbPages4Players = 3;
const nbPages5Players = 4;
const nbPages7Players = 5;

class NewAddModify extends HookConsumerWidget {
  final int? roundId;

  const NewAddModify({super.key, required this.roundId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(initialPage: 0, keepPage: true);
    pageController.addListener(() {
      ref
          .read(entryViewModelProvider(roundId: roundId).notifier)
          .setPage(pageController.page!.round());
    });
    return BackgroundGradient(
      child: Scaffold(
        body: SafeArea(
          child: ref.watch(entryViewModelProvider(roundId: roundId)).when(
                data: (data) {
                  final nbPages = data.allPlayers.length < 5
                      ? nbPages4Players
                      : data.allPlayers.length < 7
                          ? nbPages5Players
                          : nbPages7Players;
                  return WillPopScope(
                    onWillPop: () {
                      if (data.page > 0) {
                        _previousPage(pageController);
                        return Future.value(false);
                      }
                      return Future.value(true);
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: pageController,
                            children: [
                              WhatStep(
                                  prise: data.prise,
                                  onPriseSelected: (selected) {
                                    ref
                                        .read(entryViewModelProvider(
                                                roundId: roundId)
                                            .notifier)
                                        .setPrise(selected);
                                    _nextPage(pageController);
                                  }),
                              WhoStep(
                                title: 'Taker',
                                taker: data.taker,
                                onTakerSelected: (selected) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setTaker(selected);
                                  _nextPage(pageController);
                                },
                                players: data.allPlayers,
                              ),
                              if (data.showPartnerPage)
                                WhoStep(
                                  taker: data.partner1,
                                  onTakerSelected: (selected) {
                                    ref
                                        .read(entryViewModelProvider(
                                                roundId: roundId)
                                            .notifier)
                                        .setPartner1(selected);
                                    _nextPage(pageController);
                                  },
                                  title: 'Partner 1',
                                  players: data.allPlayers,
                                ),
                              if (data.showPartner2Page)
                                WhoStep(
                                  taker: data.partner2,
                                  onTakerSelected: (selected) {
                                    ref
                                        .read(entryViewModelProvider(
                                                roundId: roundId)
                                            .notifier)
                                        .setPartner2(selected);
                                    _nextPage(pageController);
                                  },
                                  title: 'Partner 2',
                                  players: data.allPlayers,
                                ),
                              PointsStep(
                                nbPlayers: data.allPlayers.length,
                                points: data.points,
                                petit: data.petit,
                                vingtEtUn: data.vingtEtUn,
                                excuse: data.excuse,
                                petit2: data.petit2,
                                vingtEtUn2: data.vingtEtUn2,
                                excuse2: data.excuse2,
                                forAttack: data.pointsForAttack,
                                poignees: data.poignees,
                                petitAuBout: data.petitsAuBout,
                                onPlus1PointClicked: () {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPointsDouble(data.points + 1);
                                },
                                onMinus1PointClicked: () {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPointsDouble(data.points - 1);
                                },
                                onPlus10PointsClicked: () {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPointsDouble(data.points + 10);
                                },
                                onMinus10PointsClicked: () {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPointsDouble(data.points - 10);
                                },
                                onPetitClicked: (bool on) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPetit(on);
                                },
                                onVingtEtUnClicked: (bool on) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setVingtEtUn(on);
                                },
                                onExcuseClicked: (bool on) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setExcuse(on);
                                },
                                onPetit2Clicked: (bool on) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPetit2(on);
                                },
                                onVingtEtUn2Clicked: (bool on) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setVingtEtUn2(on);
                                },
                                onExcuse2Clicked: (bool on) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setExcuse2(on);
                                },
                                onForAttackChanged: (bool forAttack) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPointsForAttack(forAttack);
                                },
                              ),
                            ],
                          ),
                        ),
                        _ArrowBar(
                          onPrevious: () => _previousPage(pageController),
                          onNext: () => _nextPage(pageController),
                          canPrevious: data.page > 0,
                          canNext:
                              data.page < nbPages - 1 && data.nextPageEnabled,
                        )
                      ],
                    ),
                  );
                },
                error: (error, stack) => Text(error.toString()),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
        ),
      ),
    );
  }
}

void _nextPage(PageController pageController) {
  pageController.nextPage(
      duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
}

void _previousPage(PageController pageController) {
  pageController.previousPage(
      duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
}

class _Headline extends StatelessWidget {
  final String text;

  const _Headline({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Text(text, style: Theme.of(context).textTheme.displayMedium),
    );
  }
}

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
        _Headline(text: 'What?'),
        Expanded(
          flex: 1,
          child: _BoundedSeparatedListView(
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
        _Headline(text: title),
        Expanded(
          child: _BoundedSeparatedListView(
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

  final void Function() onPlus1PointClicked;
  final void Function() onMinus1PointClicked;
  final void Function() onPlus10PointsClicked;
  final void Function() onMinus10PointsClicked;
  final void Function(bool on) onPetitClicked;
  final void Function(bool on) onVingtEtUnClicked;
  final void Function(bool on) onExcuseClicked;
  final void Function(bool on) onPetit2Clicked;
  final void Function(bool on) onVingtEtUn2Clicked;
  final void Function(bool on) onExcuse2Clicked;
  final void Function(bool forAttack) onForAttackChanged;

  const PointsStep({
    super.key,
    required this.points,
    required this.petit,
    required this.vingtEtUn,
    required this.excuse,
    required this.forAttack,
    required this.poignees,
    required this.petitAuBout,
    required this.onPlus1PointClicked,
    required this.onMinus1PointClicked,
    required this.onPlus10PointsClicked,
    required this.onMinus10PointsClicked,
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Headline(text: 'Combien ?'),
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
        _Headline(text: 'Points'),
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
                  selected: {if (petit2) 1, if (vingtEtUn2) 21, if (excuse2) 0},
                  onSelectionChanged: (changed) {
                    onPetit2Clicked(changed.contains(1));
                    onVingtEtUn2Clicked(changed.contains(21));
                    onExcuse2Clicked(changed.contains(0));
                  }),
            ),
          )
      ],
    );
  }
}

class _ArrowBar extends StatelessWidget {
  final void Function() onPrevious;
  final void Function() onNext;
  final bool canPrevious;
  final bool canNext;

  const _ArrowBar({
    required this.onPrevious,
    required this.onNext,
    required this.canPrevious,
    required this.canNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton.filled(
              onPressed: canPrevious ? onPrevious : null,
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              )),
          const SizedBox(width: 50),
          IconButton.filled(
              onPressed: canNext ? onNext : null,
              icon: const Icon(
                Icons.arrow_forward,
                size: 30,
              )),
        ],
      ),
    );
  }
}

class _BoundedSeparatedListView extends StatelessWidget {
  final List<Widget> children;
  final double maxHeightItem;
  final double minHeightItem;
  final double separatorHeight;
  final double paddingTop;
  final double paddingBottom;

  const _BoundedSeparatedListView({
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
