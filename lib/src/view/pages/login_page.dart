import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/query_param.dart';
import '../../common/enums/app_route.dart';
import '../../common/enums/sprite.dart';
import '../../data/login_data.dart';
import '../../data/util/notifier_wrapper.dart';
import '../../data/util/validators.dart';
import '../../services/http/auth_service.dart';
import '../../services/synchronizer.dart';
import '../../util/extensions/context_synchronizer.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/layouts/form_layout.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_indicator_button.dart';
import '../widgets/sprite_avatar.dart';

// можна зберігати останню пошту в локалсторедж

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginData()),
        ProxyProvider<Dio, AuthService>(
          update: (_, value, __) => AuthService(value),
        ),
        ChangeNotifierProvider(
          create: (context) => NotifierWrapper<DioError?>(null, checkEquality: false),
        )
      ],
      child: LayoutSelector(
        mobileLayoutBuilder: (context) => const MobileLoginForm(),
      ),
    );
  }
}

class MobileLoginForm extends StatefulWidget {
  const MobileLoginForm({super.key});

  @override
  State<MobileLoginForm> createState() => _MobileLoginFormState();
}

class _MobileLoginFormState extends State<MobileLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _buttonKey = GlobalKey<ProgressIndicatorButtonState>();
  late final Synchronizer synchronizer = context.synchronizer();

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final user = await synchronizer.syncUser();

    if (user == null) return;

    _redirectToApp(sessionRestored: true);
  }

  @override
  Widget build(BuildContext context) {
    return MobileLayout.child(
      minimumSafeArea: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: FormLayout(
        leading: _buildLeading(),
        form: Form(
          key: _formKey,
          child: Builder(
            builder: (context) {
              final loginData = context.watch<LoginData>();
              final error = context.watch<NotifierWrapper<DioError?>>().data;
              final errorMessage = (error?.response?.data as Map<String, dynamic>?)?['message'];
              final errorColor = Theme.of(context).colorScheme.error;

              return Column(
                children: [
                  TextFormField(
                    initialValue: loginData.email,
                    validator: isEmail,
                    onChanged: (newEmail) => loginData.email = newEmail,
                    decoration: const InputDecoration(labelText: 'Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) => _buttonKey.currentState?.handlePress(),
                  ),
                  TextFormField(
                    obscureText: true,
                    initialValue: loginData.password,
                    validator: isLongerOrEqual(8),
                    onChanged: (newPassword) => loginData.password = newPassword,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) => _buttonKey.currentState?.handlePress(),
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: errorColor),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        trailing: _buildTrailing(context),
      ),
    );
  }

  List<Widget> _buildLeading() {
    const avatarMaxRadius = 72.0;
    const avatarPadding = 16;

    return [
      Hero(
        tag: 'login-cat-hero',
        child: SpriteAvatar.asset(
          Sprite.grayCat.animatedAsset,
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
    ];
  }

  List<Widget> _buildTrailing(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 72),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceEvenly,
          spacing: 16,
          runSpacing: 8,
          children: [
            ProgressIndicatorButton.outlined(
              key: _buttonKey,
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

  Future<void> _processLogin(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authService = context.read<AuthService>();
    final data = context.read<LoginData>();

    final res = await authService.login(email: data.email, password: data.password);

    log('$res, ${res.error?.response}');

    if (!mounted) return;
    if (!res.isSuccessful) {
      context.read<NotifierWrapper<DioError?>>().data = res.error;
      return;
    }

    _redirectToApp();
  }

  void _redirectToApp({bool sessionRestored = false}) {
    if (!mounted) return;

    final redirectPath = sessionRestored
        ? GoRouterState.of(context).queryParameters[QueryParam.redirectTo.key]
        : null;

    log('redirectPath: $redirectPath', name: 'LoginPage');

    context.go(
      AppRoute.init.params([if (redirectPath != null) QueryParam.redirectTo(redirectPath)]),
      extra: (sessionRestored: sessionRestored),
    );
  }

  void _processRegisterRedirect(BuildContext context) {
    if (!context.mounted) return;
    final data = context.read<LoginData>();

    context.push(AppRoute.register.route, extra: data.email);
  }
}
