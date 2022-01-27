import 'package:flutter/material.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/ui/widget/background_gradient.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({Key? key}) : super(key: key);
  static const routeName = '/guide';

  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
        child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).guideTitle),
      ),
      body: Center(
        child: Text(S.of(context).guidePlaceHolderText),
      ),
    ));
  }
}
