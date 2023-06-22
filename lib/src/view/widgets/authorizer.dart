import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/query_param.dart';
import '../../common/enums/app_route.dart';
import '../../constants.dart';
import '../../data/user_data.dart';

class Authorizer extends StatefulWidget {
  static const Widget _unauthorizedPlaceholder = Center(
    child: CircularProgressIndicator(),
  );

  final Widget child;
  final Widget unauthorizedPlaceholder;

  const Authorizer({
    required this.child,
    this.unauthorizedPlaceholder = _unauthorizedPlaceholder,
    super.key,
  });

  @override
  State<Authorizer> createState() => _AuthorizerState();
}

class _AuthorizerState extends State<Authorizer> {
  bool _requestedRedirect = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = AppRoute.maybeOf(context);

    return Consumer<UserData>(
      builder: (context, data, child) {
        if (data.isLoggedIn) {
          return child ?? widget.child;
        }

        _requestLoginRedirect(context);

        return widget.unauthorizedPlaceholder;
      },
      child: kIsWeb
          ? Title(
              title: currentRoute != null ? '${currentRoute.title}$titleEnding' : 'Purriorities',
              color: Colors.white,
              child: widget.child,
            )
          : widget.child,
    );
  }

  void _requestLoginRedirect(BuildContext context) {
    if (_requestedRedirect) return;
    _requestedRedirect = true;

    final currentLocation = GoRouter.of(context).location;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      final route = AppRoute.init.params([QueryParam.redirectTo(currentLocation)]);
      log('redirecting to route $route', name: 'Authorizer');

      context.go(route);
    });
  }
}
