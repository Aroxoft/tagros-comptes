import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';

part 'player.freezed.dart';

@freezed
class PlayerBean with _$PlayerBean {
  factory PlayerBean({required String name, int? id}) = _PlayerBean;

  PlayerBean._();

  factory PlayerBean.fromDb(Player player) => PlayerBean(
        name: player.pseudo,
        id: player.id,
      );

  @override
  String toString() {
    return "$name ($id)";
  }

  Player get toDb => Player(pseudo: name, id: id);
}
