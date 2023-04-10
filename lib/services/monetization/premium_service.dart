import 'package:hooks_riverpod/hooks_riverpod.dart';

class PremiumService extends StateNotifier<bool> {
  PremiumService() : super(false);

  void buyPremium() {
    state = true;
  }

  void rescindOffer() {
    state = false;
  }
}
