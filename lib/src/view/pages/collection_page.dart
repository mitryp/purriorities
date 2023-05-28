import 'package:flutter/material.dart';

import '../../data/enums/sprite.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
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
  (asset: Sprite.grayCat.asset, name: 'Полуничка', level: 1, xp: 2, price: null),
  (asset: Sprite.grayCat.asset, name: null, level: null, xp: null, price: null),
  (asset: Sprite.grayCat.asset, name: null, level: null, xp: null, price: null),
];

class MobileCollection extends StatelessWidget {
  const MobileCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      children: [
        Expanded(
          child: Card(
            child: GridView.builder(
              itemCount: cats.length,
              itemBuilder: (context, index) => _buildCatCard(cats[index]),
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
      ],
    );
  }

  Widget _buildCatCard(({String asset, String? name, int? level, double? xp, int? price}) cat) {
    const radius = 50.0;
    // 16 is the size of a sprite
    const scale = (radius - 16) * 2;

    return
        //Stack(
        //children: [
        Column(
      children: [
        SpriteAvatar(
          image: Image.asset(
            cat.asset,
            color: cat.name == null ? Colors.black : null,
            filterQuality: FilterQuality.none,
            scale: scaleTo(scale),
          ),
          minRadius: radius,
        ),
        const SizedBox(height: 8),
        Text(cat.name ?? '???', style: const TextStyle(fontWeight: FontWeight.bold)),
        if (cat.price == null)
          Text('+${cat.xp ?? '?'}% XP')
        else
          ProgressIndicatorButton.elevated(
            onPressed: () async {},
            child: Row(
              children: [
                Image.asset(Sprite.fishFood.asset),
                Text('${cat.price}'),
              ],
            ),
          )
      ],
    );
    //  ],
    //);
  }
}
