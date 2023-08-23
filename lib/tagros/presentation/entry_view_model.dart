import 'dart:async';

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';
import 'package:tagros_comptes/tagros/domain/calculus.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';
import 'package:tagros_comptes/tagros/presentation/entry/entry_ui_state.dart';
import 'package:tagros_comptes/tagros/presentation/game_view_model.dart';

part 'entry_view_model.g.dart';

@Riverpod(dependencies: [currentGame, gamesDao, tableauViewModel])
class EntryViewModel extends _$EntryViewModel {
  EntryViewModel();

  @override
  Future<EntryUIState> build({int? roundId}) async {
    final gameCompleter = Completer<GameWithPlayers>();
    ref.watch(currentGameProvider.select(
      (value) => value.when(
          data: (data) {
            gameCompleter.complete(data);
          },
          error: (error, stack) {
            gameCompleter.completeError(error, stack);
          },
          loading: () {}),
    ));
    final game = await gameCompleter.future;
    final allPlayers = game.players;

    if (roundId != null) {
      final entry = await ref.watch(gamesDaoProvider).fetchEntry(roundId);
      if (allPlayers.length == 5) {
        return EntryUIState.fivePlayers(
          allPlayers: allPlayers.map((e) => PlayerBean.fromDb(e)).toList(),
          id: entry.infoEntry.id,
          taker: entry.player,
          partner1: entry.partner1,
          points: entry.infoEntry.points,
          petit: entry.infoEntry.nbBouts >= 1,
          vingtEtUn: entry.infoEntry.nbBouts >= 2,
          excuse: entry.infoEntry.nbBouts >= 3,
          prise: entry.infoEntry.prise,
          pointsForAttack: entry.infoEntry.pointsForAttack,
          petitAuBout: entry.infoEntry.petitsAuBout.displayablePetit,
          poignees:
              entry.infoEntry.poignees.displayablePoignees(allPlayers.length) ??
                  [null],
        );
      }
      if (allPlayers.length > 5) {
        return EntryUIState.tagros(
          allPlayers: allPlayers.map((e) => PlayerBean.fromDb(e)).toList(),
          id: entry.infoEntry.id,
          taker: entry.player,
          partner1: entry.partner1,
          partner2: entry.partner2,
          points: entry.infoEntry.points,
          petit: entry.infoEntry.nbBouts >= 1,
          vingtEtUn: entry.infoEntry.nbBouts >= 2,
          excuse: entry.infoEntry.nbBouts >= 3,
          petit2: entry.infoEntry.nbBouts >= 4,
          vingtEtUn2: entry.infoEntry.nbBouts >= 5,
          excuse2: entry.infoEntry.nbBouts >= 6,
          prise: entry.infoEntry.prise,
          pointsForAttack: entry.infoEntry.pointsForAttack,
          petitsAuBout: entry.infoEntry.petitsAuBout.displayablePetitsTagros,
          poignees:
              entry.infoEntry.poignees.displayablePoignees(allPlayers.length) ??
                  [null],
        );
      }
      return EntryUIState.classic(
        allPlayers: allPlayers.map((e) => PlayerBean.fromDb(e)).toList(),
        id: entry.infoEntry.id,
        taker: entry.player,
        points: entry.infoEntry.points,
        petit: entry.infoEntry.nbBouts >= 1,
        vingtEtUn: entry.infoEntry.nbBouts >= 2,
        excuse: entry.infoEntry.nbBouts >= 3,
        prise: entry.infoEntry.prise,
        pointsForAttack: entry.infoEntry.pointsForAttack,
        petitAuBout: entry.infoEntry.petitsAuBout.displayablePetit,
        poignees:
            entry.infoEntry.poignees.displayablePoignees(allPlayers.length) ??
                [null],
      );
    }
    final players = allPlayers.map((e) => PlayerBean.fromDb(e)).toList();
    if (allPlayers.length <= 4) {
      return EntryUIState.classic(
        allPlayers: players,
      );
    } else if (allPlayers.length == 5) {
      return EntryUIState.fivePlayers(
        allPlayers: players,
      );
    } else {
      return EntryUIState.tagros(
        allPlayers: players,
      );
    }
  }

  void setTaker(PlayerBean? player) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(taker: player));
  }

  /// Returns true if we can go to the next page
  bool setPartner1(PlayerBean? player) {
    final uiState = state.valueOrNull;
    if (uiState == null) return false;
    ({EntryUIState newState, bool nextPage}) record;

    record = uiState.maybeMap(
      tagros: (tagros) => (
        newState: tagros.copyWith(partner1: player),
        nextPage: tagros.partner2 != null
      ),
      fivePlayers: (fivePlayers) =>
          (newState: fivePlayers.copyWith(partner1: player), nextPage: true),
      orElse: () => throw StateError("We cannot set partner1 on classic game"),
    );

    state = AsyncData(record.newState);
    return record.nextPage;
  }

  /// Returns true if we can go to the next page
  bool setPartner2(PlayerBean? player) {
    final uiState = state.valueOrNull;
    if (uiState == null) return false;
    ({EntryUIState newState, bool nextPage}) record;

    record = uiState.maybeMap(
      tagros: (tagros) => (
        newState: tagros.copyWith(partner2: player),
        nextPage: tagros.partner1 != null
      ),
      orElse: () =>
          throw StateError("We cannot set partner2 when not in tagros"),
    );
    state = AsyncData(record.newState);
    return record.nextPage;
  }

  void setPoints(String value) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    double points = value.isEmpty ? 0 : double.tryParse(value) ?? 0;
    points = (points * 2).round() / 2;
    state = AsyncData(uiState.copyWith(points: points));
  }

  void setPointsDouble(double value) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    double correctPoints = value;
    if (value < 0) {
      correctPoints = 0;
    } else if (uiState.allPlayers.length <= 5 && value > 91) {
      correctPoints = 91;
    } else if (value > 182) {
      correctPoints = 182;
    }
    correctPoints = (correctPoints * 2).round() / 2;
    state = AsyncData(uiState.copyWith(points: correctPoints));
  }

  void setPrise(Prise prise) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(prise: prise));
  }

  void setPointsForAttack(bool pointsForAttack) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(pointsForAttack: pointsForAttack));
  }

  void setPetitAuBout(Camp? camp, int index) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.map(
      classic: (classic) => classic.copyWith(petitAuBout: camp),
      fivePlayers: (fivePlayers) => fivePlayers.copyWith(petitAuBout: camp),
      tagros: (tagros) {
        final p = tagros.petitsAuBout.toList();
        p[index] = camp;
        return tagros.copyWith(petitsAuBout: p);
      },
    ));
  }

  bool setPoignee(PoigneeType? poignee, int index) {
    final uiState = state.valueOrNull;
    if (uiState == null) return false;
    final p = uiState.poignees.toList();
    if (poignee == null) {
      p.removeAt(index);
    } else {
      p[index] = poignee;
    }

    final displayable = p.displayablePoignees(uiState.nbPlayers);
    if (displayable == null) {
      return false;
    }

    state = AsyncData(uiState.copyWith(poignees: displayable));
    return true;
  }

  void incrementPage() {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(page: uiState.page + 1));
  }

  void decrementPage() {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(page: uiState.page - 1));
  }

  bool showPartnerPage() {
    final uiState = state.valueOrNull;
    if (uiState == null) return false;
    return uiState.allPlayers.length >= 5;
  }

  bool showPartner2Page() {
    final uiState = state.valueOrNull;
    if (uiState == null) return false;
    return uiState.allPlayers.length >= 7;
  }

  bool _validate() {
    final uiState = state.valueOrNull;
    if (uiState == null) return false;
    return uiState.isValid;
  }

  /// returns:
  /// - first bool: saved - if the entry was saved
  /// - second bool: added - if the entry was added or modified
  (InfoEntryPlayerBean?, bool) saveEntry() {
    if (!_validate()) return (null, false);
    final uiState = state.valueOrNull;
    if (uiState == null) return (null, false);
    final entry = InfoEntryPlayerBean(
      infoEntry: InfoEntryBean(
        points: uiState.points,
        nbBouts: uiState.nbBoutsCalc,
        prise: uiState.prise!,
        pointsForAttack: uiState.pointsForAttack,
        petitsAuBout: uiState
            .map(
              classic: (classic) => [classic.petitAuBout],
              fivePlayers: (fivePlayers) => [fivePlayers.petitAuBout],
              tagros: (tagros) => tagros.petitsAuBout,
            )
            .whereNotNull()
            .toList(),
        poignees: uiState.poignees.whereNotNull().toList(),
        id: uiState.id,
      ),
      player: uiState.taker!,
      partner1: uiState.mapOrNull(
          fivePlayers: (fivePlayers) => fivePlayers.partner1,
          tagros: (tagros) => tagros.partner1),
      partner2: uiState.mapOrNull(tagros: (tagros) => tagros.partner2),
    );
    if (uiState.id != null) {
      ref.read(tableauViewModelProvider)?.modifyEntry(entry);
      return (entry, false);
    } else {
      ref.read(tableauViewModelProvider)?.addEntry(entry);
      return (entry, true);
    }
  }

  void setPage(int page) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    if (page != uiState.page) {
      state = AsyncData(uiState.copyWith(page: page));
    }
  }

  void setPetit(bool on, int index) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.map(
      classic: (classic) {
        assert(index == 0);
        return classic.copyWith(petit: on);
      },
      fivePlayers: (fivePlayers) {
        assert(index == 0);
        return fivePlayers.copyWith(petit: on);
      },
      tagros: (tagros) {
        if (index == 0) {
          return tagros.copyWith(petit: on);
        } else {
          return tagros.copyWith(petit2: on);
        }
      },
    ));
  }

  void setVingtEtUn(bool on, int index) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.map(
      classic: (classic) {
        assert(index == 0);
        return classic.copyWith(vingtEtUn: on);
      },
      fivePlayers: (fivePlayers) {
        assert(index == 0);
        return fivePlayers.copyWith(vingtEtUn: on);
      },
      tagros: (tagros) {
        if (index == 0) {
          return tagros.copyWith(vingtEtUn: on);
        } else {
          return tagros.copyWith(vingtEtUn2: on);
        }
      },
    ));
  }

  void setExcuse(bool on, int index) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.map(
      classic: (classic) {
        assert(index == 0);
        return classic.copyWith(excuse: on);
      },
      fivePlayers: (fivePlayers) {
        assert(index == 0);
        return fivePlayers.copyWith(excuse: on);
      },
      tagros: (tagros) {
        if (index == 0) {
          return tagros.copyWith(excuse: on);
        } else {
          return tagros.copyWith(excuse2: on);
        }
      },
    ));
  }

  void addPoignee(PoigneeType poignee) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    final p = uiState.poignees.toList();
    p.add(poignee);
    state = AsyncData(uiState.copyWith(poignees: p));
  }

  void removePoignee(PoigneeType poignee) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    final p = uiState.poignees.toList();
    p.remove(poignee);
    state = AsyncData(uiState.copyWith(poignees: p));
  }
}
