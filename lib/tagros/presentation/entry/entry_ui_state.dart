import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagros_comptes/tagros/domain/calculus.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';

part 'entry_ui_state.freezed.dart';

@freezed
class EntryUIState with _$EntryUIState {
  factory EntryUIState.classic({
    required List<PlayerBean> allPlayers,
    PlayerBean? taker,
    @Default(0) double points,
    @Default(false) bool petit,
    @Default(false) bool vingtEtUn,
    @Default(false) bool excuse,
    Prise? prise,
    @Default(true) bool pointsForAttack,
    @Default(null) Camp? petitAuBout,
    @Default(<PoigneeType?>[null]) List<PoigneeType?> poignees,
    @Default(0) int page,
    int? id,
  }) = _EntryClassic;

  factory EntryUIState.fivePlayers({
    required List<PlayerBean> allPlayers,
    PlayerBean? taker,
    PlayerBean? partner1,
    @Default(0) double points,
    @Default(false) bool petit,
    @Default(false) bool vingtEtUn,
    @Default(false) bool excuse,
    Prise? prise,
    @Default(true) bool pointsForAttack,
    @Default(null) Camp? petitAuBout,
    @Default(<PoigneeType?>[null]) List<PoigneeType?> poignees,
    @Default(0) int page,
    int? id,
  }) = _EntryFivePlayers;

  factory EntryUIState.tagros({
    required List<PlayerBean> allPlayers,
    PlayerBean? taker,
    PlayerBean? partner1,
    PlayerBean? partner2,
    @Default(0) double points,
    @Default(false) bool petit,
    @Default(false) bool vingtEtUn,
    @Default(false) bool excuse,
    @Default(false) bool petit2,
    @Default(false) bool vingtEtUn2,
    @Default(false) bool excuse2,
    @Deprecated("do not use anymore") @Default(0) int nbBouts,
    Prise? prise,
    @Default(true) bool pointsForAttack,
    @Default(<Camp?>[null, null]) List<Camp?> petitsAuBout,
    @Default(<PoigneeType?>[null]) List<PoigneeType?> poignees,
    @Default(0) int page,
    int? id,
  }) = _EntryUIState;

  EntryUIState._();

  int get nbBoutsCalc {
    final sum1 = (petit ? 1 : 0) + (vingtEtUn ? 1 : 0) + (excuse ? 1 : 0);
    return map(
        classic: (classic) => sum1,
        fivePlayers: (fivePlayers) => sum1,
        tagros: (tagros) =>
            sum1 +
            (tagros.petit2 ? 1 : 0) +
            (tagros.vingtEtUn2 ? 1 : 0) +
            (tagros.excuse2 ? 1 : 0));
  }

  int get nbPlayers => allPlayers.length;

  bool get tagros => map(
      classic: (classic) => false,
      fivePlayers: (fivePlayers) => false,
      tagros: (tagros) => true);

  bool get showPartnerPage => map(
      classic: (classic) => false,
      fivePlayers: (fivePlayers) => true,
      tagros: (tagros) => true);

  bool get showPartner2Page => map(
      classic: (classic) => false,
      fivePlayers: (fivePlayers) => false,
      tagros: (tagros) => true);

  bool get nextPageEnabled {
    switch (page) {
      case 0:
        return prise != null;
      case 1:
        return taker != null;
      case 2:
        return map(
            classic: (classic) => true,
            fivePlayers: (fivePlayers) => fivePlayers.partner1 != null,
            tagros: (tagros) =>
                tagros.partner1 != null && tagros.partner2 != null);
      default:
        return false;
    }
  }

  bool get isValid {
    if (taker == null) return false;

    if (points < 0) return false;
    if (nbBoutsCalc < 0) return false;
    if (!poignees.isValid(nbPlayers)) return false;

    return map(
        classic: (classic) => points <= 91,
        fivePlayers: (fivePlayers) =>
            points <= 91 && fivePlayers.partner1 != null,
        tagros: (tagros) =>
            points <= 182 &&
            tagros.partner1 != null &&
            tagros.partner2 != null);
  }
}
