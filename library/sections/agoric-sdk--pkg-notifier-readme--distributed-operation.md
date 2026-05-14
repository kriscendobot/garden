---
title: Distributed Operation (multicast properties + Passable + getSharable*Internals)
source: packages/notifier/README.md
source_repo: agoric/agoric-sdk
source_commit: eaef5bfd888e01d641e3e450df4809a165c68633
source_date: 2024-10-31
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, pass-style, capability-security]
status: current
notes: This is the security/capability story — the producer is not vulnerable to consumers (a malicious consumer can't break the producer or other consumers), and consumers are mutually-independent (one can't hang or starve another). The `getSharable*Internals` adapter pattern is the canonical way to bridge a remote AsyncIterable to a local-iteration-friendly form. The "Alice MUST make a local AsyncIterable for for-await-of" caveat is a non-obvious requirement.
---

> Abstract: PublishKits / NotifierKits / SubscriptionKits all multicast with good distributed-systems properties: one producer, any number of consumers; **producer not vulnerable to consumers** (no consumer can break the kit or block the producer); **consumers not vulnerable to each other** (no consumer can hang or starve another). For distributed operation **all iteration values must be Passable** (the final completion value, the failure reason, and every non-final value). The basic pattern: `makePublishKit()` creates the producer/consumer pair on the producer's site; if the producer sends the consumer the `subscriber`/`notifier`/`subscription`, the consumer receives a possibly-remote reference. `observeIteration` and the like work transparently over remote references because they only use `E()`. But **JavaScript's `for-await-of` requires a local AsyncIterable** — for distributed use Alice must call `E(subscription).getSharableSubscriptionInternals()` and pass to `makeSubscription` to get a local AsyncIterable. Generic alternative: make a new local kit on the consumer's site and `observeIteration(remoteSubscription, adapterPublication)` to mirror.

# Distributed Operation

PublishKits, NotifierKits, and SubscriptionKits can all be used in a multicast manner with good distributed systems properties, where there is only one producing site but any number of consuming sites. The producer is not vulnerable to the consumers; they cannot cause the kit to malfunction or prevent the code producing values from making progress. The consumers are not vulnerable to each other; one can't cause other consumers to hang or miss values.

For distributed operation, all the iteration values---non-final values, successful completion value, failure reason---must be [Passable](https://docs.agoric.com/guides/js-programming/far.html#pass-styles-and-harden); values that can somehow be passed between vats. The rest of this doc assumes all these values are Passable.

The `makePublishKit()` or `makeNotifierKit()` or `makeSubscriptionKit()` call makes the producer/consumer pair on the producer's site. But if Producer Paula sends Consumer Bob the `subscriber`/`notifier`/`subscription`, Bob receives a possibly-remote reference to it. Consumers of an iteration can be remote from its producer.

Bob's code above is still correct if he uses this reference directly, since `observeIteration` only needs its first argument to be a reference of some sort to an AsyncIterable conveying Passable values. This reference may be a local AsyncIterable, a local presence of a remote AsyncIterable, or a promise for a local or remote AsyncIterable. `observeIteration` only sends it eventual messages using [`E`](https://docs.agoric.com/guides/js-programming/eventual-send.html#eventual-send), and so doesn't care about those differences.

While correct, Bob's code is sub-optimal. Its distributed systems properties are not terrible, but Bob does better using `getSharableSubscriptionInternals()` (provided by SubscriptionKit). This lets Bob make a local AsyncIterable that coordinates better with Producer Paula's IterationObserver.

Subscriber Alice's above code is less forgiving. She's using JavaScript's `for`-`await`-`of` loop which requires a local AsyncIterable. It cannot handle a remote reference to an AsyncIterable at Paula's site. Alice **must** make an AsyncIterable at her site by using `getSharableSubsciptionInternals()`. She can replace her call to `consume(subscription)` with:

```js
import { makeSubscription } from '@agoric/notifier';

const localSubscription =
  makeSubscription(E(subscription).getSharableSubscriptionInternals());
consume(localSubscription);
```

The above used a SubscriptionKit. NotifierKits have a similar pair of a `getSharableNotifierInternals` method and a `makeNotifier`. However, this technique requires that Alice know what kind of possibly-remote AsyncIterable she has, and to have the required making function code locally available.

Alternatively, Alice can generically mirror any possibly remote AsyncIterable by making a new local pair and plugging them together with `observeIteration`.

```js
const {
  publication: adapterPublication,
  subscription: adapterSubscription
} = makeSubscriptionKit();
observeIteration(subscription, adapterPublication);
consume(adapterSubscription);
```

This works when `subscription` is a reference to any AsyncIterable. If Alice only needs to consume in a lossy manner, she can use `makeNotifierKit()` instead, which still works independently of what kind of AsyncIterable `subscription` is a reference to.

It is also possible to use `subscribeEach` for forward-lossless consumption of a `subscriber` or `subscription`, and `subscribeLatest` for lossy consumption of a `subscriber` or `notifier`.

Source: [packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
