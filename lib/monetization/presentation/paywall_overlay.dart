import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/navigation/routes.dart';

class PaywallOverlay extends StatelessWidget {
  final Widget child;
  final bool isPremium;

  const PaywallOverlay({
    super.key,
    required this.child,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (!isPremium)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
              child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.05),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(S
                                .of(context)
                                .subscription_paywall_premiumFeature_message),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                const SubscriptionRoute().push(context);
                              },
                              icon: const Icon(Icons.diamond_outlined),
                              label: Text(S
                                  .of(context)
                                  .subscription_paywall_premiumFeature_button),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          ),
      ],
    );
  }
}
