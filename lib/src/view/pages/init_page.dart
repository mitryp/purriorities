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
  late bool _isUserLoaded = widget.sessionRestored;
  bool _isCatsInfoLoaded = false;
  bool _areQuestsLoaded = false;
  String _loadingLabel = 'Ініціалізація';

  late final _synchronizer = context.synchronizer();

  @override
  void initState() {
    super.initState();
    _initLoadingFlow();
  }

  Future<void> _initLoadingFlow() async {
    await _loadCats();
    await _loadUser();
    await _loadQuests();

    final progress = progressValues;

    if (progress.actual != progress.total) return _requestLoginRedirect();
    _requestAppRedirect();
  }

  Future<void> _loadUser() async {
    if (!mounted) return;
    setState(() => _loadingLabel = 'Завантаження користувача');

    final user = await _synchronizer.syncUser();

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
  }

  Future<void> _loadCats() async {
    if (!mounted) return;
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
  }

  Future<void> _loadQuests() async {
    if (!mounted) return;
    setState(() => _loadingLabel = 'Завантаження квестів');

    final quests = await _synchronizer.syncQuests();

    if (!mounted) return;

    if (quests == null) {
      showErrorSnackBar(
        context: context,
        content: const ErrorSnackBarContent(titleText: 'Не вдалось завантажити квести'),
      );

      _requestLoginRedirect();

      return;
    }

    setState(() => _areQuestsLoaded = true);
  }

  void _requestLoginRedirect() => _requestRedirect(AppRoute.login);

  void _requestAppRedirect() => _requestRedirect(AppRoute.dashboard);

  void _requestRedirect(AppRoute route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(route.route);
    });
  }

  ({int total, int actual}) get progressValues {
    final progresses = [_isUserLoaded, _isCatsInfoLoaded, _areQuestsLoaded];

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
