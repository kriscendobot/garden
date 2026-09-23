---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
title: The §three-locator-format family
parent: endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
---

The §Locator Format section defines three URL shapes:

### Standard locator

```
endo://{nodeNumber}/?id={formulaNumber}&type={formulaType}
```

| Component | Description |
|-----------|-------------|
| `nodeNumber` | 64-char hex Ed25519 public key of the peer that hosts the formula |
| `formulaNumber` | 64-char hex formula number (SHA-256 content address or random capability address) |
| `formulaType` | `host` / `guest` / `handle` / `worker` / `directory` / `remote` |

The §standard locator is the *minimum-required* form for sharing
a formula across network boundaries: *who hosts it* (the
nodeNumber, an Ed25519 public key) + *which formula* (the
formulaNumber) + *what kind of thing it is* (the type).

### Locator with connection hints

```
endo://{nodeNumber}/?id={formulaNumber}&type={formulaType}&at={address1}&at={address2}
```

The §`at` parameters are *repeated query parameters* providing
transport addresses where the peer can be reached. *Hints are
ephemeral* — they reflect the peer's *current* network
configuration and may change over time.

### Invitation locator

```
endo://{nodeNumber}/?id={invitationNumber}&type=invitation&from={hostHandleNumber}&at={address1}
```

Invitation locators extend the standard format with a `from`
parameter naming *the host's handle formula number* (used by the
accepting peer to identify the inviting host).

The §invitation-locators-parsed-separately discipline:

> *`parseLocator` validates standard locators (allowing only
> `id`, `type`, and `at` parameters), while invitation locators
> are parsed directly via `new URL()` in the invitation acceptance
> code paths.*

The §two-parsing-paths shape: standard locators go through the
strict `parseLocator` validator (rejects unknown params);
invitation locators bypass `parseLocator` because they have an
extra `from` parameter. The *two-path-validation* discipline lets
the canonical parser stay strict while the invitation flow has
its own validation in `daemon.js` and `host.js`.
