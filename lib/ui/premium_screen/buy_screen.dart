import 'package:flutter/material.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/ui/widget/background_gradient.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({Key? key}) : super(key: key);

  static const routeName = '/buy';

  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
        child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).buyScreenTitle),
      ),
      body: Center(
        child: Text(S.of(context).buyScreenPlaceholderText),
      ),
    ));
  }
}
