import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';
import 'package:tagros_comptes/tagros/presentation/game_view_model.dart';

part 'entry_view_model.freezed.dart';
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
      return EntryUIState(
        allPlayers: allPlayers.map((e) => PlayerBean.fromDb(e)).toList(),
        id: entry.infoEntry.id,
        taker: entry.player,
        partner1: entry.withPlayers?.firstOrNull,
        partner2: entry.withPlayers?.length == 2
            ? entry.withPlayers?.lastOrNull
            : null,
        points: entry.infoEntry.points,
        nbBouts: entry.infoEntry.nbBouts,
        prise: entry.infoEntry.prise,
        pointsForAttack: entry.infoEntry.pointsForAttack,
        petitsAuBout: entry.infoEntry.petitsAuBout,
        poignees: entry.infoEntry.poignees,
      );
    }

    final player1 = allPlayers.firstOrNull;
    final playerBean = player1 != null ? PlayerBean.fromDb(player1) : null;
    return EntryUIState(
      allPlayers:
          allPlayers.map((e) => PlayerBean.fromDb(e)).whereNotNull().toList(),
      taker: playerBean,
      partner1: allPlayers.length >= 5 ? playerBean : null,
      partner2: allPlayers.length >= 7 ? playerBean : null,
    );
  }

  void setTaker(PlayerBean? player) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(taker: player));
  }

  void setPartner1(PlayerBean? player) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(partner1: player));
  }

  void setPartner2(PlayerBean? player) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(partner2: player));
  }

  void setPoints(String value) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    double points = value.isEmpty ? 0 : double.tryParse(value) ?? 0;
    points = (points * 2).round() / 2;
    state = AsyncData(uiState.copyWith(points: points));
  }

  void setNbBouts(int nbBouts) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(nbBouts: nbBouts));
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

  void setPetitsAuBout(List<Camp> petitsAuBout) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(petitsAuBout: petitsAuBout));
  }

  void switchPetitAuBout(bool on) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    var p = uiState.petitsAuBout.toList();
    if (p.isEmpty) {
      p = [Camp.attack];
    }
    p[0] = on ? Camp.attack : Camp.none;
    state = AsyncData(uiState.copyWith(petitsAuBout: p));
  }

  void setPetitAuBout(Camp camp) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    var p = uiState.petitsAuBout.toList();
    if (p.isEmpty) {
      p = [camp];
    } else {
      p[0] = camp;
    }
    state = AsyncData(uiState.copyWith(petitsAuBout: p));
  }

  void switchPoignee(bool on) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    final p = uiState.poignees.toList();
    if (p.isEmpty) {
      p.add(PoigneeType.simple);
    }
    p[0] = on ? PoigneeType.simple : PoigneeType.none;
    setPoignees(p);
  }

  void setPoignee(PoigneeType poignee) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    final p = uiState.poignees.toList();
    if (p.isEmpty) {
      p.add(poignee);
    } else {
      p[0] = poignee;
    }
    setPoignees(p);
  }

  void setPoignees(List<PoigneeType> poignees) {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(uiState.copyWith(poignees: poignees));
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

  void clear() {
    final uiState = state.valueOrNull;
    if (uiState == null) return;
    state = AsyncData(EntryUIState(allPlayers: uiState.allPlayers));
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
    if (uiState.taker == null) return false;

    // todo check if nb points are not too high
    if (uiState.points < 0) return false;
    if (uiState.nbBouts < 0) return false;

    if (uiState.allPlayers.length < 5) return true;
    if (uiState.partner1 == null && uiState.allPlayers.length >= 5) {
      return false;
    }
    if (uiState.partner2 == null && uiState.allPlayers.length >= 7) {
      return false;
    }
    return true;
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
        nbBouts: uiState.nbBouts,
        prise: uiState.prise,
        pointsForAttack: uiState.pointsForAttack,
        petitsAuBout: uiState.petitsAuBout,
        poignees: uiState.poignees,
        id: uiState.id,
      ),
      player: uiState.taker!,
      withPlayers: uiState.partner1 == null
          ? null
          : uiState.partner2 == null
              ? [uiState.partner1]
              : [uiState.partner1, uiState.partner2],
    );
    if (uiState.id != null) {
      ref.read(tableauViewModelProvider)?.modifyEntry(entry);
      return (entry, false);
    } else {
      ref.read(tableauViewModelProvider)?.addEntry(entry);
      return (entry, true);
    }
  }
}

@freezed
class EntryUIState with _$EntryUIState {
  factory EntryUIState({
    required List<PlayerBean> allPlayers,
    PlayerBean? taker,
    PlayerBean? partner1,
    PlayerBean? partner2,
    @Default(0) double points,
    @Default(0) int nbBouts,
    @Default(Prise.petite) Prise prise,
    @Default(true) bool pointsForAttack,
    @Default(<Camp>[]) List<Camp> petitsAuBout,
    @Default(<PoigneeType>[]) List<PoigneeType> poignees,
    @Default(0) int page,
    int? id,
  }) = _EntryUIState;

  EntryUIState._();

  bool get showPartnerPage => allPlayers.length >= 5;

  bool get showPartner2Page => allPlayers.length >= 7;
}
