# Purriorities

A Flutter frontend application for Purriorities gamified planner.

## Configuration

When compiling the client, the following constants can be specified with `--dart-define`
parameters:

### Network

> These options control the behavior of the client when sending requests to the server

- `API_BASE_URL` - a URL of the server root with the HTTP schema included. Must end with `/`.   
  The port must be specified if the server uses a port different from `80`.  
  Default: `http://localhost:80/`

### Store prices

> These options must match the values set in the server configuration to display the correct prices
> to the user.

- `LEGENDARY_LOOT_BOX_PRICE` - an integer price of Legendary loot boxes (in catnip).
  Default: `20`
- `COMMON_LOOT_BOX_PRICE` - an integer price of Regular loot boxes (in feed).
  Default: `3000`

[//]: # (- `CATNIP_TO_FEED_RATE` - an integer amount of feed can be bought for 1 unit of catnip.)

[//]: # ( Default: `1500`)
