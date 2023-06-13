import 'package:flutter/widgets.dart';

import 'common/enums/communication_data_status.dart';

/// A void function from the [value] of type [T].
typedef Callback<T> = void Function(T value);

/// A function that takes the [value] of type [T] and returns a value of type [R].
typedef Converter<T, R> = R Function(T value);

typedef FutureVoidCallback<TFuture> = Future<TFuture> Function();
typedef FutureCallback<TFuture, TArg> = Future<TFuture> Function(TArg);

/// A json map <String, dynamic>.
typedef JsonMap = Map<String, dynamic>;

/// A record to communicate between the login page and the init page.
typedef SessionRestorationExtra = ({bool sessionRestored});

/// A record used for the communication between collection screens and edit screens.
typedef CommunicationData<T> = ({
  T? data,
  CommunicationDataStatus status,
});

/// A function matching the [ListView.separated] and [SliverList.separated] constructors.
typedef ListBuilder = Widget Function({
  bool addAutomaticKeepAlives,
  bool addRepaintBoundaries,
  bool addSemanticIndexes,
  int? Function(Key key)? findChildIndexCallback,
  required Widget? Function(BuildContext context, int index) itemBuilder,
  required int itemCount,
  Key? key,
  required Widget Function(BuildContext context, int index) separatorBuilder,
});
