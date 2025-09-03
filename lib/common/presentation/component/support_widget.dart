import 'package:flutter/material.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/navigation/routes.dart';

class SupportWidget extends StatelessWidget {
  const SupportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: GestureDetector(
        onTap: () {
          const SubscriptionRoute().push(context);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -3)),
              ],
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20))),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("images/logo_small.png"),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).supportWidget_title,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      S.of(context).supportWidget_message,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
