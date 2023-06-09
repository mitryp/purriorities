import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/sprite.dart';
import '../../data/models/user.dart';
import '../../data/util/validators.dart';
import '../../services/http/auth_service.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/error_snack_bar.dart';
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
    final List<(String, TextEditingController?, FormFieldValidator<String>?)> formFields = [
      ('Нікнейм', _usernameController, usernameValidator),
      ('Email', _emailController, isEmail),
      ('Пароль', _passwordController, isLongerOrEqual(8)),
      ('Повторіть пароль', null, repeatPasswordValidator(_passwordController)),
    ];

    return MobileLayout.child(
      appBar: AppBar(),
      minimumSafeArea: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: FormLayout(
        form: Form(
          key: _formKey,
          child: Column(
            children: [
              for (var i = 0; i < formFields.length; i++)
                TextFormField(
                  autofocus: i == 0,
                  controller: formFields[i].$2,
                  decoration: InputDecoration(labelText: formFields[i].$1),
                  obscureText: i >= 2,
                  validator: formFields[i].$3,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
            ],
          ),
        ),
        leading: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Hero(
                  tag: 'login-cat-hero',
                  child: SpriteAvatar.asset(
                    Sprite.grayCat.animatedAsset,
                    maxRadius: 48,
                    scale: scaleTo(64),
                  ),
                ),
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
            child: ProgressIndicatorButton.elevated(
              onPressed: _processRegister,
              child: const Text('Продовжити'),
            ),
          ),
        ],
      ),
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
    );

    final res = await authService.register(user, password);

    if (!mounted) return;

    if (res.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: ListTile(
          tileColor: Theme.of(context).cardColor,
          title: const Text('Ви успішно зареєструвалися!'),
          subtitle: const Text('Все, що залишилось - увійти в акаунт'),
        ),
      );
      context.pop();

      return;
    }

    showErrorSnackBar(
      context: context,
      content: ErrorSnackBarContent(
        titleText: 'Під час реєстрації сталася помилка',
        subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
      ),
    );
  }
}
