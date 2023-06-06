/// An API link.
const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:80/',
);

/// A maximum possible level of trust user can have.
const int maxUserTrust = 100;

/// A price of a Golden loot box (in catnip).
const goldenLootBoxPrice = 20;

/// A price of a regular loot box (in feed).
const commonLootBoxPrice = 100;
