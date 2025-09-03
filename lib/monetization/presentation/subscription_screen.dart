import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/common/presentation/component/message_inline.dart';
import 'package:tagros_comptes/config/platform_configuration.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/monetization/domain/premium_plan.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';
import 'package:tagros_comptes/monetization/presentation/buy_view_model.dart';
import 'package:tagros_comptes/monetization/presentation/display_advantages.dart';
import 'package:tagros_comptes/monetization/presentation/display_packages.dart';
import 'package:tagros_comptes/monetization/presentation/error_mapper.dart';
import 'package:url_launcher/url_launcher.dart';
class SubscriptionScreen extends HookConsumerWidget {
  const SubscriptionScreen({super.key});

  static const routeName = '/buy';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyVM = ref.watch(buyViewModelProvider.notifier);
    final errorAction = ref.watch(
        buyViewModelProvider.select((value) => value.value?.errorAction));
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
                  _TopBar(
                    loading: ref.watch(buyViewModelProvider.select((value) =>
                        value.whenOrNull(data: (data) => data.loadingAction) ??
                        false)),
                    buttonText:
                        S.of(context).subscription_restorePurchase_button,
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
                  _HeaderWidget(
                      title: S.of(context).subscription_heading_title,
                      subtitle: S.of(context).subscription_heading_subtitle),
                  const SizedBox(height: 32),
                  ref.watch(buyViewModelProvider).when(
                        data: (buy) {
                          final packages = buy.packages;
                          if (packages == null) {
                            return ErrorInline(
                              title: ErrorPurchase.network.errorTitle(context),
                              message:
                                  ErrorPurchase.network.errorMessage(context),
                              canRetry: true,
                              retryAction: buyVM.refreshPackages,
                            );
                          }
                          return DisplayPackages(
                              packages: packages,
                              onSelect: buyVM.select,
                              selected: buy.selectedPackage);
                        },
                        error: (error, stack) {
                          String message = "";
                          String title = error.toString();
                          bool retry = false;
                          if (error is ErrorPurchase) {
                            message = error.errorMessage(context);
                            title = error.errorTitle(context);
                            retry = error.canRetry;
                          }
                          return ErrorInline(
                              retryAction: () {
                                buyVM.refreshPackages();
                              },
                              title: title,
                              message: message,
                              canRetry: retry);
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      S
                          .of(context)
                          .subscription_disclaimer_reccurringPurchase_text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  ref.watch(
                      buyViewModelProvider.select((value) => value.maybeWhen(
                            data: (data) {
                              return _BuyPremiumButton(
                                selectedPackage: data.selectedPackage,
                                onBuySelected: (package) {
                                  buyVM.buy(package);
                                },
                              );
                            },
                            orElse: () => _BuyPremiumButton(
                              selectedPackage: null,
                              onBuySelected: (package) {},
                            ),
                          ))),
                  const _LegalTerms(),
                ],
              ),
      ),
    ));
  }
}

class _BuyPremiumButton extends StatelessWidget {
  final Package? selectedPackage;
  final void Function(Package package) onBuySelected;

  const _BuyPremiumButton({
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
        label: Text(S.of(context).subscription_buy_button));
  }
}

class AlreadyPremium extends ConsumerWidget {
  const AlreadyPremium({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _TopBar(
            loading: false,
            buttonText: S.of(context).subscription_manageSubscription_button,
            onButtonPressed: () async {
              // launch the subscription url
              final configuration = ref.read(platformConfigProvider);
              Uri? uri;
              if (configuration.isAndroid) {
                uri = Uri.parse(
                    S.of(context).subscription_manageSubscription_android_url);
              } else if (configuration.isIOS) {
                uri = Uri.parse(
                    S.of(context).subscription_manageSubscription_ios_url);
              }
              if (uri != null) {
                final linkError =
                    S.of(context).subscription_manageSubscription_linkError;
                if (!await launchUrl(uri,
                    mode: LaunchMode.externalApplication)) {
                  ref.read(_messageProvider.notifier).state = linkError;
                }
              }
            },
            enabled: true),
        _HeaderWidget(
            title: S.of(context).subscription_alreadyPremium_title,
            subtitle: S.of(context).subscription_alreadyPremium_subtitle),
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
        const _LegalTerms(),
      ],
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderWidget({required this.title, required this.subtitle});

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
              widthFactor: 0.65,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            top: 0,
            right: 20,
            child: Icon(Icons.diamond_outlined, size: 40),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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

class _TopBar extends StatelessWidget {
  final bool loading;
  final String buttonText;
  final void Function() onButtonPressed;
  final bool enabled;

  const _TopBar(
      {required this.loading,
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

class _LegalTerms extends ConsumerWidget {
  const _LegalTerms();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: () async {
          final uri = Uri.parse(
              S.of(context).subscription_legalTerms_privacyPolicy_url);
          final errorMessage = S
              .of(context)
              .subscription_legalTerms_privacyPolicy_linkError_message(uri);
          if (!await launchUrl(uri)) {
            ref.read(_messageProvider.notifier).state = errorMessage;
          }
        },
        child: Text(S.of(context).subscription_legalTerms_privacyPolicy_button,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center));
  }
}

final _messageProvider = StateProvider<String?>((ref) {
  return null;
});
