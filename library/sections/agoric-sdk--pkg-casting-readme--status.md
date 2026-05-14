---
title: Status (dependencies + short-term goals)
source: packages/casting/README.md
source_repo: agoric/agoric-sdk
source_commit: 3b2612ff72002ac5cd7720c1cf65615e3b56fcff
source_date: 2024-09-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, repository-governance]
status: current
notes: The short-term goals were authored in 2022 (the README is from 2024-09-10 but the goals predate). The cosmjs-i#492 link about light-client validator-set tracking and the SharedSubscription API integration are still relevant directions. The makePublisherKit reference (`#5418`) presumably landed before this package was finalized — track for staleness.
---

> Abstract: Dependencies: Hardened JavaScript, `@agoric/notifier` (async-iterable adapters for `iterateLatest`), `@endo/marshal` (default object unserialization), CosmJS (proof verification; doesn't yet support light-client validator-set tracking per cosmjs#492), bespoke WebSocket Tendermint event follower. Short-term goals: integrate the SharedSubscription API from agoric-sdk#5418 `makePublisherKit` PR, support `iterateEach` with the lossless-forward-iteration algorithm via agoric-sdk#5466 `x/vstream` PR, upgrade to Tendermint v0.36 event-log API when supported.

## Status

This package currently depends on:

- Hardened Javascript
- [@agoric/notifier](../notifier) async iterable adapters to implement `iterateLatest`
- [@endo/marshal](https://www.npmjs.com/package/@endo/marshal) for default object unserialization
- [CosmJS](https://github.com/cosmos/cosmjs) for proof verification, although [it does not yet support light client tracking of the validator set](https://github.com/cosmos/cosmjs/issues/492)
- a bespoke follower of [WebSocket Tendermint events](https://docs.tendermint.com/master/tendermint-core/subscription.html#legacy-streaming-api)

Short-term goals:
- integrate the new [SharedSubscription API](https://github.com/Agoric/agoric-sdk/pull/5418#discussion_r886253328) from the [Agoric/agoric-sdk#5418 `makePublisherKit` PR](https://github.com/Agoric/agoric-sdk/pull/5418)
- support `iterateEach` with the [lossless forward iteration algorithm](https://github.com/Agoric/agoric-sdk/blob/mfig-vstream/golang/cosmos/x/vstream/spec/01_concepts.md#forward-iteration-lossless-history) via the [Agoric/agoric-sdk#5466 `x/vstream` PR](https://github.com/Agoric/agoric-sdk/pull/5466)
- upgrade to the [Tendermint event log API](https://docs.tendermint.com/master/tendermint-core/subscription.html#event-log-api) when Tendermint v0.36 is supported by the Agoric chain

Source: [packages/casting/README.md](https://github.com/Agoric/agoric-sdk/blob/3b2612ff72002ac5cd7720c1cf65615e3b56fcff/packages/casting/README.md) at commit `3b2612ff`.
