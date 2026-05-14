---
title: Reading data off-chain (the published.* key hierarchy)
source: packages/inter-protocol/README.md
source_repo: agoric/agoric-sdk
source_commit: 52f5366444ac021998ced6afc3a7d67c832ccdb0
source_date: 2024-06-11
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling]
status: current
notes: This is the canonical map of the Inter Protocol's off-chain-readable state. The `vaultFactory.managers.manager0.vaults.vault0` enumeration pattern (high-cardinality types get a parent key for enumeration) is the same pattern from agoric-sdk--pkg-zoe-readme--reading-data-off-chain — both packages publish under `published.*` and share the enumeration convention.
---

> Abstract: VaultFactory publishes via `StoredPublishKit` to off-chain storage; readers consume with `@agoric/casting`'s `makeFollower` + `iterateLatest`. The canonical key hierarchy under `published`: **vaultFactory** (with `governance`, `metrics`, and `managers.managerN.{metrics, governance, vaults.vaultN}`), **auction** (`schedule`, `governance`, `book0`), **reserve** (`governance`, `metrics`), **priceFeed** (per-pair `${input}-${output}_price_feed` with `.latestRound` sub-key), **psm** (`<minted>.<anchor>.{governance, metrics}`), **committees** (`Economic_Committee.{latestQuestion, latestOutcome}`).

## Reading data off-chain

VaultFactory publishes data using StoredPublishKit which tees writes to off-chain storage. These can then be followed off-chain like so,

```js
import { makeFollower } from '@agoric/casting';

  const key = `published.vaultFactory.metrics`; // or whatever the stream of interest is
  const leader = makeDefaultLeader();
  const follower = makeFollower(storeKey, leader);
  for await (const { value } of iterateLatest(follower)) {
    console.log(`here's a value`, value);
  }
```

The canonical keys (under `published`) are as follows. Non-terminal nodes could have data but don't yet. A `0` indicates the index of that child in added order. To get the actual key look it up in parent. High cardinality types get a parent key for enumeration (e.g. `vaults`.)

- `published`
    - `vaultFactory` - [snapshot of details](./test/vaultFactory/snapshots/vaultFactory.test.js.md)
        - `governance`
        - `metrics`
        - `managers`
          - `manager0`
              - `metrics`
              - `governance`
              - `vaults`
                - `vault0`
    - `auction` - [snapshot of details](./test/auction/snapshots/auctionContract.test.js.md)
        - `schedule`
        - `governance`
        - `book0`
    - `reserve` - [snapshot of details](./test/reserve/snapshots/reserve.test.js.md)
      - `governance`
      - `metrics`
    - `priceFeed` - [snapshot of details](./test/price/snapshots/fluxAggregatorKit.test.js.md)
      - `${inputBrand}-${outputBrand}_price_feed`
      - `${inputBrand}-${outputBrand}_price_feed.latestRound`
    - `psm` - [snapshot of details](./test/psm/snapshots/psm.test.js.md)
      - `<minted>`
        - `<anchor>`
          - `governance`
          - `metrics`
    - `committees` - [snapshot of details](../governance/test/unitTests/snapshots/committee.test.js.md)
        - `Economic_Committee`
          - `latestQuestion`
          - `latestOutcome`

Source: [packages/inter-protocol/README.md](https://github.com/Agoric/agoric-sdk/blob/52f5366444ac021998ced6afc3a7d67c832ccdb0/packages/inter-protocol/README.md) at commit `52f53664`.
