import 'package:collection/collection.dart';

enum PoigneeType { simple, double, triple, none }

int getPoigneePoints(PoigneeType poigneeType) {
  switch (poigneeType) {
    case PoigneeType.simple:
      return 20;
    case PoigneeType.double:
      return 30;
    case PoigneeType.triple:
      return 40;
    case PoigneeType.none:
      return 0;
  }
}

int getNbAtouts(PoigneeType poigneeType, int nbPlayers) {
  switch (poigneeType) {
    case PoigneeType.simple:
      switch (nbPlayers) {
        case 3:
          return 13;
        case 4:
          return 10;
        case 5:
          return 8;
        case 7:
          return 11;
        case 8:
          return 9;
        case 9:
          return 7;
        case 10:
          return 7;
      }
      break;
    case PoigneeType.double:
      switch (nbPlayers) {
        case 3:
          return 15;
        case 4:
          return 13;
        case 5:
          return 10;
        case 7:
          return 13;
        case 8:
          return 11;
        case 9:
          return 9;
        case 10:
          return 9;
      }
      break;
    case PoigneeType.triple:
      switch (nbPlayers) {
        case 3:
          return 18;
        case 4:
          return 15;
        case 5:
          return 13;
        case 7:
          return 15;
        case 8:
          return 13;
        case 9:
          return 12;
        case 10:
          return 11;
      }
      break;
    case PoigneeType.none:
      return 0;
  }
  return 0;
}

extension PoigneExtension on PoigneeType {
  String get displayName {
    switch(this) {
      case PoigneeType.simple:
        return "simple";
      case PoigneeType.double:
        return "double";
      case PoigneeType.triple:
        return "triple";
      case PoigneeType.none:
        return "non";
    }
  }
}

const String _simple = "SIMPLE";
const String _double = "DOUBLE";
const String _triple = "TRIPLE";
const String _none = "NONE";

String? toDbPoignees(List<PoigneeType> poignees) => poignees.isEmpty
    ? null
    : poignees
        .map((e) {
          switch (e) {
            case PoigneeType.simple:
              return _simple;
            case PoigneeType.double:
              return _double;
            case PoigneeType.triple:
              return _triple;
            case PoigneeType.none:
              return null;
          }
        })
        .whereNotNull()
        .join(",");

List<PoigneeType> fromDbPoignee(String? poignees) {
  if (poignees == null || poignees.isEmpty) return [];
  return poignees
      .split(",")
      .map((e) {
        switch (e) {
          case _simple:
            return PoigneeType.simple;
          case _double:
            return PoigneeType.double;
          case _triple:
            return PoigneeType.triple;
          case _none:
            return null;
        }
        return null;
      })
      .whereNotNull()
      .toList();
}
