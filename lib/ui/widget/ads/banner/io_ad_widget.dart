import 'package:flutter/material.dart';
import 'package:tagros_comptes/ui/widget/ads/banner/mobile_ad_widget.dart';
import 'package:universal_platform/universal_platform.dart';

class CrossAdWidget extends StatelessWidget {
  const CrossAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isDesktop) return const SizedBox();
    if (UniversalPlatform.isAndroid) return const MobileAdWidget();
    return const SizedBox();
  }
}
