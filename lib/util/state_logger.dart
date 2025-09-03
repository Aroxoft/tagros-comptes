import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StateLogger extends ProviderObserver {
  const StateLogger();

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (kDebugMode) {
      log('''
{
  provider: ${context.provider.name ?? context.provider.runtimeType},
<-- oldValue: $previousValue,
--> newValue: $newValue
}
''');
    }
  }
}
