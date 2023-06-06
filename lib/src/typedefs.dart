/// A void function from the [value] of type [T].
typedef Callback<T> = void Function(T value);

typedef FutureVoidCallback<TFuture> = Future<TFuture> Function();
typedef FutureCallback<TFuture, TArg> = Future<TFuture> Function(TArg);

/// A json map <String, dynamic>.
typedef JsonMap = Map<String, dynamic>;

/// A record to communicate between the login page and the init page.
typedef SessionRestorationExtra = ({bool sessionRestored});
