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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 2 : 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(package.packageType.displayName,
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(package.packageType.paidString,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(package.storeProduct.priceString,
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text(package.identifier),
                      Text(package.packageType.displayName),
                      Text(package.storeProduct.subscriptionPeriod.toString()),
                      Text(package.storeProduct.title),
                      Text(package.storeProduct.description,
                          style: Theme.of(context).textTheme.bodySmall),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  width: 16,
                  child: isSelected
                      ? Icon(Icons.check_circle,
                          color: Theme.of(context).primaryColor)
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
