import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/presentation/entry/step_points.dart';
import 'package:tagros_comptes/tagros/presentation/entry/step_what.dart';
import 'package:tagros_comptes/tagros/presentation/entry/step_who.dart';
import 'package:tagros_comptes/tagros/presentation/entry_view_model.dart';
import 'package:tagros_comptes/tagros/presentation/widget/snack_utils.dart';
import 'package:tuple/tuple.dart';

const nbPages4Players = 3;
const nbPages5Players = 4;
const nbPages7Players = 4;

class NewAddModify extends HookConsumerWidget {
  final int? roundId;
  final int initialPage;

  const NewAddModify({super.key, required this.roundId, this.initialPage = 0});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController =
        usePageController(initialPage: initialPage, keepPage: true);
    pageController.addListener(() {
      ref
          .read(entryViewModelProvider(roundId: roundId).notifier)
          .setPage(pageController.page!.round());
    });
    ref.listen(_messageProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next),
          duration: const Duration(seconds: 2),
        ));
      }
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
                                KingStep(
                                    title: "King(s)?",
                                    onKing1Selected: (king1) {
                                      final canNext = ref
                                          .read(entryViewModelProvider(
                                                  roundId: roundId)
                                              .notifier)
                                          .setPartner1(king1);
                                      if (canNext) {
                                        _nextPage(pageController);
                                      }
                                    },
                                    onKing2Selected: (king2) {
                                      final canNext = ref
                                          .read(entryViewModelProvider(
                                                  roundId: roundId)
                                              .notifier)
                                          .setPartner2(king2);
                                      if (canNext) {
                                        _nextPage(pageController);
                                      }
                                    },
                                    players: data.allPlayers,
                                    king1: data.mapOrNull(fivePlayers: (five) {
                                      return five.partner1;
                                    }, tagros: (tagros) {
                                      return tagros.partner1;
                                    }),
                                    king2: data.mapOrNull(tagros: (tagros) {
                                      return tagros.partner2;
                                    })),
                              PointsStep(
                                data: data,
                                onPointsUpdated: (double points) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPointsDouble(points);
                                },
                                onPetitClicked: (bool on, int index) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPetit(on, index);
                                },
                                onVingtEtUnClicked: (bool on, int index) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setVingtEtUn(on, index);
                                },
                                onExcuseClicked: (bool on, int index) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setExcuse(on, index);
                                },
                                onForAttackChanged: (bool forAttack) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPointsForAttack(forAttack);
                                },
                                onSetPetitAuBout: (Camp? camp, int index) {
                                  ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPetitAuBout(camp, index);
                                },
                                onSetPoignee:
                                    (PoigneeType? poignee, int index) {
                                  if (!ref
                                      .read(entryViewModelProvider(
                                              roundId: roundId)
                                          .notifier)
                                      .setPoignee(poignee, index)) {
                                    ref.watch(_messageProvider.notifier).state =
                                        S.of(context).addModifyPoigneeError(
                                              data.poignees.length,
                                              poignee?.name ?? '',
                                            );
                                  }
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
                          isLast: data.page == nbPages - 1,
                          canValidate: data.isValid,
                          onValidate: () {
                            final (saved, added) = ref
                                .read(entryViewModelProvider(roundId: roundId)
                                    .notifier)
                                .saveEntry();
                            if (saved != null) {
                              context.pop();
                              SchedulerBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                ref
                                    .read(messageObserverProvider.notifier)
                                    .state = Tuple2(added, saved);
                              });
                            } else {
                              displayFlushbar(context, ref,
                                  title: S.of(context).addModifyMissingTitle,
                                  message:
                                      S.of(context).addModifyMissingMessage);
                            }
                          },
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

class _ArrowBar extends StatelessWidget {
  final void Function() onPrevious;
  final void Function() onNext;
  final void Function() onValidate;
  final bool canPrevious;
  final bool canNext;
  final bool isLast;
  final bool canValidate;

  const _ArrowBar({
    required this.onPrevious,
    required this.onNext,
    required this.canPrevious,
    required this.canNext,
    required this.isLast,
    required this.onValidate,
    required this.canValidate,
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
              onPressed: canNext
                  ? onNext
                  : isLast && canValidate
                      ? onValidate
                      : null,
              icon: Icon(
                isLast ? Icons.check : Icons.arrow_forward,
                size: 30,
              )),
        ],
      ),
    );
  }
}

final _messageProvider = StateProvider<String?>((ref) {
  return null;
});
