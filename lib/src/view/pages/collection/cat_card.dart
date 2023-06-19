part of 'collection_page.dart';

const _radius = 50.0;

class CatCard extends StatelessWidget {
  final CollectionCat cat;

  const CatCard({required this.cat, super.key});

  @override
  Widget build(BuildContext context) {
    final info = cat.info;
    final ownership = cat.ownership;
    final catPrice = ownership?.price;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tooltip(
                  message: (ownership == null) ? '???' : info.description,
                  margin: const EdgeInsets.only(top: _radius * 0.25),
                  child: SizedBox.square(
                    dimension: _radius * 2,
                    child: (ownership?.isAway ?? false)
                        ? _ShadedCatAvatar(cat.info, isOwned: cat.isOwned)
                        : _CatAvatar(cat.info, isOwned: cat.isOwned),
                  ),
                ),
                FittedBox(
                  child: Text(
                    !(ownership?.isAway ?? true) ? info.name : '???',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: height / 6,
                  child: catPrice == null
                      ? Center(child: Text('+${ownership?.xpBoost ?? '???'}% XP'))
                      : _PurchaseButton(
                          price: catPrice,
                          onPressed: () => _processCatPurchasingBack(context),
                        ),
                ),
              ],
            ),
            if (ownership != null) _LevelDiamond(width: width, level: ownership.level)
          ],
        );
      },
    );
  }

  Future<void> _processCatPurchasingBack(BuildContext context) async {
    final ownership = cat.ownership;

    if (ownership == null) return;

    final service = context.read<StoreService>();
    final res = await service.purchaseCatBack(ownership);

    // ignore: use_build_context_synchronously
    if (!context.mounted) return;

    if (res.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Успішно!',
          backgroundColor: Colors.green[200],
        ),
      );

      return;
    }

    showErrorSnackBar(
      context: context,
      content: ErrorSnackBarContent(
        titleText: 'Не вдалось повернути котика',
        subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
      ),
    );
  }
}

class _CatAvatar extends StatelessWidget {
  final Cat cat;
  final bool isOwned;

  const _CatAvatar(this.cat, {required this.isOwned});

  @override
  Widget build(BuildContext context) {
    return SpriteAvatar(
      image: Image.network(
        cat.spritePath,
        color: isOwned ? null : Colors.black,
        filterQuality: FilterQuality.none,
        scale: scaleToFitCircle(_radius),
      ),
      backgroundColor: cat.rarity.color,
      minRadius: _radius,
    );
  }
}

class _ShadedCatAvatar extends StatelessWidget {
  final Cat cat;
  final bool isOwned;

  const _ShadedCatAvatar(this.cat, {required this.isOwned});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Color.fromARGB(175, 0, 0, 0),
          BlendMode.darken,
        ),
        child: _CatAvatar(cat, isOwned: isOwned),
      ),
    );
  }
}

class _PurchaseButton extends StatelessWidget {
  final int price;
  final FutureVoidCallback<void> onPressed;

  const _PurchaseButton({required this.price, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ProgressIndicatorButton.elevated(
      onPressed: onPressed,
      style: accentButtonStyle,
      child: CurrencyInfo(quantity: price, currency: Currency.feed),
    );
  }
}

class _LevelDiamond extends StatelessWidget {
  final double width;
  final int level;

  const _LevelDiamond({required this.width, required this.level});

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
