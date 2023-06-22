import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../common/enums/app_route.dart';
import '../../../common/enums/sprite.dart';
import '../../../data/models/user.dart';
import '../../../data/user_data.dart';
import '../../../services/http/auth_service.dart';
import '../../../services/http/fetch/user_fetch_service.dart';
import '../../../services/http/util/fetch_service_bundle.dart';
import '../../../util/sprite_scaling.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../widgets/authorizer.dart';
import '../../widgets/error_snack_bar.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';
import '../../widgets/progress_indicator_button.dart';
import '../../widgets/punishment_consumer.dart';
import '../../widgets/sprite_avatar.dart';

typedef FutureOrCallback = FutureOr<dynamic> Function();

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: PunishmentConsumer(
        child: LayoutSelector(
          mobileLayoutBuilder: (_) => const _ProfilePageMobileLayout(),
        ),
      ),
    );
  }
}

class _ProfilePageMobileLayout extends StatelessWidget {
  static const Sprite sprite = Sprite.grayCat;
  static const double radius = 50.0;

  const _ProfilePageMobileLayout({super.key});

  Future<void> _processLogout(BuildContext context) async {
    final authService = context.read<AuthService>();

    final res = await authService.logout();

    log('$res, ${res.error?.response}');

    if (!context.mounted) return;

    if (!res.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: const ErrorSnackBarContent(
          titleText: 'Не вдалося вийти з акаунту користувача.',
        ),
      );

      return;
    }

    context.push(AppRoute.login.route);
  }

  Future<void> _processProfileDeletion(BuildContext context) async {
    if (!context.mounted) return;

    final isConfirmed = await showConfirmationDialog(
      context: context,
      title: 'Ви дійсно хочете видалити акаунт?',
      prompt: 'Всі дані разом з квестами, досягненнями й колекцією котиків буде втрачено.',
      confirmLabelText: 'Так',
      denyLabelText: 'Ні',
      titleStyle: const TextStyle(fontSize: 17),
      promptStyle: const TextStyle(fontSize: 15),
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;

    final userService = context.read<FetchServiceBundle>().usersFetchService;

    final res = await userService.delete();

    log('$res, ${res.error?.response}');

    if (!context.mounted) return;

    if (!res.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: const ErrorSnackBarContent(
          titleText: 'Не вдалося видалити акаунт користувача.',
        ),
      );

      return;
    }

    context.push(AppRoute.login.route);
  }

  @override
  Widget build(BuildContext context) {
    final List<({String caption, IconData iconData, FutureOrCallback callback, bool isAsync})>
        profileButtonsData = [
      (
        caption: 'Редагувати профіль',
        iconData: Icons.edit,
        callback: () => context.push(AppRoute.editProfile.route),
        isAsync: false,
      ),
      (
        caption: 'Видалити профіль',
        iconData: Icons.delete,
        callback: () => _processProfileDeletion(context),
        isAsync: true,
      ),
      (
        caption: 'Вийти',
        iconData: Icons.logout,
        callback: () => _processLogout(context),
        isAsync: true,
      ),
    ];

    return MobileLayout.child(
      appBar: AppBar(
        title: const Text('Особистий профіль'),
      ),
      child: Selector<UserData, User>(
        selector: (context, data) => data.user!,
        builder: (context, user, child) {
          return Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SpriteAvatar.asset(
                        sprite.animatedAsset,
                        minRadius: radius,
                        scale: scaleToFitCircle(radius),
                      ),
                      const SizedBox(height: 8.0),
                      Text(user.nickname),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: profileButtonsData.map((data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: _ProfileButton(
                        onPressed: data.callback,
                        caption: data.caption,
                        iconData: data.iconData,
                        isAsync: data.isAsync,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final FutureOrCallback onPressed;
  final IconData iconData;
  final String caption;
  final bool isAsync;

  const _ProfileButton({
    required this.caption,
    required this.iconData,
    required this.onPressed,
    this.isAsync = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isAsync) {
      ProgressIndicatorButton.outlined(
        onPressed: onPressed,
        child: _ProfileButtonContent(
          iconData: iconData,
          caption: caption,
        ),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      child: _ProfileButtonContent(
        iconData: iconData,
        caption: caption,
      ),
    );
  }
}

class _ProfileButtonContent extends StatelessWidget {
  final IconData iconData;
  final String caption;

  const _ProfileButtonContent({
    required this.caption,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 8.0),
          Text(caption),
        ],
      ),
    );
  }
}
