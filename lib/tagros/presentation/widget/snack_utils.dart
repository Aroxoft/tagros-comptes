import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';

void displayFlushbar(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String message,
}) {
  final theme = ref.read(themeColorProvider).maybeWhen(
        data: (data) => data,
        orElse: () => ThemeColor.defaultTheme(),
      );
  Flushbar(
    flushbarStyle: FlushbarStyle.GROUNDED,
    flushbarPosition: FlushbarPosition.TOP,
    title: title,
    duration: const Duration(seconds: 2),
    titleColor: theme.textColor,
    messageColor: theme.textColor,
    message: message,
    backgroundGradient: LinearGradient(
      colors: [
        if (theme.backgroundGradient1.opacity != 0)
          theme.backgroundGradient1
        else
          theme.averageBackgroundColor.darken(0.3),
        if (theme.backgroundGradient2.opacity != 0)
          theme.backgroundGradient2
        else
          theme.averageBackgroundColor.lighten(0.3),
      ],
    ),
  ).show(context);
}
