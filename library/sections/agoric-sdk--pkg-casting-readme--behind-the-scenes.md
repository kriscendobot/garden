---
title: Behind the scenes (network config + CosmJS polling + iterateRecent adapter)
source: packages/casting/README.md
source_repo: agoric/agoric-sdk
source_commit: 3b2612ff72002ac5cd7720c1cf65615e3b56fcff
source_date: 2024-09-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling]
status: current
---

> Abstract: How the follower works internally. The **network config** contains Tendermint RPC node info for the Agoric network; `makeLeaderFromRpcAddresses` bypasses the network-config fetch. Each follower uses periodic CosmJS state polling (every X ms), refreshable via Tendermint subscription to the `state_change` event. Published string values are auto-unmarshalled but without object references — applications can pass a custom `marshaller`. The `iterateRecent` adapter transforms a follower into a local async iterator that yields only the last-queried value (no history reconstruction), as opposed to `iterateLatest` which gets every value.

## Behind the scenes

- the network config contains enough information to obtain Tendermint RPC nodes for a given Agoric network. You can use `makeLeaderFromRpcAddresses` directly if you want to avoid fetching a network-config.
- each follower uses periodic CosmJS state polling (every X milliseconds) which can be refreshed more expediently via a Tendermint subscription to the corresponding `state_change` event
- published (string) values are automatically unmarshalled, but without object references. a custom `marshaller` for your application.
- the `iterateRecent` adapter transforms a follower into a local async iterator that produces only the last queried value (with no history reconstruction)

Source: [packages/casting/README.md](https://github.com/Agoric/agoric-sdk/blob/3b2612ff72002ac5cd7720c1cf65615e3b56fcff/packages/casting/README.md) at commit `3b2612ff`.
