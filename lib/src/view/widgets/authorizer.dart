import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/app_route.dart';
import '../../data/models/user.dart';

class Authorizer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Consumer<User?>(
      builder: (context, user, child) {
        if (user != null) {
          return child ?? this.child;
        }

        _requestLoginRedirect(context);

        return unauthorizedPlaceholder;
      },
      child: child,
    );
  }

  void _requestLoginRedirect(BuildContext context) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        context.go(AppRoute.login.route);
      });
}
