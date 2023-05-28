part of 'collection_page.dart';

typedef Cat = ({String asset, String? name, int? level, double? xp, int? price});

const _radius = 50.0;

class CatCard extends StatelessWidget {
  final Cat cat;

  const CatCard({required this.cat, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final catLevel = cat.level;

        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                SizedBox.square(
                  dimension: _radius * 2,
                  child: cat.price != null ? _ShadedCatAvatar(cat: cat) : _CatAvatar(cat: cat),
                ),
                const SizedBox(height: 8),
                Text(cat.name ?? '???', style: const TextStyle(fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: (cat.price == null)
                      ? Text('+${cat.xp ?? '?'}% XP')
                      : _PurchaseButton(price: cat.price!),
                ),
              ],
            ),
            if (catLevel != null) _LevelDiamond(width: width, level: catLevel)
          ],
        );
      },
    );
  }
}

class _CatAvatar extends StatelessWidget {
  final Cat cat;

  const _CatAvatar({required this.cat, super.key});

  @override
  Widget build(BuildContext context) {
    const scale = (_radius - catSpriteDimension) * 2;

    return SpriteAvatar(
      image: Image.asset(
        cat.asset,
        color: cat.name == null ? Colors.black : null,
        filterQuality: FilterQuality.none,
        scale: scaleTo(scale),
      ),
      minRadius: _radius,
    );
  }
}

class _ShadedCatAvatar extends StatelessWidget {
  final Cat cat;

  const _ShadedCatAvatar({required this.cat, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Color.fromARGB(175, 0, 0, 0),
          BlendMode.darken,
        ),
        child: _CatAvatar(cat: cat),
      ),
    );
  }
}

class _PurchaseButton extends StatelessWidget {
  final int price;

  const _PurchaseButton({required this.price, super.key});

  @override
  Widget build(BuildContext context) {
    final border = MaterialStateProperty.all(
      const BorderSide(
        style: BorderStyle.solid,
        color: legendaryColor,
        width: 1,
      ),
    );

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

class _LevelDiamond extends StatelessWidget {
  final double width;
  final int level;

  const _LevelDiamond({required this.width, required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: (width / 2 - _radius) / 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DiamondText(caption: '$level'),
      ),
    );
  }
}
