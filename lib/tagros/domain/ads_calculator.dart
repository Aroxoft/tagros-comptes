const int _kAdInterval = 10;
const int _kAdStart = 5;

class AdsCalculator {
  final int _adInterval;
  final int _adStart;
  final bool _ignoreAds;

  AdsCalculator(
      {int adInterval = _kAdInterval,
      int adStart = _kAdStart,
      required bool ignoreAds})
      : _adInterval = adInterval,
        _adStart = adStart,
        _ignoreAds = ignoreAds;

  /// Returns true if the given index should be an ad, false otherwise.
  /// The first and last items are never ads.
  /// The first ad is shown after the 5th item.
  /// Every 10th item after that is an ad.
  bool isAd({required int index, required int fullSize}) {
    if (_ignoreAds) {
      return false;
    }
    if (index == 0 || index == fullSize - 1) {
      return false;
    }
    if (index == _adStart || (index - _adStart) % _adInterval == 0) {
      return true;
    }
    return false;
  }

  /// Returns the index of the item in the list that should be shown at the given position.
  int? getItemIndex({required int position, required int fullSize}) {
    if (_ignoreAds) {
      return position;
    }
    if (isAd(index: position, fullSize: fullSize)) {
      return null;
    }
    if (position < _adStart) {
      return position;
    }
    final int adCount = (position - _adStart) ~/ _adInterval;
    return position - adCount - 1;
  }

  /// Returns the size of the list with ads.
  /// This is used to set the size of the ListView.
  int getFullListSize({required int itemsSize}) {
    if (_ignoreAds) {
      return itemsSize;
    }
    if (itemsSize <= _adStart) {
      return itemsSize;
    }
    final int adCount = (itemsSize - _adStart - 1) ~/ (_adInterval - 1) + 1;
    return itemsSize + adCount;
  }
}
