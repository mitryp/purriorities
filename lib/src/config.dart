/// A URL to the server root.
/// FetchServices will add the 'api' route before the actual path of the service.
const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:80/',
);

/// A maximum possible level of trust user can have.
const double maxUserTrust = 100.0;

/// A price of a legendary loot box (in catnip).
const int legendaryLootBoxPrice = int.fromEnvironment(
  'LEGENDARY_LOOT_BOX_PRICE',
  defaultValue: 20,
);

/// A price of a regular loot box (in feed).
const int commonLootBoxPrice = int.fromEnvironment(
  'COMMON_LOOT_BOX_PRICE',
  defaultValue: 3000,
);

/// An amount of feed can be bought for 1 unit of catnip currency.
// const int catnipToFeedExchangeRate = int.fromEnvironment(
//   'CATNIP_TO_FEED_RATE',
//   defaultValue: 1500,
// );

// todo due to the issues with the dart2js compiler, had to hardcode the value
/// An amount of feed can be bought for 1 unit of catnip currency.
const int catnipToFeedExchangeRate = 1500;