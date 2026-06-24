---
title: gtor — asynchronous generator functions (await + yield; Promise<Iteration<T>> not Iteration<Promise<T>>; the `on` operator; copy layered on forEach on next)
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

> Abstract: how async functions and generator functions compose into the plural-temporal getter (a readable stream's standard form). The pivotal type question: should an async generator's `next` produce ``Iteration<Promise<T>>`` (an iterator of promises) or ``Promise<Iteration<T>>`` (a promise iterator)? gtor argues for **``Promise<Iteration<T>>``**, because a promise's error case should model abnormal *termination of the sequence* while an iteration's done/value should model normal continuation; putting the promise on the outside lets a transport failure terminate the sequence, whereas a promise *inside* the iteration would capture inability to transport one value without implying termination. An **asynchronous generator function** therefore uses both `await` (idle until async work settles) and `yield` (produce a value), and returns a promise iterator, the output side of a stream; the `yield` expression itself returns a promise for the value to flush, so `await`-ing it pauses the generator until the consumer catches up (the pressure handshake from the buffer). `await` and `yield` are deliberately orthogonal so a generator can yield while *ignoring* consumer pressure, forcing the iteration to buffer. The proposed `on` operator is the async analogue of `for...of` (`for (let a on anAsyncIterable)`), awaiting each promised iteration and working for synchronous iterables too since `await` accepts both values and promises. The framework keeps `iterate()` as the single async/sync analogue (differing only in the returned iterator's type) and layers `copy` on `forEach` on `next`, so the whole stream algebra reduces to the one `next` primitive.

## What type does an async generator function return?

Jafar Husain asked the committee whether generator functions and async functions compose, and how. One key question is what an async generator function returns: a promise for an iterator, or an iterator of promises?

- An ``Iterator<Promise<T>>`` produces iterations carrying promises for values (``Iteration<Promise<T>>``).
- A *promise iterator* implements `next` so it produces ``Promise<Iteration<T>>``: a promise that eventually produces an iteration containing a value.

```js
// Iteration<Promise<T>> — an iterator of promises:
var iteration = iterator.next();
iteration.value.then(function (value) {
    return callback.call(thisp, value);
});

// Promise<Iteration<T>> — a promise iterator:
promiseIterator.next()
.then(function (iteration) {
    return callback.call(thisp, iteration.value);
})
```

The deciding argument: promises capture both the value and error cases, so if `next` returns a promise, the *error* case models abnormal termination of the sequence. Iterations capture normal continuation or termination. If the value of an iteration were a promise, its error case would capture inability to transport a single value but would *not* imply termination of the sequence. In this framework the answer is clear: a promise iterator (``Promise<Iteration<T>>``) is the right shape, and an asynchronous generator returns one, the output side of a stream.

## await + yield, and the pressure handshake

An asynchronous generator function uses both `await` (idle until some asynchronous work has settled) and `yield` (produce a value). Recall an iterator returns an iteration, a promise iterator returns a *promise* for an iteration, and a promise generator returns a similar promise for the *acknowledgement* from the iterator.

```js
promiseIterator.next()
.then(function (iteration) {
    console.log(iteration.value);
    if (iteration.done) {
        console.log("fin");
    }
});

promiseGenerator.yield("alpha")
.then(function (iteration) {
    console.log("iterator has consumed alpha");
});
```

In the example below, `yield` returns a promise for the value to flush, so `await`-ing it pauses the generator until the consumer catches up:

```js
async function *shakespeare(titles) {
    for (let title of titles) {
        var quotes = await getQuotes(title);
        for (let quote of quotes) {
            await yield quote;
        }
    }
}

var reader = shakespeare(["Hamlet", "Macbeth", "Othello"]);
reader.reduce(function (length, quote) {
    return length + quote.length;
}, 0, null, 100)
.then(function (totalLength) {
    console.log(totalLength);
});
```

It is useful for `await` and `yield` to be completely orthogonal, because there are cases where one wants to yield but *ignore* pressure from the consumer, forcing the iteration to buffer.

## The `on` operator and reducing the algebra to `next`

Jafar proposes an `on` operator, the async analogue of ECMAScript 6's `of`: where `of` accepts an iterable, produces an iterator, and walks it, `on` operates on an asynchronous iterable, produces an asynchronous iterator, and `await`s each promised iteration.

```js
for (let a on anAsyncIterable) {
    console.log(a);
}

// is equivalent to:

var anAsyncIterator = anAsyncIterable[Symbol.iterate]();
while (true) {
    var anAsyncIteration = anAsyncIterator.next();
    var anIteration = await anAsyncIteration;
    if (anIteration.done) {
        break;
    } else {
        var aValue = anIteration.value;
        console.log(aValue);
    }
}
```

The `on` operator works for both asynchronous and synchronous iterators, since `await` accepts both values and promises. Where Jafar proposes a distinct `observe(generator)` async analogue of `iterate()`, gtor proposes keeping `iterate()` as the single analogue, differing only in the returned iterator's type. What Jafar calls `asyncIterator.observe(asyncGenerator)` is effectively the synchronous `iterator.copy(generator)` or `stream.pipe(stream)`, and in this framework `copy` is implemented in terms of `forEach`, which is implemented in terms of `next`, exactly as it would be layered on a synchronous iterator.

```js
Stream.prototype.copy = function (stream) {
    return this.forEach(stream.next).then(stream.return, stream.throw);
};
```

The whole stream algebra thus reduces to the one `next` primitive, the same reduction `@endo/stream`'s `pump`/`pipe`/`map` combinators follow.

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc` (§ Asynchronous Generator Functions).
