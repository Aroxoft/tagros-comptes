import 'dart:math';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:tagros_comptes/monetization/presentation/package_type_mapper.dart';

class PackageCard extends StatelessWidget {
  final Package package;
  final VoidCallback? onTap;
  final bool isSelected;

  const PackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 180,
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            elevation: isSelected ? 4 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: isSelected
                  ? BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2)
                  : BorderSide.none,
            ),
            child: SizedBox(
              width: min(100, MediaQuery.of(context).size.width * 0.3),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 75,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          package.packageType.displayName(context),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              package.storeProduct.priceString,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            Text(package.packageType.paidString(context),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
