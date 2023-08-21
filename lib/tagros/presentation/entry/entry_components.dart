import 'dart:math';

import 'package:flutter/material.dart';

class BoundedSeparatedListView extends StatelessWidget {
  final List<Widget> children;
  final double maxHeightItem;
  final double minHeightItem;
  final double separatorHeight;
  final double paddingTop;
  final double paddingBottom;

  const BoundedSeparatedListView({
    required this.children,
    this.maxHeightItem = 120,
    this.separatorHeight = 10,
    this.minHeightItem = 60,
    this.paddingTop = 36,
    this.paddingBottom = 36,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final maxHeight = constraints.maxHeight;
      final height = max(
          minHeightItem,
          min(
              maxHeightItem,
              (maxHeight -
                      separatorHeight * (children.length - 1) -
                      paddingTop -
                      paddingBottom) /
                  children.length));
      return ListView.separated(
          padding: EdgeInsets.only(
              top: paddingTop, bottom: paddingBottom, left: 20, right: 20),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: height,
              child: children[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(height: separatorHeight),
          itemCount: children.length);
    });
  }
}

class BoundedSeparatedHorizontalListView extends StatelessWidget {
  final List<Widget> children;
  final double maxWidthItem;
  final double minWidthItem;
  final double separatorWidth;
  final double paddingLeft;
  final double paddingRight;

  const BoundedSeparatedHorizontalListView({
    super.key,
    required this.children,
    this.maxWidthItem = 100,
    this.minWidthItem = 40,
    this.separatorWidth = 5,
    this.paddingLeft = 16,
    this.paddingRight = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final maxWidth = constraints.maxWidth;
      final width = max(
          minWidthItem,
          min(
              maxWidthItem,
              (maxWidth -
                      separatorWidth * (children.length - 1) -
                      paddingLeft -
                      paddingRight) /
                  children.length));
      return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
              left: paddingLeft, right: paddingRight, top: 8, bottom: 8),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: width,
              child: children[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(width: separatorWidth),
          itemCount: children.length);
    });
  }
}

class Headline extends StatelessWidget {
  final String text;

  const Headline({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Text(text, style: Theme.of(context).textTheme.displayMedium),
    );
  }
}
