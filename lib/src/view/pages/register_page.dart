import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/user_data.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/sprite_avatar.dart';

class RegisterPage extends StatelessWidget {
  final String? _cachedEmail;

  const RegisterPage({String? email, super.key}) : _cachedEmail = email;

  @override
  Widget build(BuildContext context) {
    return LayoutSelector(
      mobileLayoutBuilder: (context) => MobileRegisterForm(email: _cachedEmail),
      desktopLayoutBuilder: (context) => const Placeholder(),
    );
  }
}

class MobileRegisterForm extends StatelessWidget {
  final String? _cachedEmail;

  const MobileRegisterForm({String? email, super.key}) : _cachedEmail = email;

  @override
  Widget build(BuildContext context) {
    return MobileLayout.child(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Hero(
                      tag: 'login-cat-hero',
                      child: SpriteAvatar.asset(
                        'assets/gray-cat.webp',
                        maxRadius: 48,
                        scale: scaleTo(64),
                      ),
                    ),
                    const SizedBox.square(dimension: 16,),
                    const Text('Реєстрація', style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: buildFormContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildFormContent(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: '',
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Нікнейм'),
        ),
        TextFormField(
          initialValue: _cachedEmail,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextFormField(
          initialValue: '',
          decoration: const InputDecoration(labelText: 'Пароль'),
        ),
        TextFormField(
          initialValue: '',
          decoration: const InputDecoration(labelText: 'Повторіть пароль'),
        ),
      ],
    );
  }
}
