import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/app_route.dart';
import '../../services/cats_info_cache.dart';
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
  bool _isUserLoaded = false;
  bool _isCatsInfoLoaded = false;
  String _loadingLabel = 'Ініціалізація';

  @override
  void initState() {
    super.initState();
    _initLoadingFlow();
  }

  Future<void> _initLoadingFlow() async {
    await _loadCats();
    await _loadUser();

    final progress = progressValues;

    if (progress.actual != progress.total) return _requestLoginRedirect();
    _requestAppRedirect();
  }

  Future<void> _loadUser() async {
    setState(() => _loadingLabel = 'Завантаження користувача');

    final sync = context.synchronizer();
    final user = await sync.syncUser();

    if (!mounted) return;

    if (user == null) {
      if (widget.sessionRestored) {
        showErrorSnackBar(
          context: context,
          content: const ErrorSnackBarContent(
            titleText: 'Не вдалось синхронізувати дані користувача',
          ),
        );
      }

      _requestLoginRedirect();

      return;
    }

    setState(() => _isUserLoaded = true);
    return;
  }

  Future<void> _loadCats() async {
    setState(() => _loadingLabel = 'Завантаження котиків');

    final catsCache = context.read<CatsInfoCache>();
    final loaded = await catsCache.loadCats();

    if (!mounted) return;

    if (!loaded) {
      if (widget.sessionRestored) {
        showErrorSnackBar(
          context: context,
          content: const ErrorSnackBarContent(
            titleText: 'Не вдалось завантажити інформацію про котиків',
          ),
        );
      }

      _requestLoginRedirect();

      return;
    }

    setState(() => _isCatsInfoLoaded = true);
    return;
  }

  void _requestLoginRedirect() => _requestRedirect(AppRoute.login);

  void _requestAppRedirect() => _requestRedirect(AppRoute.dashboard);

  void _requestRedirect(AppRoute route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(route.route);
    });
  }

  ({int total, int actual}) get progressValues {
    final progresses = [_isUserLoaded, _isCatsInfoLoaded];

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
