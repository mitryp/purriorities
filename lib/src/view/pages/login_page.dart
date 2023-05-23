import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/user_data.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/sprite_avatar.dart';
import 'register_page.dart';

// можна зберігати останню пошту в локалсторедж

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: LayoutSelector(
        mobileLayoutBuilder: (context) => const MobileLoginForm(),
        desktopLayoutBuilder: (context) => const Placeholder(),
      ),
    );
  }
}

class MobileLoginForm extends StatelessWidget {
  const MobileLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    const avatarMaxRadius = 72.0;
    const avatarPadding = 16;

    return MobileLayout.child(
      minimumSafeArea: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: 'login-cat-hero',
                child: SpriteAvatar.asset(
                  'assets/gray-cat.webp',
                  maxRadius: avatarMaxRadius,
                  scale: scaleTo((avatarMaxRadius - avatarPadding) * 2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Вітаємо!', style: TextStyle(fontSize: 24)),
                ),
              ),
              Form(child: buildFormContent(context)),
              const SizedBox.square(dimension: 72),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormContent(BuildContext context) {
    // final data = Provider.of<LoginData>(context, [listen: true]);
    final data = context.watch<UserData>();

    // todo add validators

    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          initialValue: data.email,
          onChanged: (newEmail) => data.email = newEmail,
        ),
        TextFormField(
          obscureText: true,
          initialValue: data.password,
          onChanged: (newPassword) => data.password = newPassword,
          decoration: const InputDecoration(labelText: 'Пароль'),
        ),
        const SizedBox.square(dimension: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () => _processLogin(context),
              child: const Text('Увійти'),
            ),
            TextButton(
              onPressed: () => _processRegister(context),
              child: const Text('Новий користувач?'),
            ),
          ],
        ),
      ],
    );
  }

  void _processLogin(BuildContext context) {
    final data = context.read<UserData>();
    // loginService.login(data);
    log('${data.email}, ${data.password}');
  }

  void _processRegister(BuildContext context) {
    if (!context.mounted) return;
    final data = context.read<UserData>();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RegisterPage(email: data.email),
    ));
  }
}
