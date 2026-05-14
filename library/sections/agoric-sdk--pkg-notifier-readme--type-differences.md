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
---

> Abstract: Three kit factories produce pairs: `makePublishKit()` → `{publisher, subscriber}`, `makeSubscriptionKit()` → `{publication, subscription}`, `makeNotifierKit()` → `{updater, notifier}`. **Consumer-side**: `notifier` and `subscription` directly implement JavaScript AsyncIterable (consumable by `for await of`); the `subscriber` exposes a `{subscribeAfter, getUpdateSince}` Subscriber interface usable with adapters like `subscribeEach` / `subscribeLatest`. **Producer-side**: `updater` and `publication` implement `{updateState, finish, fail}` (the IterationObserver interface defined by this package); `publisher` implements an analogous `{publish, finish, fail}` Publisher interface. **Lossiness**: NotifierKit is *lossy* (sampling subsets, different consumers may see different sub-sequences); SubscriptionKit is *fully lossless* (every value seen) with an opt-in *forward-lossless* mode; PublishKit is *forward-lossless* by default with opt-in *lossy*. **Use cases**: forward-lossless or fully lossless for gap-free consumers; lossy for "changing-quantity" patterns (UI consumers updating from a purse balance) where stale intermediate values can be skipped. PublishKit and NotifierKit are optimized for lossy: non-final values are only communicated at the rate they're being consumed.

# Type Differences

`makePublishKit()` makes a `{ publisher, subscriber }` pair, while `makeSubscriptionKit()` makes a similar `{ publication, subscription }` pair and `makeNotifierKit()` makes a similar `{ updater, notifier }` pair. `publisher` and `publication` and `updater` each produce an async iteration which can be consumed using the respective corresponding `subscriber` and `subscription` and `notifier`.

`notifier` and `subscription` both directly implement the [JavaScript AsyncIterable interface](https://tc39.es/ecma262/multipage/control-abstraction-objects.html#sec-asynciterable-interface) to consume the iteration (and the `{ subscribeAfter, getUpdateSince }` Subscriber interface of `subscriber` can be sent to adaptor functions such as `subscribeEach` and `subscribeLatest` for translation to AsyncIterable). `updater` and `publication` both implement the `{ updateState, finish, fail }` IterationObserver interface defined in this package, and `publisher` implements an analogous `{ publish, finish, fail }` Publisher interface (JavaScript has no standard for producing iterations). Note that Publisher and IterationObserver provide *only* the ability to produce the iteration, while Subscriber AsyncIterable provide *only* the ability to consume the iteration.

## Lossiness

An iteration subset may be a valid iteration. The types are each organized around a different way of subsetting one iteration into another.

### NotifierKit

A NotifierKit `notifier` generates *lossy* "sampling subsets" of the iteration produced by its corresponding `updater`. Different consumers may see different sampling subsets.

An iteration's *sampling subset*:
   * May omit some of the original iteration's non-final values.
   * All sampling subset non-final values are in the original's non-final values in the same order.
   * The original and the subset both have the same termination.
   * Once an original iteration value is available, either that value or a later one will become available on each sampling subset *promptly*, i.e. eventually and without waiting on any other manual steps. In other words, If a value 'a' is introduced on the producer end, then all clients either promptly see 'a', or won't see 'a' but will promptly see a successor. So if two values are added in succession, the first might not be visible to all consumers. But if a value is added and nothing follows for a while, then that value must be distributed promptly to the consumers.

### SubscriptionKit

A SubscriptionKit `subscription` generates fully *lossless* sampling subsets of the iteration produced by its corresponding `publication`, although consumers can also opt in (or be restricted) to *forward-lossless* sampling in which they see each value starting with the current value at the time when consumption starts. Since each published value will be sent to all subscribers, the SubscriptionKit should generally not be used with rapidly produced values (and since SubscriptionKit requires permanently keeping all values, it should generally not be used at all).

The *suffix subset* of a forward-lossless iteration is defined by its *starting point* in the original iteration.
* A starting point may be a non-final value or a termination.
* The suffix subset has exactly the original iteration's members from its starting point to and including its termination (e.g. if the original is { 2 5 9 13 Fail } with Fail as the termination and a starting point at 9, the subset is { 9 13 Fail }).
* When a value becomes available on the original iteration, it *promptly* becomes available on every suffix subset whose starting point is at or before that value (e.g. if the original is { 2 5 9 13 Fail } and 9 becomes available, 9 promptly becomes available to any suffix subset with a starting point of 2, 5, or 9. It does not become available to any subset starting at 13 or Fail).

The values published using the publication define the original iteration. Each consumer has a starting point in that iteration and provides access to a suffix subset from that starting point. The initial `subscription` created by the `makeSubscriptionKit()` call provides the entire iteration.

### PublishKit

A PublishKit `subscriber` generates *forward-lossless* sampling subsets of the iteration produced by its corresponding `publisher`, although consumers can also opt in (or be restricted) to lossy sampling. This flexibility is why NotifierKit and SubscriptionKit are deprecated in favor of PublishKit.

## Use Cases

If your consumers need gap-free access to a sequence of values, support forward-lossless or fully lossless iteration. Otherwise, support lossy iteration. The latter is often appropriate when the iteration represents a changing quantity, like a purse balance, and a consumer updating a UI that doesn't care to hear about any older non-final values, as they are more stale. PublishKit and NotifierKit are optimized for that, as non-final values are only communicated at the rate they're being consumed (bounded by the network round-trip time) and all other non-final values are never communicated.

Source: [packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
