---
title: Use Cases
source: packages/notifier/README.md
source_repo: agoric/agoric-sdk
source_commit: 2026-10-31
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: The three lossiness modes — fully lossless / forward-lossless / lossy — are the central design dimension. PublishKit's flexibility (a single publisher serving both forward-lossless `subscribeAfter` and lossy `getUpdateSince` consumers) is why NotifierKit and SubscriptionKit are deprecated. The "non-final values are only communicated at the rate they're being consumed (bounded by round-trip time)" property is the load-bearing optimization for lossy kits.
parent: agoric-sdk--pkg-notifier-readme--type-differences
---

If your consumers need gap-free access to a sequence of values, support forward-lossless or fully lossless iteration. Otherwise, support lossy iteration. The latter is often appropriate when the iteration represents a changing quantity, like a purse balance, and a consumer updating a UI that doesn't care to hear about any older non-final values, as they are more stale. PublishKit and NotifierKit are optimized for that, as non-final values are only communicated at the rate they're being consumed (bounded by the network round-trip time) and all other non-final values are never communicated.

Source: [packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
