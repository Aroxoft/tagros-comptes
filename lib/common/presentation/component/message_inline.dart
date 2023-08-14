import 'package:flutter/material.dart';
import 'package:tagros_comptes/generated/l10n.dart';

class ErrorInline extends StatelessWidget {
  final String title;
  final String message;
  final bool canRetry;
  final void Function() retryAction;

  const ErrorInline({
    super.key,
    required this.retryAction,
    required this.title,
    required this.message,
    required this.canRetry,
  });

  @override
  Widget build(BuildContext context) {
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
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.error_outline),
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
                            S.of(context).common_retryAction,
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
