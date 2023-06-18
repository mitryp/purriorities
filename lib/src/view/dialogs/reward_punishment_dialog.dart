import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/currency.dart';
import '../../data/models/punishments.dart';
import '../../data/models/rewards.dart';
import '../../data/models/skill.dart';
import '../../data/models/task_refuse_response.dart';
import '../../data/models/user.dart';
import '../../data/user_data.dart';
import '../../services/cats_info_cache.dart';
import '../../services/http/util/fetch_service_bundle.dart';
import '../../util/sprite_scaling.dart';
import '../pages/collection/collection_cat.dart';
import '../theme.dart';
import '../widgets/currency/currency_info.dart';
import '../widgets/sprite_avatar.dart';

class RewardPunishmentDialog extends StatelessWidget {
  static const TextStyle _labelStyle = TextStyle(fontSize: 16);

  final User user;
  final List<Skill> skills;
  final List<CollectionCat> ownedCats;
  final PendingPunishment punishment;
  final Reward reward;
  final bool wasNewQuestScheduled;

  const RewardPunishmentDialog({
    required this.user,
    required this.skills,
    required this.ownedCats,
    this.punishment = const PendingPunishment.absent(),
    this.reward = const Reward.absent(),
    this.wasNewQuestScheduled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Операцію виконано',
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!reward.isAbsent) ...[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 8),
              child: const Text('Досягнення', style: _labelStyle),
            ),
            _RewardsColumn(reward, user: user, skills: skills),
          ],
          if (!punishment.isAbsent) ...[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 8, top: reward.isAbsent ? 0 : 8),
              child: const Text('Втрати', style: _labelStyle),
            ),
            _PunishmentsColumn(punishment, cats: ownedCats),
          ],
          if (wasNewQuestScheduled)
            const _RewardPunishmentEntry(
              title: Text('Новий періодичний квест створено'),
            ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [ElevatedButton(onPressed: context.pop, child: const Text('Зрозуміло'))],
    );
  }
}

class _PunishmentsColumn extends StatelessWidget {
  static const _trustTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.lightBlueAccent,
  );

  final List<CollectionCat> cats;
  final PendingPunishment punishment;

  const _PunishmentsColumn(this.punishment, {required this.cats});

  @override
  Widget build(BuildContext context) {
    const catSpriteRadius = 32.0;
    const cardPadding = 8.0;

    final feedLostFromCats = punishment.runawayCats.fold(0, (val, e) => val + e.feedTaken);
    final trustLostFromQuests = punishment.overdueQuests.fold(
      0,
      (val, e) => val + e.trustLost,
    );

    return Column(
      children: [
        if (punishment.runawayCats.isNotEmpty)
          _RewardPunishmentEntry(
            title: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  const TextSpan(text: 'Від вас пішли ці котики та забрали з собою '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: CurrencyInfo(
                      currency: Currency.feed,
                      quantity: feedLostFromCats,
                      reversed: true,
                    ),
                  )
                ],
              ),
            ),
            child: SizedBox(
              width: double.maxFinite,
              height: catSpriteRadius * 1.5,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox.square(dimension: cardPadding),
                itemCount: punishment.runawayCats.length,
                itemBuilder: (_, index) {
                  final cat = punishment.runawayCats[index];
                  final collectionCat = cats.firstWhere((c) => c.info.nameId == cat.nameId);

                  return Tooltip(
                    message: '${collectionCat.info.name} ${collectionCat.ownership!.level} рівня',
                    child: SpriteAvatar.network(
                      networkPath: collectionCat.info.spritePath,
                      scale: scaleToFitCircle(catSpriteRadius),
                      minRadius: catSpriteRadius / 1.5,
                      backgroundColor: collectionCat.info.rarity.color,
                    ),
                  );
                },
              ),
            ),
          ),
        if (trustLostFromQuests > 0)
          _RewardPunishmentEntry(
            title: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Пропущені реченці призвели до втрати '),
                  TextSpan(
                    text: '$trustLostFromQuests',
                    style: _trustTextStyle,
                  ),
                  const TextSpan(text: ' одиниць довіри'),
                ],
              ),
            ),
          ),
        if (punishment.extraTrustLost > 0)
          _RewardPunishmentEntry(
            title: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Ви втратили '),
                  TextSpan(text: '${punishment.extraTrustLost}', style: _trustTextStyle),
                  const TextSpan(text: ' довіри'),
                ],
              ),
            ),
          )
      ],
    );
  }
}

class _RewardsColumn extends StatelessWidget {
  static const TextStyle _xpTextStyle = TextStyle(color: legendaryColor);

  final User user;
  final List<Skill> skills;
  final Reward reward;

  const _RewardsColumn(this.reward, {required this.user, required this.skills});

  @override
  Widget build(BuildContext context) {
    final currenciesGained = [
      CurrencyInfo(quantity: reward.feedGained, currency: Currency.feed),
      CurrencyInfo(quantity: reward.catnipGained, currency: Currency.catnip),
    ].where((c) => c.quantity > 0);

    final List<({Skill skill, int xpGained})> skillsXpGained = reward.skillRewards
        .map(
          (skillReward) => (
            xpGained: skillReward.levelExpGained,
            skill: skills.firstWhere((skill) => skill.id == skillReward.id)
          ),
        )
        .where((entry) => entry.xpGained > 0)
        .toList(growable: false);

    final wasMainLevelGained = user.levelExp + reward.mainLevelExpGained >= user.levelCap;

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          if (currenciesGained.isNotEmpty)
            _RewardPunishmentEntry(
              title: Text.rich(
                TextSpan(
                  children: [
                    for (final cur in currenciesGained)
                      WidgetSpan(
                        child: cur,
                        alignment: PlaceholderAlignment.middle,
                      ),
                  ],
                ),
              ),
            ),
          if (skillsXpGained.isNotEmpty)
            _RewardPunishmentEntry(
              title: const Text('Ви отримали досвід у навичках', textAlign: TextAlign.center),
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: skillsXpGained.map((item) {
                    final skill = item.skill;
                    final xpGained = item.xpGained;
                    final wasLevelGained = skill.levelExp + xpGained >= skill.levelCap;
                    const skillNameFontSize = 14.0;

                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              item.skill.name,
                              style: const TextStyle(fontSize: skillNameFontSize),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (wasLevelGained)
                            const Expanded(
                              child: Center(child: Icon(Icons.arrow_upward, color: legendaryColor)),
                            ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${skill.level + (wasLevelGained ? 1 : 0)} рівень',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.end,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ).toList(growable: false),
              ),
            ),
          if (reward.mainLevelExpGained > 0)
            _RewardPunishmentEntry(
              title: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Ви отримали '),
                    TextSpan(
                      text: reward.mainLevelExpGained.toStringAsFixed(2),
                      style: _xpTextStyle,
                    ),
                    const TextSpan(text: ' очок досвіду'),
                  ],
                ),
              ),
              child: wasMainLevelGained ? const Text('Новий рівень!', style: _xpTextStyle) : null,
            ),
        ],
      ),
    );
  }
}

class _RewardPunishmentEntry extends StatelessWidget {
  final Text title;
  final Widget? child;

  const _RewardPunishmentEntry({required this.title, this.child});

  @override
  Widget build(BuildContext context) {
    const cardPadding = 8.0;

    final child = this.child;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Column(
          children: [
            Padding(
              padding: child != null ? const EdgeInsets.only(bottom: cardPadding) : EdgeInsets.zero,
              child: title,
            ),
            if (child != null) child,
          ],
        ),
      ),
    );
  }
}

Future<void> showRewardPunishmentDialog({
  required BuildContext context,
  Reward? reward,
  TaskRefuseResponse? refuseResponse,
  bool wasNewQuestScheduled = false,
}) async {
  assert(reward != null || refuseResponse != null);

  final catOwnerships = context.read<UserData>().user!.catOwnerships;
  final cats = context.read<CatsInfoCache>().cats;
  final collectionCats = catOwnerships
      .map(
        (ownership) => CollectionCat(
          cats.firstWhere((cat) => cat.nameId == ownership.catNameId),
          ownership,
        ),
      )
      .toList(growable: false);
  final user = context.read<UserData>().user!;
  final skills = await context.read<FetchServiceBundle>().skillsFetchService.getMany();

  // ignore: use_build_context_synchronously
  if (!context.mounted) return;

  final rew = reward ?? refuseResponse!.reward;
  final punishment = refuseResponse?.punishment;

  await showDialog(
    context: context,
    builder: (context) => RewardPunishmentDialog(
      user: user,
      skills: skills.result().data,
      ownedCats: collectionCats,
      punishment: punishment ?? const PendingPunishment.absent(),
      reward: rew,
      wasNewQuestScheduled: wasNewQuestScheduled,
    ),
  );
}
