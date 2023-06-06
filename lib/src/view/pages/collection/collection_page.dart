import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../../constants.dart';
import '../../../data/models/cat.dart';
import '../../../data/models/cat_ownership.dart';
import '../../../data/models/user.dart';
import '../../../data/user_data.dart';
import '../../../services/cats_info_cache.dart';
import '../../../util/extensions/context_synchronizer.dart';
import '../../../util/sprite_scaling.dart';
import '../../widgets/authorizer.dart';
import '../../widgets/currency/currency_info.dart';
import '../../widgets/diamond_text.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';
import '../../widgets/progress_bars/labeled_progress_bar.dart';
import '../../widgets/progress_indicator_button.dart';
import '../../widgets/sprite_avatar.dart';

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
      child: LayoutSelector(
        mobileLayoutBuilder: (context) => const MobileCollection(),
        desktopLayoutBuilder: (context) => const Placeholder(),
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
                selector: (context, data, catsInfo) {
                  assert(catsInfo.isLoaded);
                  final ownerships = data.user?.catOwnerships ?? [];

                  return (
                    data.user,
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

class CollectionCat implements Comparable<CollectionCat> {
  final Cat info;
  final CatOwnership? ownership;

  const CollectionCat(this.info, this.ownership);

  bool get isOwned => ownership != null;

  int get _value =>
      (isOwned ? 100 : 0) + (ownership?.xpBoost ?? 0).toInt();

  @override
  int compareTo(CollectionCat other) => other._value - _value;
}
