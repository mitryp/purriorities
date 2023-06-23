import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../common/enums/app_route.dart';
import '../../../data/models/user.dart';
import '../../../data/user_data.dart';
import '../../../data/util/validators.dart';
import '../../../services/http/fetch/user_fetch_service.dart';
import '../../../services/http/util/fetch_service_bundle.dart';
import '../../widgets/authorizer.dart';
import '../../widgets/error_snack_bar.dart';
import '../../widgets/layouts/form_layout.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';
import '../../widgets/progress_indicator_button.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: LayoutSelector(
        mobileLayoutBuilder: (_) => const _ProfileEditPageMobileLayout(),
      ),
    );
  }
}

class _ProfileEditPageMobileLayout extends StatefulWidget {
  const _ProfileEditPageMobileLayout();

  @override
  State<_ProfileEditPageMobileLayout> createState() => _ProfileEditPageMobileLayoutState();
}

class _ProfileEditPageMobileLayoutState extends State<_ProfileEditPageMobileLayout> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  UsersFetchService get _usersFetcher => context.read<FetchServiceBundle>().usersFetchService;

  @override
  void initState() {
    super.initState();

    final user = context.read<UserData>().user!;

    _usernameController = TextEditingController(text: user.nickname);
    _emailController = TextEditingController(text: user.email);
  }

  @override
  Widget build(BuildContext context) {
    final List<(String, TextEditingController?, FormFieldValidator<String>?)> formFields = [
      ('Нікнейм', _usernameController, usernameValidator),
      ('Email', _emailController, isEmail),
      ('Новий пароль', _passwordController, optional(isLongerOrEqual(8))),
      ('Повторіть новий пароль', null, repeatPasswordValidator(_passwordController)),
    ];

    return MobileLayout.child(
      appBar: AppBar(title: const Text('Редагування персональних даних')),
      child: Selector<UserData, User>(
        selector: (context, data) => data.user!,
        builder: (context, user, child) {
          return FormLayout(
            form: Form(
              key: _formKey,
              child: Column(
                children: [
                  for (var i = 0; i < formFields.length; i++)
                    TextFormField(
                      autofocus: i == 0,
                      obscureText: i >= 2,
                      decoration: InputDecoration(labelText: formFields[i].$1),
                      controller: formFields[i].$2,
                      validator: formFields[i].$3,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                ],
              ),
            ),
            trailing: [
              const SizedBox(height: 16),
              ProgressIndicatorButton.outlined(
                onPressed: () => _processProfileSaving(user),
                child: const Text('Зберегти'),
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> _processProfileSaving(User user) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final newNickname = _usernameController.text;
    final newEmail = _emailController.text;
    final newPassword = _passwordController.text;

    if (newNickname == user.nickname && newEmail == user.email && newPassword.isEmpty) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Дані користувача не змінилися',
          backgroundColor: Colors.green[400],
        ),
      );

      return;
    }

    final res = await _usersFetcher.update(
      '',
      user.copyWith(
        nickname: newNickname,
        email: newEmail,
      ),
      oldSerializable: user,
      additionalFields: {
        'password': _passwordController.text.isEmpty ? null : _passwordController.text
      },
    );

    if (!mounted) return;

    if (res.isSuccessful) {
      final updatedUser = res.result();

      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Дані користувача успішно оновлено',
          subtitleText: user.email != updatedUser.email || _passwordController.text.isNotEmpty
              ? 'Потрібно перезайти в акаунт'
              : null,
          backgroundColor: Colors.green[400],
        ),
      );

      context.go(AppRoute.login.route);

      return;
    }

    showErrorSnackBar(
      context: context,
      content: ErrorSnackBarContent(
        titleText: 'Не вдалося оновити дані',
        subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
      ),
    );
  }
}
