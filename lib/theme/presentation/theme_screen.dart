import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/common/presentation/menu.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/tableau_repository_impl.dart';
import 'package:tagros_comptes/tagros/presentation/add_modify.dart';
import 'package:tagros_comptes/tagros/presentation/tableau.dart';
import 'package:tagros_comptes/tagros/presentation/tableau_view_model.dart';
import 'package:tagros_comptes/theme/data/theme_fake.dart';
import 'package:tagros_comptes/theme/presentation/preset_themes.dart';
import 'package:tagros_comptes/theme/presentation/theme_customization.dart';

class ThemeScreen extends HookConsumerWidget {
  const ThemeScreen({super.key});

  static const routeName = '/theme';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: BackgroundGradient(
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).themeScreenTitle),
            bottom: TabBar(
                indicatorColor: ref.watch(themeColorProvider
                    .select((value) => value.value?.sliderColor)),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                tabs: [
                  S.of(context).themeTabPresetThemes,
                  S.of(context).themeTabCustomize
                ].map((e) => Tab(text: e)).toList()),
          ),
          body: const Column(
            children: [
              ThemePreview(),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    PresetThemes(),
                    ThemeCustomization(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _fakeDaoProvider = Provider((ref) => FakeGamesDao());

final _fakeRepository = FakeRepository();

class ThemePreview extends HookConsumerWidget {
  const ThemePreview({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 200,
      child: ProviderScope(
        overrides: [
          tableauRepositoryProvider.overrideWith((ref) => _fakeRepository),
          gamesDaoProvider.overrideWithValue(ref.watch(_fakeDaoProvider)),
          currentGameProvider
              .overrideWith((ref) => AsyncValue.data(fakeGameWithPlayers)),
          navigationPrefixProvider.overrideWithValue("theme-preview-"),
        ],
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            PreviewScreen(child: MenuScreen(showAds: false)),
            PreviewScreen(child: TableauPage()),
            PreviewScreen(child: AddModifyEntry()),
          ],
        ),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        child: FittedBox(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: child)));
  }
}
