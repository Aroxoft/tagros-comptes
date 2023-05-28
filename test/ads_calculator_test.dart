import 'package:flutter_test/flutter_test.dart';
import 'package:tagros_comptes/ui/table_screen/ads_calculator.dart';

void main() {
  /// test that the function isAd returns the right value for the given input
  group('Given an interval of 10 and a start offset of 5', () {
    final adsCalculator = AdsCalculator(adInterval: 10, adStart: 5);

    group('isAd works correctly', () {
      /// test that each value of the index returns the right value for isAd
      final tests = [
        _IsAdTestCase(position: 0, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 1, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 2, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 3, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 4, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 5, fullSize: 20, resIsAd: true),
        _IsAdTestCase(position: 6, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 7, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 8, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 9, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 10, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 11, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 12, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 13, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 14, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 15, fullSize: 20, resIsAd: true),
        _IsAdTestCase(position: 16, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 17, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 18, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 19, fullSize: 20, resIsAd: false),
        _IsAdTestCase(position: 15, fullSize: 17, resIsAd: true),
        _IsAdTestCase(position: 5, fullSize: 7, resIsAd: true),
        _IsAdTestCase(position: 5, fullSize: 8, resIsAd: true),
        _IsAdTestCase(position: 0, fullSize: 1, resIsAd: false),
        _IsAdTestCase(position: 25, fullSize: 27, resIsAd: true),
        _IsAdTestCase(position: 26, fullSize: 27, resIsAd: false),
        _IsAdTestCase(position: 27, fullSize: 28, resIsAd: false),
      ];
      for (final testCase in tests) {
        test(
            'When the index is ${testCase.position} and size is ${testCase.fullSize}, then the result is ${testCase.resIsAd}',
            () {
          expect(
              adsCalculator.isAd(
                  index: testCase.position, fullSize: testCase.fullSize),
              equals(testCase.resIsAd));
        });
      }
    });

    group('getItemIndex works correctly ', () {
      final tests = [
        _GetItemIndexTestCase(position: 0, fullSize: 20, resIndexItem: 0),
        _GetItemIndexTestCase(position: 1, fullSize: 20, resIndexItem: 1),
        _GetItemIndexTestCase(position: 2, fullSize: 20, resIndexItem: 2),
        _GetItemIndexTestCase(position: 3, fullSize: 20, resIndexItem: 3),
        _GetItemIndexTestCase(position: 4, fullSize: 17, resIndexItem: 4),
        _GetItemIndexTestCase(position: 5, fullSize: 17, resIndexItem: null),
        _GetItemIndexTestCase(position: 6, fullSize: 17, resIndexItem: 5),
        _GetItemIndexTestCase(position: 7, fullSize: 17, resIndexItem: 6),
        _GetItemIndexTestCase(position: 8, fullSize: 17, resIndexItem: 7),
        _GetItemIndexTestCase(position: 9, fullSize: 17, resIndexItem: 8),
        _GetItemIndexTestCase(position: 10, fullSize: 17, resIndexItem: 9),
        _GetItemIndexTestCase(position: 11, fullSize: 17, resIndexItem: 10),
        _GetItemIndexTestCase(position: 12, fullSize: 17, resIndexItem: 11),
        _GetItemIndexTestCase(position: 13, fullSize: 17, resIndexItem: 12),
        _GetItemIndexTestCase(position: 14, fullSize: 17, resIndexItem: 13),
        _GetItemIndexTestCase(position: 15, fullSize: 17, resIndexItem: null),
        _GetItemIndexTestCase(position: 16, fullSize: 17, resIndexItem: 14),
        _GetItemIndexTestCase(position: 17, fullSize: 17, resIndexItem: 15),
        _GetItemIndexTestCase(position: 18, fullSize: 19, resIndexItem: 16),
        _GetItemIndexTestCase(position: 26, fullSize: 27, resIndexItem: 23),
        _GetItemIndexTestCase(position: 27, fullSize: 28, resIndexItem: 24),
      ];
      for (final testCase in tests) {
        test(
            'When the position is ${testCase.position} and size is ${testCase.fullSize}, then the result is ${testCase.resIndexItem}',
            () {
          expect(
              adsCalculator.getItemIndex(
                  position: testCase.position, fullSize: testCase.fullSize),
              equals(testCase.resIndexItem));
        });
      }
    });

    group('getFullListSize works correctly', () {
      final tests = [
        _GetFullListSizeTestCase(itemSize: 0, resFullSize: 0),
        _GetFullListSizeTestCase(itemSize: 1, resFullSize: 1),
        _GetFullListSizeTestCase(itemSize: 2, resFullSize: 2),
        _GetFullListSizeTestCase(itemSize: 3, resFullSize: 3),
        _GetFullListSizeTestCase(itemSize: 4, resFullSize: 4),
        _GetFullListSizeTestCase(itemSize: 5, resFullSize: 5),
        _GetFullListSizeTestCase(itemSize: 6, resFullSize: 7),
        _GetFullListSizeTestCase(itemSize: 7, resFullSize: 8),
        _GetFullListSizeTestCase(itemSize: 8, resFullSize: 9),
        _GetFullListSizeTestCase(itemSize: 9, resFullSize: 10),
        _GetFullListSizeTestCase(itemSize: 10, resFullSize: 11),
        _GetFullListSizeTestCase(itemSize: 11, resFullSize: 12),
        _GetFullListSizeTestCase(itemSize: 12, resFullSize: 13),
        _GetFullListSizeTestCase(itemSize: 13, resFullSize: 14),
        _GetFullListSizeTestCase(itemSize: 14, resFullSize: 15),
        _GetFullListSizeTestCase(itemSize: 15, resFullSize: 17),
        _GetFullListSizeTestCase(itemSize: 16, resFullSize: 18),
        _GetFullListSizeTestCase(itemSize: 17, resFullSize: 19),
        _GetFullListSizeTestCase(itemSize: 18, resFullSize: 20),
        _GetFullListSizeTestCase(itemSize: 19, resFullSize: 21),
        _GetFullListSizeTestCase(itemSize: 20, resFullSize: 22),
        _GetFullListSizeTestCase(itemSize: 21, resFullSize: 23),
        _GetFullListSizeTestCase(itemSize: 22, resFullSize: 24),
        _GetFullListSizeTestCase(itemSize: 23, resFullSize: 25),
        _GetFullListSizeTestCase(itemSize: 24, resFullSize: 27),
        _GetFullListSizeTestCase(itemSize: 25, resFullSize: 28),
        _GetFullListSizeTestCase(itemSize: 26, resFullSize: 29),
        _GetFullListSizeTestCase(itemSize: 27, resFullSize: 30),
        _GetFullListSizeTestCase(itemSize: 28, resFullSize: 31),
        _GetFullListSizeTestCase(itemSize: 29, resFullSize: 32),
        _GetFullListSizeTestCase(itemSize: 30, resFullSize: 33),
        _GetFullListSizeTestCase(itemSize: 31, resFullSize: 34),
        _GetFullListSizeTestCase(itemSize: 32, resFullSize: 35),
        _GetFullListSizeTestCase(itemSize: 33, resFullSize: 37),
        _GetFullListSizeTestCase(itemSize: 34, resFullSize: 38),
        _GetFullListSizeTestCase(itemSize: 35, resFullSize: 39),
        _GetFullListSizeTestCase(itemSize: 36, resFullSize: 40),
        _GetFullListSizeTestCase(itemSize: 37, resFullSize: 41),
        _GetFullListSizeTestCase(itemSize: 38, resFullSize: 42),
        _GetFullListSizeTestCase(itemSize: 39, resFullSize: 43),
        _GetFullListSizeTestCase(itemSize: 40, resFullSize: 44),
        _GetFullListSizeTestCase(itemSize: 41, resFullSize: 45),
        _GetFullListSizeTestCase(itemSize: 42, resFullSize: 47),
      ];
      for (final testCase in tests) {
        test(
            'When the size is ${testCase.itemSize}, then the result is ${testCase.resFullSize}',
            () {
          expect(adsCalculator.getFullListSize(itemsSize: testCase.itemSize),
              equals(testCase.resFullSize));
        });
      }
    });
  });
}

class _IsAdTestCase {
  final int position;
  final int fullSize;
  final bool resIsAd;

  _IsAdTestCase({
    required this.position,
    required this.fullSize,
    required this.resIsAd,
  });
}

class _GetItemIndexTestCase {
  final int position;
  final int fullSize;
  final int? resIndexItem;

  _GetItemIndexTestCase({
    required this.position,
    required this.fullSize,
    required this.resIndexItem,
  });
}

class _GetFullListSizeTestCase {
  final int itemSize;
  final int resFullSize;

  _GetFullListSizeTestCase({
    required this.itemSize,
    required this.resFullSize,
  });
}
