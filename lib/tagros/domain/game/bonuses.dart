import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';

part 'bonuses.freezed.dart';

@freezed
class BonusType with _$BonusType {
  factory BonusType.poignee({
    required PoigneeType poigneeType,
  }) = _BonusTypePoignee;

  factory BonusType.petitAuBout({
    required bool forAttack,
  }) = _BonusTypePetitAuBout;
}
