import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common/enums/sprite.dart';
import '../../data/models/user.dart';
import '../../data/util/validators.dart';
import '../../services/http/auth_service.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/layouts/form_layout.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_indicator_button.dart';
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

class MobileRegisterForm extends StatefulWidget {
  final String? _cachedEmail;

  const MobileRegisterForm({String? email, super.key}) : _cachedEmail = email;

  @override
  State<MobileRegisterForm> createState() => _MobileRegisterFormState();
}

class _MobileRegisterFormState extends State<MobileRegisterForm> {
  late final TextEditingController _usernameController = TextEditingController(),
      _emailController = TextEditingController(text: widget._cachedEmail),
      _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MobileLayout.child(
      appBar: AppBar(),
      minimumSafeArea: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: FormLayout(
        form: Form(
          key: _formKey,
          child: _buildFormContent(),
        ),
        leading: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                _buildCatHero(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Реєстрація', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          )
        ],
        trailing: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 72),
            child: ProgressIndicatorButton(
              onPressed: _processRegister,
              buttonBuilder: ({required child, required onPressed, style}) => ElevatedButton(
                onPressed: onPressed,
                style: style,
                child: child,
              ),
              child: const Text('Продовжити'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatHero() {
    return Hero(
      tag: 'login-cat-hero',
      child: SpriteAvatar.asset(
        Sprite.grayCat.asset,
        maxRadius: 48,
        scale: scaleTo(64),
      ),
    );
  }

  Column _buildFormContent() {
    final List<(String, TextEditingController?, FormFieldValidator<String>?)> formFields = [
      ('Нікнейм', _usernameController, usernameValidator),
      ('Email', _emailController, isEmail),
      ('Пароль', _passwordController, isLongerOrEqual(8)),
      ('Повторіть пароль', null, _repeatPasswordValidator),
    ];

    return Column(
      children: [
        for (var i = 0; i < formFields.length; i++)
          TextFormField(
            autofocus: i == 0,
            controller: formFields[i].$2,
            decoration: InputDecoration(labelText: formFields[i].$1),
            validator: formFields[i].$3,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
      ],
    );
  }

  String? _repeatPasswordValidator(String? value) {
    if (_passwordController.text == value) {
      return null;
    }

    return 'Паролі повинні співпадати';
  }

  Future<void> _processRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authService = context.read<AuthService>();

    final nickname = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final user = User.register(
      nickname: nickname,
      email: email,
      locale: Intl.systemLocale,
      timezone: DateTime.now().timeZoneName,
    );

    final res = await authService.register(user, password);

    log('Registering user with $nickname, $email, $password. Got $res');
  }
}
