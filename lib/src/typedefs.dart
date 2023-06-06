/// A void function from the [value] of type [T].
typedef Callback<T> = void Function(T value);

/// A json map <String, dynamic>.
typedef JsonMap = Map<String, dynamic>;

/// A record to communicate between the login page and the init page.
typedef SessionRestorationExtra = ({bool sessionRestored});
