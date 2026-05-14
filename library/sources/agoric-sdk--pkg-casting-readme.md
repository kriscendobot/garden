---
source: packages/casting/README.md
source_repo: agoric/agoric-sdk
source_commit: 3b2612ff72002ac5cd7720c1cf65615e3b56fcff
source_date: 2024-09-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
section_count: 4
status: current
notes: Casting is the off-chain reader side of agoric-sdk's published-stream architecture. Cross-cuts with notifier (uses the same async-iterable adapters), zoe (where StoredPublishKit publishes), inter-protocol (the VaultFactory publishes its metrics). The `proof` option's three levels (strict / optimistic / none) are the production-vs-development tradeoff for validation guarantees.
---

> Abstract: `@agoric/casting` follows ocap broadcasts in a flexible future-proof way. Used to read off-chain from Agoric chain state. Four sections: overview (worked example following a mailbox on devnet using `makeLeader` / `makeCastingSpec` / `makeFollower` / `iterateLatest`), follower-options (the `proof` / `decode` / `unserializer` / `crasher` options on `makeFollower`), behind-the-scenes (network config, CosmJS state polling, Tendermint subscription refresh), and status (current dependencies + short-term goals around SharedSubscription / iterateEach / Tendermint v0.36).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-casting-readme--overview.md) | tooling, eventual-send | current |
| [follower-options](../sections/agoric-sdk--pkg-casting-readme--follower-options.md) | tooling, marshal | current |
| [behind-the-scenes](../sections/agoric-sdk--pkg-casting-readme--behind-the-scenes.md) | tooling | current |
| [status](../sections/agoric-sdk--pkg-casting-readme--status.md) | tooling, repository-governance | current |

## Cross-references

- `iterateLatest` and friends come from `@agoric/notifier` (this README explicitly names notifier as a dependency for async-iterable adapters); see `agoric-sdk--pkg-notifier-readme--*` for the underlying iteration primitives.
- The chain-state-reading flow parallels `agoric-sdk--pkg-zoe-readme--reading-data-off-chain` and `agoric-sdk--pkg-inter-protocol-readme--reading-data-off-chain`; casting is the canonical client-side library both point at.

## Source

[packages/casting/README.md](https://github.com/Agoric/agoric-sdk/blob/3b2612ff72002ac5cd7720c1cf65615e3b56fcff/packages/casting/README.md) at commit `3b2612ff`.
