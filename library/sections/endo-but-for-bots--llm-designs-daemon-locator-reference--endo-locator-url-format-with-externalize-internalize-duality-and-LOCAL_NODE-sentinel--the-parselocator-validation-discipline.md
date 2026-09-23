---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
title: The §parseLocator validation discipline
parent: endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
---

The §Locator Validation section names the *strict* validation
rules for standard locators:

- Protocol must be `endo://`
- Node (hostname) must be a valid 64-char hex string
- Required parameters: `id` (formula number) and `type` (formula
  type)
- Allowed parameters: `id`, `type`, `at`
- *Any other parameter causes validation failure*

The §reject-unknown-parameters discipline is the strict-parser
default. The §invitation-locators-bypass clause names the
exception: invitation locators have a `from` parameter that
`parseLocator` *would reject* — so they go through the separate
invitation-acceptance code paths in `daemon.js` and `host.js`.

The §strict-parser-with-known-exceptions pattern lets the
canonical parser stay narrow without preventing the broader
protocol from carrying extension parameters.
