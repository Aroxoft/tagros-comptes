import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  patrol('go to themes screen smoke test', ($) async {
    await createApp($);
    expect($('New game'), findsOneWidget);
    expect($('Continue'), findsOneWidget);
    expect($('Settings'), findsNothing);

    await $(Icons.settings).tap();
    await $('Settings').waitUntilVisible();

    expect($('New game'), findsNothing);
    expect($('Continue'), findsNothing);

    await $('Theme').tap();

    expect($('Classic'), findsOneWidget);
    expect($('Chocolate'), findsOneWidget);

    await $('Chocolate').tap();

    expect($('Chocolate'), findsOneWidget);
    expect($('Classic'), findsOneWidget);
  });
}
