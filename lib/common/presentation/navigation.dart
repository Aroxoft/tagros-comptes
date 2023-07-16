import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/tagros/presentation/tableau.dart';

Future<void> navigateToTableau(BuildContext context) async {
  await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ProviderScope(
      parent: ProviderScope.containerOf(context),
      child: const TableauPage(),
    ),
  ));
}
