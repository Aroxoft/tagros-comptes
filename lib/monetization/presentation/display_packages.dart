import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:tagros_comptes/monetization/presentation/package_card.dart';

class DisplayPackages extends StatelessWidget {
  const DisplayPackages({
    super.key,
    required this.packages,
    required this.onSelect,
    required this.selected,
  });

  final List<Package> packages;
  final void Function(Package package) onSelect;
  final Package? selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 182,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final package = packages[index];
            return PackageCard(
              isSelected: selected == package,
              package: package,
              onTap: () {
                if (selected != package) {
                  onSelect(package);
                }
              },
            );
          }),
    );
  }
}
