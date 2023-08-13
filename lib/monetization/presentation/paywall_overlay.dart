import 'dart:ui';

import 'package:flutter/material.dart';
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
                  color: Colors.black.withOpacity(0.05),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "This is a premium feature. Go premium to unlock this feature"),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                const SubscriptionRoute().push(context);
                              },
                              icon: Icon(Icons.diamond_outlined),
                              label: Text("Go pro"),
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
