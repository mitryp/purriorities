/// A URL to the server root.
/// FetchServices will add the 'api' route before the actual path of the service.
const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:80/',
);

/// A maximum possible level of trust user can have.
const double maxUserTrust = 100.0;
