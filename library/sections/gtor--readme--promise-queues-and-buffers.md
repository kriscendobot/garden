---
title: gtor — promise queues and buffers (the asynchronous linked-list queue; semaphore-as-queue; the two-queue buffer that realizes pressure)
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [streams, change-propagation]
status: current
---

> Abstract: the queue substrate that every Endo stream and pubsub topic is built on. A **promise queue** is an asynchronous collection where you can `get` a promise for the next value *before* that value is `put` (the dual of attaching an observer to a promise before it resolves); internally it is "an asynchronous linked list that tracks the `head` promise and `tail` deferred," `get` advancing the head and `put` advancing the tail. This is the exact "async-singly-linked-list queue" that `@endo/stream`'s `makeQueue` realizes as promise-chain cons-cells (named in endo#1444) and that `@endo/pubsub`'s sink/spring linked list rides on. A promise queue has no notion of termination. A **promise buffer** composes *two* promise queues, one `outbound` (producer to consumer) and one `inbound` (consumer-ready acknowledgements back to producer): the back-acknowledgement queue is precisely how gtor's **pressure** is realized in code, since each `yield`/`next` returns the opposite queue's `get` promise and so stalls until the other side acts. The buffer thus has an asynchronous iterator (the readable, getter side) and an asynchronous generator (the writable, setter side); because object-stream input and output are perfectly symmetric (treating `yield` and `next` as synonyms) a single constructor serves as both reader and writer. The section also shows a **semaphore** built directly from a promise queue: a non-blocking pool of N resources where `get` downs and `put` ups, replacing thread-blocking with promise-returning.

## Promise queues: get before put

With a conventional queue you must put a value in before you can take it out. Not so for a promise queue: just as you can attach an observer to a promise before it resolves, you can `get` a promise for the next value in order before that value has been `put` (and of course you can `put` before you `get`).

```js
var queue = new Queue();
queue.get().then(function (value) {
    console.log(value);
})
queue.put("Hello, World!");
```

Although promises come out in the same order their resolutions enter, a promise obtained later may settle sooner than another, and the values put in may themselves be promises. A promise queue qualifies as an asynchronous collection, specifically a collection of *results*: values or thrown errors captured by promises. It is not particular about what those values mean and is a suitable primitive for many more interesting tools.

| Interface     |         |        |          |
| ------------- | ------- | ------ | -------- |
| PromiseQueue  | Value   | Plural | Temporal |
| queue.get     | Getter  | Plural | Temporal |
| queue.put     | Setter  | Plural | Temporal |

The implementation (from Mark Miller's Concurrency Strawman, exported by Q's `q/queue`) is an asynchronous linked list tracking the `head` promise and `tail` deferred. `get` advances the head; `put` advances the tail.

```js
function PromiseQueue() {
    if (!(this instanceof PromiseQueue)) {
        return new PromiseQueue();
    }
    var ends = Promise.defer();
    this.put = function (value) {
        var next = Promise.defer();
        ends.resolve({
            head: value,
            tail: next.promise
        });
        ends.resolve = next.resolve;
    };
    this.get = function () {
        var result = ends.promise.get("head");
        ends.promise = ends.promise.get("tail");
        return result;
    };
}
```

It is important that `get` can be passed to a consumer and `put` to a producer separately, to preserve the principle of least authority and the unidirectional flow of data from producer to consumer. A promise queue has no notion of termination, graceful or otherwise; a *pair* of promise queues is later used to transport iterations between streams.

## Semaphores: a queue as a non-blocking resource pool

In a reactive program we do not block; instead of blocking we return promises and continue when a promise resolves. A promise can serve as a non-blocking mutex for a single resource, and a **promise queue as a non-blocking semaphore for multiple resources**. The pool's `get` "downs" the semaphore (take a resource) and `put` "ups" it (return the resource), regardless of whether the work succeeded or failed.

```js
var connections = new Queue();
connections.put(connectToDb());
connections.put(connectToDb());
connections.put(connectToDb());

function work() {
    return connections.get()
    .then(function (db) {
        return workWithDb(db)
        .finally(function () {
            connections.put(db);
        })
    });
}
```

## Promise buffers: two queues make pressure

To keep a producer from outrunning a consumer, put a **buffer** between them that regulates flow rate. The buffer uses one promise queue to transport values from producer to consumer (`outbound`) and another to communicate that the consumer is ready for the next value (`inbound`). Each side's method returns the *opposite* queue's `get`, so a write stalls until the reader acknowledges and a read stalls until the writer produces: this returned-acknowledgement-promise is gtor's **pressure** made concrete.

```js
var outbound = new PromiseQueue();
var inbound = new PromiseQueue();
var buffer = {
    out: {
        next: function (value) {
            outbound.put({ value: value, done: false });
            return inbound.get();
        },
        return: function (value) {
            outbound.put({ value: value, done: true })
            return inbound.get();
        },
        throw: function (error) {
            outbound.put(Promise.throw(error));
            return inbound.get();
        }
    },
    in: {
        yield: function (value) {
            inbound.put({ value: value, done: false })
            return outbound.get();
        },
        return: function (value) {
            inbound.put({ value: value, done: true })
            return outbound.get();
        },
        throw: function (error) {
            inbound.put(Promise.throw(error));
            return outbound.get();
        }
    }
};
```

The buffer uses iterator/generator vernacular, but each name has a stream equivalent:

- `in.yield` means "write".
- `in.return` means "close".
- `in.throw` means "terminate prematurely with an error".
- `out.next` means "read".
- `out.throw` means "abort or cancel with an error".
- `out.return` means "abort or cancel prematurely but without an error".

So a buffer is a reactive interface: an asynchronous iterator (the getter side, a readable stream) and an asynchronous generator (the setter dual, a writable stream), with the buffer itself an asynchronous plural value. Beyond triangulating synchronous iterables and asynchronous promises, it solves the real need for streams that support pressure to regulate flow and avoid over-commitment.

| Stream            |         |          |              |
| ----------------- | ------- | -------- | ------------ |
| Promise Buffer    | Value   | Plural   | Temporal     |
| Promise Iterator  | Getter  | Plural   | Temporal     |
| Promise Generator | Setter  | Plural   | Temporal     |

In the object-stream case, treating `yield` and `next` as synonyms makes input and output perfectly symmetric, so a single constructor can serve as both reader and writer. Following the Revealing Constructor pattern (as standard promises hide `Promise.defer()` behind the `Promise` constructor), the buffer constructor can be hidden and only the input side revealed as arguments to the output-stream constructor; the analogue to `Promise.defer()` would be `Stream.buffer()`, returning an `{in, out}` pair of entangled streams.

```js
var reader = new Stream(function (write, close, abort) {
    // ...
});
```

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc` (§ Promise Queues / Semaphores / Promise Buffers).
