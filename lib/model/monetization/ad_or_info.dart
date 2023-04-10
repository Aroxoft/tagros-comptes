import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tagros_comptes/model/game/info_entry_player.dart';

part 'ad_or_info.freezed.dart';

@freezed
class AdOrInfo with _$AdOrInfo {
  factory AdOrInfo.ad({required Future<AdWithView> ad}) = _Ad;

  factory AdOrInfo.info({required InfoEntryPlayerBean infoEntryPlayerBean}) =
      _Info;
}
