import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/synchronizer.dart';

extension ContextSynchronizer on BuildContext {
  Synchronizer synchronizer() => read<Synchronizer>();
}
