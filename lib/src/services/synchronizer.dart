import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../data/models/user.dart';
import '../data/util/notifier_wrapper.dart';
import 'http/fetch/user_fetch_service.dart';

class Synchronizer {
  final BuildContext _context;
  final UsersFetchService _userFetchService;

  const Synchronizer(this._context, this._userFetchService);

  Future<User?> syncUser() async {
    final user = await _userFetchService.me().then((res) => res.isSuccessful ? res.result() : null);

    // ignore: use_build_context_synchronously
    if (!_context.mounted) return null;

    _context.read<NotifierWrapper<User?>>().data = user;

    return user;
  }
}
