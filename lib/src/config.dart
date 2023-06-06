/// An API link.
const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:80/',
);

/// A maximum possible level of trust user can have.
const int maxUserTrust = 100;