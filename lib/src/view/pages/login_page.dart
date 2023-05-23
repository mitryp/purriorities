import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/enums/sprite.dart';
import '../../data/user_data.dart';
import '../../data/util/validators.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/layouts/form_layout.dart';
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
    return MobileLayout.child(
      minimumSafeArea: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: FormLayout(
        leading: _buildLeading(),
        form: Form(child: _buildFormContent(context)),
        trailing: _buildTrailing(context),
      ),
    );
  }

  List<Widget> _buildLeading() {
    const avatarMaxRadius = 72.0;
    const avatarPadding = 16;

    return [
      _buildCatHero(avatarMaxRadius, avatarPadding),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Вітаємо!', style: TextStyle(fontSize: 24)),
        ),
      ),
    ];
  }

  Widget _buildCatHero(double avatarMaxRadius, int avatarPadding) {
    return Hero(
      tag: 'login-cat-hero',
      child: SpriteAvatar.asset(
        Sprite.grayCat.asset,
        maxRadius: avatarMaxRadius,
        scale: scaleTo((avatarMaxRadius - avatarPadding) * 2),
      ),
    );
  }

  List<Widget> _buildTrailing(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 72),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () => _processLogin(context),
              child: const Text('Увійти'),
            ),
            TextButton(
              onPressed: () => _processRegisterRedirect(context),
              child: const Text('Новий користувач?'),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildFormContent(BuildContext context) {
    // final data = Provider.of<LoginData>(context, [listen: true]);
    final data = context.watch<UserData>();

    // todo add validators

    return Column(
      children: [
        TextFormField(
          initialValue: data.email,
          validator: isEmail,
          onChanged: (newEmail) => data.email = newEmail,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextFormField(
          obscureText: true,
          initialValue: data.password,
          validator: isLongerOrEqual(8),
          onChanged: (newPassword) => data.password = newPassword,
          decoration: const InputDecoration(labelText: 'Пароль'),
        ),
      ],
    );
  }

  void _processLogin(BuildContext context) {
    final data = context.read<UserData>();
    // loginService.login(data);
    log('${data.email}, ${data.password}');
  }

  void _processRegisterRedirect(BuildContext context) {
    if (!context.mounted) return;
    final data = context.read<UserData>();

    // todo
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RegisterPage(email: data.email),
    ));
  }
}
