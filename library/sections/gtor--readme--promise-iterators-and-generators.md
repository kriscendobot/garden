---
title: gtor — promise iterators and generators (the readable/writable stream sides; async map/forEach/reduce/pipe/buffer; remote iterators; the pressure pump)
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [streams, change-propagation, eventual-send]
status: current
---

> Abstract: the getter and setter sides of a stream as developed from the promise buffer. A **promise iterator** is a readable stream: it lifts a spatial iterator into the temporal dimension (its `next` returns a promise for the next iteration) and gains asynchronous analogues of the array combinators, each lifted into the async realm. `map` runs a callback per iteration (the callback may itself return a promise) with a concurrency limit; `forEach` returns a **task** (not a plain promise) precisely because streams are unicast, so the task can propagate cancellation *upstream* to stop the producer; `reduce` aggregates via a pool of concurrent two-input jobs; `pipe`/`copy` forwards iterations to a writer and is exactly `forEach(generator.yield).then(generator.return, generator.throw)` (the yield's returned promise is what pushes pressure back through the `forEach` machine onto the iterator); `buffer` prefetches to hide round-trip latency; `all`/`join`/`read` collect the stream back into a value. A **promise generator** is the writable side: `yield`/`return`/`throw`, all returning promises for an acknowledgement iteration from the consumer, so awaiting that promise idles the producer until the consumer catches up. The buffer's `length` argument primes the acknowledgement queue, allowing that many values in flight before the producer must wait. Crucially, a promise iterator can be backed by a promise for a *remote* object (`get`/`call`/`invoke` pipeline messages to a remote reader), so an `iterate` method in that protocol lets values stream on demand over any message channel: the seam through which `@endo/exo-stream` carries a stream across a CapTP vat boundary.

## Promise iterators: lifting a spatial iterator into time

One important promise iterator lifts a spatial iterator into the temporal dimension so it can be consumed on demand over time. The conversion turns a synchronous `next` into one that returns a promise for the next iteration.

```js
function PromiseIterator(iterable) {
    this.iterator = iterate(iterable);
}
PromiseIterator.prototype.next = function () {
    return Promise.return(this.iterator.next());
};
```

The conversion may seem superfluous, but a synchronous iterator can implement array-like methods (`forEach`, `map`, `filter`, `reduce`) and so an asynchronous iterator can provide their async analogues. A `Stream.from` (analogous to `Array.from`) coerces any iterable into a stream, consuming it on demand. For example, run an indefinite sequence of jobs counting from 1, four jobs at a time:

```js
Stream.from(Iterator.range(1, Infinity))
.forEach(function (n) {
    return Promise.delay(1000).thenReturn(n);
}, null, 4)
.done();
```

### map

Asynchronous `map` consumes iterations and runs a job per iteration; unlike synchronous `map`, the callback may return a promise for its eventual result. Each result is pushed to an output reader, yielding a promise that the result has been consumed (which also signals the job completed and that `map` may schedule more work). It accepts an argument limiting the number of concurrent jobs.

### forEach

Synchronous `forEach` returns `undefined` when it is done; asynchronous `forEach` returns a promise for `undefined`, since async functions are done when their returned value settles. Because streams are **unicast**, asynchronous `forEach` returns a **task**: its result can propagate a cancellation upstream, stopping the flow of data from the producer side. The task can be forked or coerced into a promise to be shared among multiple consumers. `forEach` runs jobs in serial by default but accepts an argument to *expand* the number of concurrent jobs.

```js
var task = reader.forEach(function (n) {
    console.log("consumed", n);
    return Promise.delay(1000).then(function () {
        console.log("produced", n);
    });
})
var subtask = task.fork();
var promise = Promise.return(task);
```

### reduce

Asynchronous `reduce` aggregates values from the input reader into a promise for the composite value, using an internal pool of aggregated values and some number of concurrent two-input aggregator jobs (one value preferably from the pool, the second from the input); when the input is exhausted and one value remains, it resolves. A basis argument primes the pump.

### pipe

An asynchronous iterator has `copy`/`pipe`, sending iterations from this reader to another writer, equivalent to `forEach` to forward and `then` to terminate:

```js
iterator.copy(generator);
// is equivalent to:
iterator.forEach(generator.yield).then(generator.return, generator.throw);
```

The promise returned by `yield` applies pressure on the `forEach` machine, pushing back on the iterator. This is where the buffer's back-acknowledgement queue surfaces as observable back-pressure.

### buffer, read, all

`buffer` constructs a buffer of some capacity that tries to always have a value on hand by prefetching from its producer, avoiding round-trip latency when the producer is faster than the consumer. Going the other way, an asynchronous iterator has methods returning a promise for a collection of all source values (`all`, or for byte/character readers `join`/`read`).

### Remote iterators

A reader may be a proxy for a *remote* reader: a promise iterator can be backed by a promise for a remote object.

```js
function RemotePromiseIterator(promise) {
    this.remoteIteratorPromise = promise.invoke("iterate");
}
RemotePromiseIterator.prototype.next = function (value) {
    return this.remoteIteratorPromise.invoke("next");
};

var remoteReader = remoteFilesystem.invoke("open", "primes.txt");
var reader = new RemotePromiseIterator(remoteReader);
reader.forEach(console.log);
```

Apart from `then` and `done`, promises provide `get`, `call`, and `invoke` so promises can be created from promises and messages pipelined to remote objects. An `iterate` method should be part of that protocol to let values stream on demand over any message channel. This is the conceptual seam `@endo/exo-stream` fills: a `PassableReader` whose `next` pipelines across CapTP.

## Promise generators: the writable side and the pressure dial

A promise generator is analogous to a plain generator: it implements `yield`, `return`, and `throw` (return and throw both terminate the stream; yield accepts a value). All three return promises for an acknowledgement iteration from the consumer, so waiting on that promise idles the producer long enough for the consumer to process the data.

The number of promises held in flight is tuned by the promise buffer's `length` argument, which primes the acknowledgement queue, allowing that many values to be sent before the producer must wait for the consumer to flush.

```js
var buffer = new Buffer(1024);
function fibStream(a, b) {
    return buffer.in.yield(a)
    .then(function () {
        return fibStream(b, a + b);
    });
}
fibStream(1, 1).done();
return buffer.out;
```

If the consumer wants to terminate the producer prematurely, it calls `throw` on the corresponding promise iterator, which propagates back to the promise returned by the generator's `yield`/`return`/`throw`.

```js
buffer.out.throw(new Error("That's enough, thanks"));
```

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc` (§ Promise Iterators / Promise Generators).
