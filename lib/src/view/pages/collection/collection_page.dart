import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../data/enums/sprite.dart';
import '../../../util/sprite_scaling.dart';
import '../../theme.dart';
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
  Widget build(BuildContext context) {
    return LayoutSelector(
      mobileLayoutBuilder: (context) => const MobileCollection(),
      desktopLayoutBuilder: (context) => const Placeholder(),
    );
  }
}

final List<({String asset, String? name, int? level, double? xp, int? price})> cats = [
  (asset: Sprite.grayCat.asset, name: 'Полуничка', level: 1, xp: 1.5, price: null),
  (asset: Sprite.grayCat.asset, name: 'Полуничка', level: 2, xp: null, price: 200),
  (asset: Sprite.grayCat.asset, name: 'Полуничка', level: 10, xp: 2, price: null),
  (asset: Sprite.grayCat.asset, name: null, level: null, xp: null, price: null),
  (asset: Sprite.grayCat.asset, name: null, level: null, xp: null, price: null),
];

class MobileCollection extends StatelessWidget {
  const MobileCollection({super.key});

  @override
  Widget build(BuildContext context) {
    final trustValue = 10;
    final maxTrust = 100;

    return MobileLayout(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: LabeledProgressBar(
              label: 'Довіра',
              value: trustValue,
              maxValue: maxTrust,
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: GridView.builder(
                itemCount: cats.length,
                itemBuilder: (context, index) => CatCard(cat: cats[index]),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  childAspectRatio: 0.3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  mainAxisExtent: 180,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
