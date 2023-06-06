
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A [Storage] interface implementation using a [FlutterSecureStorage] storage to store the
/// key-value cookie pairs.
class SecureCookieStorage extends Storage {
  final FlutterSecureStorage _storage;

  const SecureCookieStorage(this._storage);

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {}

  @override
  Future<void> deleteAll(List<String> keys) =>
      Future.forEach(keys, (key) => _storage.delete(key: key));

  @override
  Future<void> delete(String key) => deleteAll([key]);

  @override
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);
}
