---
title: Reading data off-chain (StoredPublishKit + agoric follow)
source: packages/zoe/README.md
source_repo: agoric/agoric-sdk
source_commit: 940d3f0a993ca45a6bb0893bd59e6df1f22d9143
source_date: 2024-07-03
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling]
status: current
---

> Abstract: How Zoe contracts publish data for off-chain readers. Contracts use `StoredPublishKit` which tees writes to off-chain storage; readers consume via `makeFollower(storeKey, makeDefaultLeader())` and `iterateLatest(follower)` for await/yield. The canonical key hierarchy lives under `published.<stream>`; non-terminal nodes could have data but mostly don't yet. High-cardinality types get a parent key for enumeration (`vaults`). Currently published streams include `priceAggregator`. The demo flow uses `make scenario2-run-chain-economy` and `agoric follow :published.priceFeed.ATOM-USD_price_feed`.

## Reading data off-chain

Some Zoe contracts publish data using StoredPublishKit which tees writes to off-chain storage. These can then be followed off-chain like so,

```js
  const key = `published.priceAggregator`; // or whatever the stream of interest is
  const leader = makeDefaultLeader();
  const follower = makeFollower(storeKey, leader);
  for await (const { value } of iterateLatest(follower)) {
    console.log(`here's a value`, value);
  }
```

The canonical keys (under `published`) are as follows. Non-terminal nodes could have data but don't yet. A `0` indicates the index of that child in added order. To get the actual key look it up in parent. High cardinality types get a parent key for enumeration (e.g. `vaults`.)

- `published`
    - `priceAggregator`

### Demo

Start the chain in one terminal:

```sh
cd packages/cosmic-swingset
make scenario2-setup scenario2-run-chain-economy
```

Once you see a string like `block 17 commit` then the chain is available. In another terminal,

```sh
# shows keys of the priceAggregator
agd query vstorage keys 'published.priceFeed'
# follow quotes
agoric follow :published.priceFeed.ATOM-USD_price_feed
```

TODO document more of https://github.com/Agoric/documentation/issues/672

Source: [packages/zoe/README.md](https://github.com/Agoric/agoric-sdk/blob/940d3f0a993ca45a6bb0893bd59e6df1f22d9143/packages/zoe/README.md) at commit `940d3f0a`.
