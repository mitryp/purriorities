import 'dart:developer';
import 'dart:js';

import 'package:flutter/material.dart';

import '../../data/enums/sprite.dart';
import '../../util/sprite_scaling.dart';
import '../theme.dart';
import '../widgets/diamond_text.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_bars/labeled_progress_bar.dart';
import '../widgets/progress_indicator_button.dart';
import '../widgets/sprite_avatar.dart';

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
            child: GridView.builder(
              itemCount: cats.length,
              itemBuilder: (context, index) => _buildCatCard(context, cats[index]),
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
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('В магазин'),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCatCard(BuildContext context,
      ({
      String asset,
      String? name,
      int? level,
      double? xp,
      int? price,
      }) cat,) {
    const radius = 50.0;
    // 16 is the size of a sprite
    const scale = (radius - 16) * 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox.square(
                  dimension: radius * 2,
                  child: ClipOval(
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color(0xff222222),
                        BlendMode.darken,
                      ),
                      child: SpriteAvatar(
                        image: Image.asset(
                          cat.asset,
                          color: cat.name == null ? Colors.black : null,
                          filterQuality: FilterQuality.none,
                          scale: scaleTo(scale),
                        ),
                        minRadius: radius,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(cat.name ?? '???', style: const TextStyle(fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: (cat.price == null)
                      ? Text('+${cat.xp ?? '?'}% XP')
                      : _buildPurchaseButton(context, cat.price!),
                ),
              ],
            ),
            if (cat.level != null)
              Positioned(
                top: 0,
                right: (width / 2 - radius) / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DiamondText(caption: '${cat.level}'),
                ),
              )
          ],
        );
      },
    );
  }

  Widget _buildPurchaseButton(BuildContext context, int price) {
    final border = MaterialStateProperty.all(
      const BorderSide(
        style: BorderStyle.solid,
        color: legendaryColor,
        width: 1,
      ),
    );

    // final shape = MaterialStateProperty.all(
    //   const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(10.0),
    //     ),
    //   ),
    // );

    return ProgressIndicatorButton.elevated(
      onPressed: () async {}, //TODO
      style: ButtonStyle(
        side: border,
        //shape: shape,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Sprite.fishFood.asset),
          Text('$price'),
        ],
      ),
    );
  }
}
