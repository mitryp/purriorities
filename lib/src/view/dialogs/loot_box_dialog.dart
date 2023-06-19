import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/enums/loot_box.dart';
import '../../util/sprite_scaling.dart';
import '../pages/collection/collection_cat.dart';
import '../widgets/sprite_avatar.dart';

class LootBoxDialogContent extends StatefulWidget {
  final LootBoxType lootBoxType;
  final CollectionCat reward;

  const LootBoxDialogContent({
    required this.lootBoxType,
    required this.reward,
    super.key,
  });

  @override
  State<LootBoxDialogContent> createState() => _LootBoxDialogContentState();
}

class _LootBoxDialogContentState extends State<LootBoxDialogContent> {
  static const Duration _initialPauseFadeDuration = Duration(seconds: 1);
  static const Duration _crossFadeDuration = Duration(seconds: 1);

  bool _isCatShown = false;

  @override
  void initState() {
    super.initState();

    Timer(_initialPauseFadeDuration, _startAnimation);
  }

  void _startAnimation() {
    if (!mounted || _isCatShown) return;

    setState(() => _isCatShown = true);
  }

  @override
  Widget build(BuildContext context) {
    const defaultPadding = EdgeInsets.all(16);
    const contentBottomPadding = 8.0;
    const actionsTopPadding = 0.0;

    const spritesDimension = 64.0;
    const fadeCurve = Curves.easeOut;
    const sizeCurve = Curves.fastEaseInToSlowEaseOut;

    final ownership = widget.reward.ownership!;
    final info = widget.reward.info;

    final crossFadeState = _isCatShown ? CrossFadeState.showSecond : CrossFadeState.showFirst;

    return AlertDialog(
      contentPadding: defaultPadding.copyWith(bottom: contentBottomPadding),
      actionsPadding: defaultPadding.copyWith(top: actionsTopPadding),
      content: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedCrossFade(
              crossFadeState: crossFadeState,
              duration: _crossFadeDuration,
              firstCurve: fadeCurve,
              sizeCurve: sizeCurve,
              firstChild: SpriteAvatar.asset(
                widget.lootBoxType.sprite.asset,
                backgroundColor: widget.lootBoxType.catRarity.color,
                scale: scaleTo(spritesDimension),
                minRadius: spritesDimension,
              ),
              secondChild: Column(
                children: [
                  SpriteAvatar.network(
                    backgroundColor: widget.reward.info.rarity.color,
                    networkPath: widget.reward.info.spritePath,
                    scale: scaleTo(spritesDimension),
                    minRadius: spritesDimension,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Ви отримали:\n'),
                          TextSpan(
                            text: info.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '${info.description}\n'),
                          TextSpan(
                            text:
                                'рівень ${ownership.level}, бонус ${ownership.xpBoost.toStringAsFixed(2)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        AnimatedCrossFade(
          crossFadeState: crossFadeState,
          firstCurve: fadeCurve,
          sizeCurve: fadeCurve,
          duration: _crossFadeDuration * 1.1,
          firstChild: const SizedBox(),
          secondChild: TextButton(
            onPressed: context.pop,
            child: const Text('Ура!'),
          ),
        )
      ],
    );
  }
}
