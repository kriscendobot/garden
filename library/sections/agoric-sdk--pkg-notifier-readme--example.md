---
title: Example (Paula publishes, Alice/Bob/Carol consume)
source: packages/notifier/README.md
source_repo: agoric/agoric-sdk
source_commit: eaef5bfd888e01d641e3e450df4809a165c68633
source_date: 2024-10-31
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
notes: The Alice/Bob/Carol trio demonstrates three consumer patterns: `for await of` (loses the completion value of Finish; only the non-final values + did-finish flag are observable), `observeIteration(asyncIterableP, observer)` (gets non-final + completion value + failure reason), and the lower-level `ForkableAsyncIterable` interface with `fork()` for forking at a chosen point. The forking pattern is non-obvious — `subscriptionIterator.fork()` creates an iterator that starts from the parent's current position.
---

> Abstract: Walked example using `makeSubscriptionKit()` with three published values ('a', 'b', then `finish('done')`). Three consumers: **Alice** uses `for await of subscription` — sees non-final values and whether the iteration finished/failed, but **cannot see the completion value 'done'** (JavaScript iteration limitation). **Bob** uses `observeIteration(subscription, observer)` with `{updateState, finish, fail}` observer — sees everything including the completion value. **Carol** uses the lower-level `ForkableAsyncIterable` interface directly: she gets `subscription[Symbol.asyncIterator]()`, listens for 'a' via her observer, and calls `subscriptionIterator.fork()` to capture a new iterator starting from that point — useful for "branch off the iteration once condition X is met" patterns. Note: SubscriptionKits are fully lossless; NotifierKits are lossy and the same example with `makeNotifierKit()` would still be correct but Alice and Bob might miss either non-final value.

# Example

Let's look at a subscription example. We have three characters: Paula the publisher, and Alice and Bob the subscribers. While Alice and Bob both consume Paula's published iteration, they use different tools to do so.

First we create a publication/subscription pair with `makeSubscriptionKit()`. Paula publishes an iteration with the sequence `'a'`, `'b'`, and then terminates it with `'done'` as the completion value.

```js
const { publication, subscription } = makeSubscriptionKit();
// Paula the publisher says
publication.updateState('a');
publication.updateState('b');
publication.finish('done');
```

You can use the JavaScript AsyncIterable interface directly, but both the JavaScript `for`-`await`-`of` syntax and the `observeIteration` adaptor are more convenient.

Subscriber Alice consumes the iteration using a `for`-`await`-`of` loop. She can see the non-final values and whether the iteration completes or fails. She can see a failure reason, but the `for`-`await`-`of` syntax does not let her see the completion value `'done'`. While she can write code that only executes after the loop finishes, that code won't know if the completion value was "done", "completed", or something else. This is a limitation of JavaScript's iteration, whether asynchronous or synchronous (as consumed by a `for`-`of` loop).

```js
const consume = async subscription => {
  try {
    for await (const val of subscription) {
      console.log('non-final', val);
    }
    console.log('the iteration finished');
  } catch (reason) {
    console.log('the iteration failed', reason);
  }
};
consume(subscription);
// eventually prints
// non-final a
// non-final b
// the iteration finished
```

Subscriber Bob consumes using the `observeIteration(asyncIterableP, iterationObserver)` adaptor.

```js
const observer = harden({
  updateState: val => console.log('non-final', val),
  finish: completion => console.log('finished', completion),
  fail: reason => console.log('failed', reason),
});
observeIteration(subscription, observer);
// eventually prints
// non-final a
// non-final b
// finished done
```

The iterators associated with `subscription` and iterables from `subscribeEach` and `subscribeLatest` adaptors further implement a ForkableAsyncIterable interface allowing them to produce any number of ForkableAsyncIterators that each advance independently from a starting point that is the current position of the parent ForkableAsyncIterator at the time of calling `fork()`.

Carol's code is like Bob's except lower level, using the ForkableAsyncIterable interface directly.

```js
import { makePromiseKit } from '@endo/promise-kit';

const subscriptionIterator = subscription[Symbol.asyncIterator]();
const { promise: afterA, resolve: afterAResolve } = makePromiseKit();

const observer = harden({
  updateState: val => {
    if (val === 'a') {
      afterAResolve(subscriptionIterator.fork());
    }
    console.log('non-final', val);
  },
  finish: completion => console.log('finished', completion),
  fail: reason => console.log('failed', reason),
});

observeIterator(subscriptionIterator, observer);
// eventually prints
// non-final a
// non-final b
// finished done

// afterA is a Promise<ForkableAsyncIterator> so we use observeIterator on it.
observeIterator(afterA, observer);
// eventually prints
// non-final b
// finished done
```

Remember that SubscriptionKits are *fully lossless*. Each one conveys all of an async iteration's non-final values, as well as the final value.

On the other hand, NotifierKit is a *lossy* conveyor of non-final values, but does also losslessly convey termination. Had the example above started with the following instead of using `makeSubscriptionKit()`,

```js
const { updater: publication, notifier: subscription } = makeNotifierKit();
```

The code is still correct. However, Alice and Bob may each have missed either or both of the non-final values due to NotifierKit's lossy nature.

On yet another hand (🤷), the `subscriber` of a Publication includes both a `subscribeAfter(publishCount?)` method for forward-lossless iteration and a `getUpdateSince(publishCount?)` method for lossy iteration. `publishCount` is a gap-free sequence of bigints that starts at 1 for the first result.

Source: [packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
