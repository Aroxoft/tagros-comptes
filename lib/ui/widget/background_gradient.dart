import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/state/providers.dart';

class BackgroundGradient extends ConsumerWidget {
  const BackgroundGradient({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgGradient1 = ref.watch(themeColorProvider).maybeWhen(
          data: (data) => data.backgroundGradient1,
          orElse: () => Colors.transparent,
        );
    final bgGradient2 = ref.watch(themeColorProvider).maybeWhen(
          data: (data) => data.backgroundGradient2,
          orElse: () => Colors.transparent,
        );
    if (bgGradient1 == Colors.transparent &&
        bgGradient2 == Colors.transparent) {
      return child;
    }
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgGradient1, bgGradient2])),
      child: child,
    );
  }
}
