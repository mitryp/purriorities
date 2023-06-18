import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/enums/currency.dart';
import '../../../config.dart';
import '../../../constants.dart';
import '../../../data/models/cat.dart';
import '../../../data/models/user.dart';
import '../../../data/user_data.dart';
import '../../../services/cats_info_cache.dart';
import '../../../services/store_service.dart';
import '../../../typedefs.dart';
import '../../../util/extensions/context_synchronizer.dart';
import '../../../util/sprite_scaling.dart';
import '../../widgets/authorizer.dart';
import '../../widgets/currency/currency_info.dart';
import '../../widgets/diamond_text.dart';
import '../../widgets/error_snack_bar.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';
import '../../widgets/progress_bars/labeled_progress_bar.dart';
import '../../widgets/progress_indicator_button.dart';
import '../../widgets/sprite_avatar.dart';
import 'collection_cat.dart';

part 'cat_card.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  void initState() {
    super.initState();
    context.synchronizer().syncUser();
  }

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: ProxyProvider<Dio, StoreService>(
        update: (context, client, prev) => StoreService(context: context, client: client),
        child: LayoutSelector(
          mobileLayoutBuilder: (context) => const MobileCollection(),
          desktopLayoutBuilder: (context) => const Placeholder(),
        ),
      ),
    );
  }
}

class MobileCollection extends StatelessWidget {
  const MobileCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: Selector<UserData, User?>(
              selector: (context, data) => data.user,
              builder: (context, user, _) {
                return LabeledProgressBar(
                  label: 'Довіра',
                  value: user?.trust ?? 0,
                  maxValue: maxUserTrust,
                  labelAlign: TextAlign.center,
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Selector2<UserData, CatsInfoCache, (User?, List<CollectionCat>)>(
                selector: (context, userData, catsInfo) {
                  assert(
                    catsInfo.isLoaded,
                    'Cats info is supposed to be loaded at this point. '
                    'Something must be wrong, if it is not',
                  );

                  final ownerships = userData.user?.catOwnerships ?? [];

                  return (
                    userData.user,
                    catsInfo.cats.map(
                      (info) {
                        final hasOwnership = ownerships.any((o) => o.catNameId == info.nameId);

                        return CollectionCat(
                          info,
                          hasOwnership
                              ? ownerships.firstWhere((o) => o.catNameId == info.nameId)
                              : null,
                        );
                      },
                    ).toList(growable: false)
                      ..sort()
                  );
                },
                builder: (context, data, child) {
                  final cats = data.$2;

                  return GridView.builder(
                    itemCount: cats.length,
                    itemBuilder: (context, index) => CatCard(cat: cats[index]),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160,
                      childAspectRatio: 0.3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      mainAxisExtent: 180,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
