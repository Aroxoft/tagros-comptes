import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';

class BackgroundGradient extends ConsumerWidget {
  const BackgroundGradient({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgGradient1 =
        ref.watch(themeColorProvider.select((value) => value.maybeWhen(
              data: (data) => data.backgroundGradient1,
              orElse: () => Colors.transparent,
            )));
    final bgGradient2 =
        ref.watch(themeColorProvider.select((value) => value.maybeWhen(
              data: (data) => data.backgroundGradient2,
              orElse: () => Colors.transparent,
            )));
    if (bgGradient1.a == 0 && bgGradient2.a == 0) {
      return child;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgGradient1, bgGradient2])),
      child: child,
    );
  }
}
