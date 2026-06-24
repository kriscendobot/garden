---
title: Type Differences (Publisher/IterationObserver/Subscriber interfaces + lossiness + use cases)
source: packages/notifier/README.md
source_repo: agoric/agoric-sdk
source_commit: 2026-10-31
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: The three lossiness modes — fully lossless / forward-lossless / lossy — are the central design dimension. PublishKit's flexibility (a single publisher serving both forward-lossless `subscribeAfter` and lossy `getUpdateSince` consumers) is why NotifierKit and SubscriptionKit are deprecated. The "non-final values are only communicated at the rate they're being consumed (bounded by round-trip time)" property is the load-bearing optimization for lossy kits.
kind: index
section_count: 3
---

> Abstract: Three kit factories produce pairs: `makePublishKit()` → `{publisher, subscriber}`, `makeSubscriptionKit()` → `{publication, subscription}`, `makeNotifierKit()` → `{updater, notifier}`. **Consumer-side**: `notifier` and `subscription` directly implement JavaScript AsyncIterable (consumable by `for await of`); the `subscriber` exposes a `{subscribeAfter, getUpdateSince}` Subscriber interface usable with adapters like `subscribeEach` / `subscribeLatest`. **Producer-side**: `updater` and `publication` implement `{updateState, finish, fail}` (the IterationObserver interface defined by this package); `publisher` implements an analogous `{publish, finish, fail}` Publisher interface. **Lossiness**: NotifierKit is *lossy* (sampling subsets, different consumers may see different sub-sequences); SubscriptionKit is *fully lossless* (every value seen) with an opt-in *forward-lossless* mode; PublishKit is *forward-lossless* by default with opt-in *lossy*. **Use cases**: forward-lossless or fully lossless for gap-free consumers; lossy for "changing-quantity" patterns (UI consumers updating from a purse balance) where stale intermediate values can be skipped. PublishKit and NotifierKit are optimized for lossy: non-final values are only communicated at the rate they're being consumed.

Sections:

- [Type Differences](agoric-sdk--pkg-notifier-readme--type-differences--type-differences.md)
- [Lossiness](agoric-sdk--pkg-notifier-readme--type-differences--lossiness.md)
- [Use Cases](agoric-sdk--pkg-notifier-readme--type-differences--use-cases.md)

Source: [packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
