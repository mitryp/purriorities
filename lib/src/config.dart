/// An API link.
const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:80/',
);

/// A maximum possible level of trust user can have.
const double maxUserTrust = 100.0;

/// A price of a Golden loot box (in catnip).
const int goldenLootBoxPrice = 20;

/// A price of a regular loot box (in feed).
const int commonLootBoxPrice = 100;
