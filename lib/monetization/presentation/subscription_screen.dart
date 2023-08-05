import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/monetization/presentation/error_mapper.dart';
import 'package:tagros_comptes/monetization/presentation/subscription_view_model.dart';

class SubscriptionScreen extends HookConsumerWidget {
  const SubscriptionScreen({super.key});

  static const routeName = '/buy';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionVM = ref.watch(subscriptionViewModelProvider.notifier);
    final subscriptionState = ref.watch(subscriptionViewModelProvider);
    return BackgroundGradient(
        child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).buyScreenTitle),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                subscriptionVM.restorePurchase();
              },
              child: const Text("Restaurer les achats")),
          Table(
            children: const [
              TableRow(children: [
                Icon(Icons.app_blocking, size: 40),
                Text("Pas de pub"),
              ]),
              TableRow(children: [
                Icon(Icons.draw, size: 40),
                Text("Plus de thèmes"),
              ]),
              TableRow(children: [
                Icon(Icons.auto_graph, size: 40),
                Text("Graphes de statistiques"),
              ]),
              TableRow(children: [
                Icon(Icons.auto_awesome, size: 40),
                Text("Soutien au développeur"),
              ]),
            ],
          ),
          subscriptionState.when(
            pro: () => Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Vous êtes abonné"),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            offers: (packages, tempError) {
              useEffect(() {
                if (tempError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(tempError.message),
                  ));
                }
                return null;
              }, [tempError]);
              return ListView.builder(
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    return TextButton(
                        onPressed: () {
                          subscriptionVM.buy(packages[index]);
                        },
                        child: const Text("Acheter"));
                  });
            },
            error: (error) => Text(error.message),
          ),
          ElevatedButton(
              onPressed: () {
                // todo : buy by year
              },
              child: const Text("Acheter par an")),
          ElevatedButton(
              onPressed: () {
                // todo : buy by month
              },
              child: const Text("Acheter par mois")),
          const Text('Facturation récurrente, annulable à tout moment. '
              'Les abonnements sont gérés par Google Play.'),
        ],
      ),
    ));
  }
}
