import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/app_route.dart';
import '../../common/enums/query_param.dart';
import '../../services/cats_info_cache.dart';
import '../../typedefs.dart';
import '../../util/extensions/context_synchronizer.dart';
import '../widgets/error_snack_bar.dart';
import '../widgets/layouts/mobile.dart';

class InitPage extends StatefulWidget {
  final bool sessionRestored;

  const InitPage({this.sessionRestored = false, super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool _isRedirecting = false;

  late bool _isUserLoaded = widget.sessionRestored;
  bool _isCatsInfoLoaded = false;
  bool _areQuestsLoaded = false;
  bool _isDefaultCategoryLoaded = false;
  String _loadingLabel = 'Ініціалізація';

  late final _synchronizer = context.synchronizer();

  @override
  void initState() {
    super.initState();
    _initLoadingFlow();
  }

  Future<void> _initLoadingFlow() async {
    final List<FutureVoidCallback<bool>> loaders = [
      _loadCats,
      _loadUser,
      _loadQuests,
      _loadDefaultCategory,
    ];

    for (final loader in loaders) {
      final isSuccessful = await loader();
      if (!isSuccessful) break;
    }

    final progress = progressValues;

    if (progress.actual != progress.total) {
      return _requestLoginRedirect();
    }

    _requestAppRedirect();
  }

  Future<bool> _loadUser() async {
    if (widget.sessionRestored) return true;

    return _loadStage(
      loader: _synchronizer.syncUser,
      label: 'Шукаємо користувача',
      errorText: 'Не вдалось синхронізувати дані користувача',
      onSuccess: () => _isUserLoaded = true,
    );
  }

  Future<bool> _loadCats() async => _loadStage(
        loader: context.read<CatsInfoCache>().loadCats,
        label: 'Збираємо котиків',
        errorText: 'Не вдалось завантажити котиків',
        errorPredicate: (loaded) => !(loaded ?? false),
        onSuccess: () => _isCatsInfoLoaded = true,
      );

  Future<bool> _loadQuests() async => _loadStage(
        loader: _synchronizer.syncQuests,
        label: 'Завантажуємо квести',
        errorText: 'Не вдалось завантажити квести',
        onSuccess: () => _areQuestsLoaded = true,
      );

  Future<bool> _loadDefaultCategory() async => _loadStage(
        loader: _synchronizer.syncDefaultCategory,
        label: 'Отримуємо категорію за замовчуванням',
        errorText: 'Не вдалось завантажити початкову категорію',
        onSuccess: () => _isDefaultCategoryLoaded = true,
      );

  Future<bool> _loadStage<R>({
    required FutureVoidCallback<R?> loader,
    required String label,
    required String errorText,
    required VoidCallback onSuccess,
    Converter<R?, bool> errorPredicate = _isNull,
  }) async {
    if (!mounted || _isRedirecting) return false;
    setState(() => _loadingLabel = label);

    final res = await loader();

    if (!mounted) return false;

    if (errorPredicate(res)) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(titleText: errorText),
      );

      _requestLoginRedirect();

      return false;
    }

    setState(onSuccess);

    return true;
  }

  void _requestLoginRedirect() => _requestRedirect(AppRoute.login.route);

  void _requestAppRedirect() {
    final redirectPath = QueryParam.redirectTo.valueOf(context);

    _requestRedirect(
      AppRoute.dashboard.params([
        if (redirectPath != null) QueryParam.redirectTo(redirectPath),
      ]),
    );
  }

  void _requestRedirect(String route) {
    if (_isRedirecting) return;

    _isRedirecting = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(route);
    });
  }

  ({int total, int actual}) get progressValues {
    final progresses = [
      _isUserLoaded,
      _isCatsInfoLoaded,
      _areQuestsLoaded,
      _isDefaultCategoryLoaded,
    ];

    return (total: progresses.length, actual: progresses.fold(0, (val, e) => val + (e ? 1 : 0)));
  }

  @override
  Widget build(BuildContext context) {
    final values = progressValues;
    final indicatorValue = values.actual / values.total;

    return MobileLayout.child(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.deepPurple[100]?.withOpacity(.1),
              value: indicatorValue,
            ),
            const SizedBox.square(dimension: 36),
            Text(
              _loadingLabel,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

bool _isNull(Object? value) => value == null;
