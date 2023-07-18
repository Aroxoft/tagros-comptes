import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';

class Boxed extends ConsumerWidget {
  final double borderWidth;
  final double radius;

  final Widget child;

  final String title;

  final FontWeight titleWeight;
  final double titleSize;

  const Boxed(
      {super.key,
      this.borderWidth = 3,
      this.radius = 20,
      required this.child,
      required this.title,
      this.titleWeight = FontWeight.w700,
      this.titleSize = 18});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frameColor = ref.watch(themeColorProvider.select((value) =>
        value.whenOrNull(data: (data) => data.frameColor) ??
        Colors.transparent));
    final fillColor = ref.watch(themeColorProvider.select(
        (value) => value.whenOrNull(data: (data) => data.backgroundColor)));
    final fillTitleColor = ref.watch(themeColorProvider.select((value) =>
        value.whenOrNull(data: (data) => data.averageBackgroundColor)));

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: frameColor, width: borderWidth),
                borderRadius: BorderRadius.circular(radius),
                color: fillColor),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 18, right: 10, left: 10, bottom: 20),
              child: child,
            ),
          ),
        ),
        Positioned(
            left: 20,
            top: 5,
            child: Container(
              padding:
                  const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
              decoration: fillTitleColor != fillColor
                  ? BoxDecoration(
                      border: Border.all(color: frameColor, width: borderWidth),
                      borderRadius: BorderRadius.circular(radius / 2),
                      color: fillTitleColor)
                  : null,
              color: fillTitleColor == fillColor ? fillTitleColor : null,
              child: Text(
                title,
                style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: titleWeight,
                    color: frameColor),
              ),
            ))
      ],
    );
  }
}
