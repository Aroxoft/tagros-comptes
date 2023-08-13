import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/config/platform_configuration.dart';
import 'package:tagros_comptes/monetization/domain/premium_plan.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';
import 'package:tagros_comptes/monetization/presentation/buy_view_model.dart';
import 'package:tagros_comptes/monetization/presentation/package_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends HookConsumerWidget {
  const SubscriptionScreen({super.key});

  static const routeName = '/buy';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyVM = ref.watch(buyViewModelProvider.notifier);
    final errorAction = ref.watch(
        buyViewModelProvider.select((value) => value.valueOrNull?.errorAction));
    useEffect(() {
      Future.microtask(
          () => ref.read(_messageProvider.notifier).state = errorAction);
      return null;
    }, [errorAction]);
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
      body: SafeArea(
        child: ref.watch(isPremiumProvider
                    .select((data) => data.whenOrNull(data: (data) => data))) ==
                true
            ? const AlreadyPremium()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TopBar(
                    loading: ref.watch(buyViewModelProvider.select((value) =>
                        value.whenOrNull(data: (data) => data.loadingAction) ??
                        false)),
                    buttonText: "Déjà acheté ?",
                    onButtonPressed: () {
                      buyVM.restorePurchase();
                    },
                    enabled: ref.watch(buyViewModelProvider.select((value) =>
                        value.when(
                            data: (data) => !data.loadingAction,
                            error: (Object error, StackTrace stackTrace) =>
                                false,
                            loading: () => false))),
                  ),
                  HeaderWidget(
                      title: "Débloquez tout",
                      subtitle:
                          "Pas de pub, customisation avancée de l'application, "
                          "pas de limites de nombre, et plus encore !"),
                  const SizedBox(height: 32),
                  ref.watch(buyViewModelProvider).when(
                        data: (buy) {
                          final packages = buy.packages;
                          if (packages == null) {
                            return ErrorInline(
                              error: ErrorPurchase.network,
                              retryAction: buyVM.refreshPackages,
                            );
                          }
                          return DisplayPackages(
                              packages: packages,
                              onSelect: buyVM.select,
                              selected: buy.selectedPackage);
                        },
                        error: (error, stack) => ErrorInline(
                            error: error,
                            retryAction: () {
                              buyVM.refreshPackages();
                            }),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Facturation récurrente, annulable à tout moment. '
                      'Les abonnements sont gérés par Google Play.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  ref.watch(
                      buyViewModelProvider.select((value) => value.maybeWhen(
                            data: (data) {
                              return BuyPremiumButton(
                                selectedPackage: data.selectedPackage,
                                onBuySelected: (package) {
                                  buyVM.buy(package);
                                },
                              );
                            },
                            orElse: () => BuyPremiumButton(
                              selectedPackage: null,
                              onBuySelected: (package) {},
                            ),
                          ))),
                  const LegalTerms(),
                ],
              ),
      ),
    ));
  }
}

class ErrorInline extends StatelessWidget {
  final Object error;
  final void Function() retryAction;

  const ErrorInline(
      {super.key, required this.error, required this.retryAction});

  @override
  Widget build(BuildContext context) {
    final String title;
    final String message;
    final bool canRetry;
    if (error is ErrorPurchase) {
      final errorPurchase = error as ErrorPurchase;
      switch (errorPurchase) {
        case ErrorPurchase.network:
          title = "Achats non disponibles pour le moment";
          message =
              "Vous n'êtes pas connecté à internet. Veuillez vérifier votre connexion et réessayer.";
          canRetry = true;
        case ErrorPurchase.cancelled:
          title = "Achat annulé";
          message = "Vous avez annulé votre achat.";
          canRetry = false;
        default:
          title = "Achats non disponibles pour le moment";
          message =
              "Une erreur est survenue. Vous pouvez contacter le support en donnant le code suivant : ${errorPurchase.code}";
          canRetry = false;
      }
    } else {
      title = error.toString();
      message = "";
      canRetry = false;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: canRetry ? retryAction : null,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.error_outline),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onError,
                            ),
                      ),
                      if (message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            message,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                          ),
                        ),
                      if (canRetry)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "Réessayer",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuyPremiumButton extends StatelessWidget {
  final Package? selectedPackage;
  final void Function(Package package) onBuySelected;

  const BuyPremiumButton({
    super.key,
    required this.selectedPackage,
    required this.onBuySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: selectedPackage == null
            ? null
            : () {
                onBuySelected(selectedPackage!);
              },
        icon: const Icon(Icons.flash_on),
        label: Text("Obtenez premium"));
  }
}

class AlreadyPremium extends ConsumerWidget {
  const AlreadyPremium({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TopBar(
            loading: false,
            buttonText: "Gérer vos abonnements",
            onButtonPressed: () async {
              // launch the subscription url
              final configuration = ref.read(platformConfigProvider);
              Uri? uri;
              if (configuration.isAndroid) {
                uri = Uri.parse(
                    "https://play.google.com/store/account/subscriptions");
              } else if (configuration.isIOS) {
                uri = Uri.parse("https://apps.apple.com/account/subscriptions");
              }
              if (uri != null) {
                if (!await launchUrl(uri,
                    mode: LaunchMode.externalApplication)) {
                  ref.read(_messageProvider.notifier).state =
                      "Impossible d'ouvrir le lien, veuillez aller directement "
                      "sur votre store pour gérer vos abonnements";
                }
              }
            },
            enabled: true),
        const HeaderWidget(
            title: "Vous avez débloqué Tagros premium",
            subtitle: "Merci pour votre soutien !"),
        const Padding(
          padding: EdgeInsets.only(top: 32),
          child: DisplayAdvantages(),
        ),
        Expanded(
            child: Center(
                child: Icon(
          Icons.check_circle,
          size: 60,
          color: Theme.of(context).colorScheme.primary,
        ))),
        const LegalTerms(),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "images/logo_small.png",
          width: 50,
          height: 50,
        ),
        Stack(children: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            top: 0,
            right: 30,
            child: Icon(Icons.diamond_outlined, size: 40),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class DisplayAdvantages extends StatelessWidget {
  const DisplayAdvantages({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Table(
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
              // TableRow(children: [
              //   Icon(Icons.auto_graph, size: 40),
              //   Text("Graphes de statistiques", style: TextStyle(fontSize: 16)),
              // ]),
              TableRow(children: [
                Icon(Icons.forest, size: 40),
                Text("Pas de limites de nombre",
                    style: TextStyle(fontSize: 16)),
              ]),
              TableRow(children: [
                Icon(Icons.auto_awesome, size: 40),
                Text("Soutien au développeur", style: TextStyle(fontSize: 16)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

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

class TopBar extends StatelessWidget {
  final bool loading;
  final String buttonText;
  final void Function() onButtonPressed;
  final bool enabled;

  const TopBar(
      {super.key,
      required this.loading,
      required this.buttonText,
      required this.onButtonPressed,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 4,
            child: loading ? const LinearProgressIndicator() : const SizedBox(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back)),
              TextButton(
                  onPressed: enabled ? onButtonPressed : null,
                  child: Text(buttonText)),
            ],
          )
        ]);
  }
}

class LegalTerms extends ConsumerWidget {
  const LegalTerms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: () async {
          final uri = Uri.parse("https://aroxoft.github.io/privacy/");
          if (!await launchUrl(uri)) {
            ref.read(_messageProvider.notifier).state =
                "Impossible d'ouvrir le lien. Les conditions sont disponibles à l'adresse suivante : $uri";
          }
        },
        child: Text("Politique de confidentialité",
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center));
  }
}

final _messageProvider = StateProvider<String?>((ref) {
  return null;
});
