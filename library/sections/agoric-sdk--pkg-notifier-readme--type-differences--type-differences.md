---
title: Type Differences
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

`makePublishKit()` makes a `{ publisher, subscriber }` pair, while `makeSubscriptionKit()` makes a similar `{ publication, subscription }` pair and `makeNotifierKit()` makes a similar `{ updater, notifier }` pair. `publisher` and `publication` and `updater` each produce an async iteration which can be consumed using the respective corresponding `subscriber` and `subscription` and `notifier`.

`notifier` and `subscription` both directly implement the [JavaScript AsyncIterable interface](https://tc39.es/ecma262/multipage/control-abstraction-objects.html#sec-asynciterable-interface) to consume the iteration (and the `{ subscribeAfter, getUpdateSince }` Subscriber interface of `subscriber` can be sent to adaptor functions such as `subscribeEach` and `subscribeLatest` for translation to AsyncIterable). `updater` and `publication` both implement the `{ updateState, finish, fail }` IterationObserver interface defined in this package, and `publisher` implements an analogous `{ publish, finish, fail }` Publisher interface (JavaScript has no standard for producing iterations). Note that Publisher and IterationObserver provide *only* the ability to produce the iteration, while Subscriber AsyncIterable provide *only* the ability to consume the iteration.

Source: [packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
