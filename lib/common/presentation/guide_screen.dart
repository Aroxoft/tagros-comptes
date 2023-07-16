import 'package:flutter/material.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

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
