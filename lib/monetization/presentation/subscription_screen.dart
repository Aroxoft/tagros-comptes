import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/monetization/presentation/error_mapper.dart';
import 'package:tagros_comptes/monetization/presentation/package_card.dart';
import 'package:tagros_comptes/monetization/presentation/subscription_view_model.dart';

class SubscriptionScreen extends HookConsumerWidget {
  const SubscriptionScreen({super.key});

  static const routeName = '/buy';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionVM = ref.watch(subscriptionViewModelProvider.notifier);
    final subscriptionState = ref.watch(subscriptionViewModelProvider);
    useEffect(() {
      Future.microtask(() {
        ref.read(_messageProvider.notifier).state =
            subscriptionState.temporaryError?.message;
      });
      return null;
    }, [
      ref.watch(
          subscriptionViewModelProvider.select((value) => value.temporaryError))
    ]);
    ref.listen(_messageProvider, (previous, next) {
      if (next != null && next != previous) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
        ref.read(_messageProvider.notifier).state = null;
      }
    });
    return BackgroundGradient(
        child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).buyScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/logo_small.png",
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Premium",
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              ),
            ),
            TextButton(
                onPressed: () {
                  subscriptionVM.restorePurchase();
                },
                child: const Text("Restaurer les achats")),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(3),
              },
              children: const [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.app_blocking, size: 40),
                  ),
                  Text("Pas de pub", style: TextStyle(fontSize: 16)),
                ]),
                TableRow(children: [
                  Icon(Icons.draw, size: 40),
                  Text("Plus de thèmes", style: TextStyle(fontSize: 16)),
                ]),
                TableRow(children: [
                  Icon(Icons.auto_graph, size: 40),
                  Text("Graphes de statistiques",
                      style: TextStyle(fontSize: 16)),
                ]),
                TableRow(children: [
                  Icon(Icons.auto_awesome, size: 40),
                  Text("Soutien au développeur",
                      style: TextStyle(fontSize: 16)),
                ]),
              ],
            ),
            if (subscriptionState.isPro)
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: const Text("Vous êtes abonné"),
                )),
              ),
            if (subscriptionState.isLoading)
              const Center(child: CircularProgressIndicator()),
            if (subscriptionState.hasError)
              Text(subscriptionState.error!.message),
            Flexible(
              child: ListView.builder(
                  itemCount: subscriptionState.packages.length,
                  itemBuilder: (context, index) {
                    final package = subscriptionState.packages[index];
                    return PackageCard(
                      isSelected: subscriptionState.selectedPackage == package,
                      package: package,
                      onTap: () {
                        subscriptionVM.selectPackage(package);
                      },
                    );
                  }),
            ),
            // PackageCard(package: _fakePackage, isSelected: true),
            if (subscriptionState.selectedPackage != null)
              ElevatedButton.icon(
                  onPressed: () {
                    subscriptionVM.buy(subscriptionState.selectedPackage!);
                  },
                  icon: const Icon(Icons.flash_on),
                  label: const Text("Obtenez premium")),
            const Text('Facturation récurrente, annulable à tout moment. '
                'Les abonnements sont gérés par Google Play.'),
          ],
        ),
      ),
    ));
  }
}

final _messageProvider = StateProvider<String?>((ref) {
  return null;
});
