extension PointsFormatter on num {
  String get toPoints {
    if (isInteger) {
      return toInt().toString();
    }
    return toStringAsFixed(1);
  }

  bool get isInteger => this is int || this == roundToDouble();
}
