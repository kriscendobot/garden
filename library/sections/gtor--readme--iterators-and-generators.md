---
title: gtor — iterators and generators (the synchronous-plural-spatial column the temporal stream primitives mirror)
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [change-propagation, streams]
status: current
---

> Abstract: gtor's **synchronous-plural-spatial column** — the `### Iterators`, `### Generator Functions`, and `### Generators` primitives — which are the lazy, synchronous analogues that the asynchronous stream primitives (promise iterators / promise generators / async generator functions) mirror one-for-one. An **iterator** is the plural *getter*: an object with a `next()` method returning an **iteration** (`{value}` or `{done: true}`), lazily and synchronously consuming many values; unlike an array it need not terminate (an `Infinity` range consumes no more memory than an empty one), and it can carry array-like combinators (`map`/`filter`/`reduce`/`forEach`, plus iterator-only `dropWhile`/`takeWhile`) that percolate one value at a time through a pipeline instead of materializing intermediate arrays. A **generator function** (`function*` + `yield`) expresses an iteration *procedurally* with lazy behavior, restoring the clarity the hand-written iterator loses; its returned iterator gains a richer `next(x)` (the argument becomes the value of the `yield` it resumes), plus `throw` and `return` methods — the bidirectional consumer→producer channel that **foreshadows a stream reader pushing back on, and prematurely stopping, a stream writer**. Generators and iterators are **unicast** and cooperative: values flow forward, requests for more flow backward. A **generator** (no JS standard; included for symmetry) is the plural *setter* — an object whose `yield(v)` *method* appends to a collection, the dual of the array iterator and the synchronous precursor of the asynchronous generator's `yield`/`return`/`throw`. This column is why gtor "reviews the spatial primitives first": the temporal stream algebra is the same shapes rotated onto the time axis.

This section consolidates gtor's three synchronous-plural-spatial primitives (README `### Iterators`, `### Generator Functions`, `### Generators`). They are the spatial column whose temporal analogues — [[gtor--readme--promise-iterators-and-generators]] and [[gtor--readme--asynchronous-generator-functions]] — the rest of the change-propagation corpus instantiates as `@endo/stream`'s Reader/Writer. The mapping is exact: an iterator is the plural getter, a generator the plural setter, a generator function the procedural lazy producer.

## §Iterators — the plural getter (lazy, synchronous, possibly infinite)

An **iterator** is an object that lets us lazily but synchronously consume multiple values. It implements `next()`, returning an object that may have a `value` and may have a `done` property; gtor names this object an **iteration** (the standard leaves it unnamed). When the sequence is exhausted, `done` is `true`. (Generator functions return iterators that extend this: a non-final iteration's `value` corresponds to a `yield`, a `done` iteration's `value` to a `return`.)

```js
var iterator = iterate([1, 2, 3]);
var iteration = iterator.next();
expect(iteration.value).toBe(1);
// ...
iteration = iterator.next();
expect(iteration.done).toBe(true);
```

What distinguishes an iterator from an array is that it is **lazy**, and so need not end. We can iterate non-terminating sequences (counting, fibonacci). A `range(start, stop, step)` whose `stop` is `Infinity` never produces a `done` iteration, yet — unlike an array — **an indefinite iterator consumes no more memory than an empty one**:

```js
function range(start, stop, step) {
    return {next: function () {
        var iteration;
        if (start < stop) {
            iteration = {value: start};
            start += step;
        } else {
            iteration = {done: true};
        }
        return iteration;
    }};
}
var iterator = range(0, Infinity, 1);
expect(iterator.next().value).toBe(0); // 0, 1, 2, ...
```

The **eager** equivalent returns an array and only works for bounded intervals, since it must build the whole collection in memory before returning.

Iterators may carry alternate implementations of the array combinators: `forEach` walks to exhaustion; `map` produces a new iterator of transformed values; `filter` a new iterator of values that pass a test; `reduce` exhausts the iteration (but `reduceRight` is less sensible — iterators only walk forward). Iterators also gain methods unique to their character, like `dropWhile` and `takeWhile`. **The combinators save time and space by percolating one value at a time:** a `range(0,1000,1).map(...).filter(...).reduce(...)` pipeline over *iterators* never constructs an intermediate array — each value is pulled through the reducer ← filter ← map ← range chain on demand — whereas the array version materializes a 1000-element array at each stage. This is the spatial precedent for `@endo/stream`'s pull-based reader combinators.

## §Generator Functions — procedural lazy production with a backward channel

We lose clarity converting an eager array-`range` into a hand-written iterator-`range`. **Generator functions** (`function*` declaration, `yield` to produce iterations) recover it by expressing the iteration *procedurally* with lazy behavior. Calling a generator function does **not** execute the body; it sets up a state machine and returns an iterator. Each `next()` resumes execution until the function produces an iteration or terminates:

```js
function *range(start, stop, step) {
    while (start < stop) {
        yield start;
        start += step;
    }
}
```

`next()` has three outcomes: a `yield` gives an iteration with a `value`; a `return` (express or implied) gives a `value` with `done` true; a thrown error propagates out of `next()`.

Generators and iterators are **unicast**: the consumer expects to see every value, and because they cooperate, information flows **both** forward (as values) and backward (as requests for more). The backward channel is richer than mere demand: the `next(x)` method's argument **determines the value of the `yield` expression** the generator resumes from. The canonical `echo` generator stores and yields back whatever the consumer sends — and must be *primed* (one initial `next()` to advance to the first `yield`) because it does not begin with a `yield`:

```js
function *echo() {
    var message;
    while (true) {
        message = yield message;
    }
}
var iterator = echo();
iterator.next();           // prime → {value: undefined, done: false}
iterator.next("Hello");    // → {value: "Hello", done: false}
```

> This communication back and forth between the consumer and producer **foreshadows the ability of stream readers to push back on stream writers.**

The iterator also gains `throw` and `return` methods:

- `iterator.throw(err)` makes the `yield` expression raise `err`, unraveling the generator's stack; a try-catch-finally may handle it, leaving the generator resumable if the returned iteration is not `done`; otherwise the error passes out to the `throw` caller. **This foreshadows a stream reader prematurely stopping a stream writer.**
- `iterator.return(v)` resumes the generator as if from a `return` statement regardless of where it paused, unraveling the stack and running `finally` (but not `catch`) blocks.

Like `next`, both `throw` and `return` may return an iteration (done or not) or throw. Note that Java's `hasNext()` is **not** implementable for generators (the [Halting Problem][]): the iterator must try to get a value before the generator can conclude it has none.

[Halting Problem]: http://en.wikipedia.org/wiki/Halting_problem

## §Generators — the plural setter (the spatial dual, included for symmetry)

There is no standard for a **generator** (note: distinct from a *generator function*), but for completeness: if an array *iterator* consumes an array, an array *generator* would lazily **produce** one. It implements `yield` **as a method** (behavior analogous to the keyword inside a generator function) that appends a value to the collection:

```js
var array = [];
var generator = generate(array);
generator.yield(10);
generator.yield(20);
expect(array).toEqual([10, 20]);
```

(Since ECMAScript 5, at Doug Crockford's behest, keywords may be used as property names, making this keyword/method parallel possible.) A generator might also implement `return` and `throw` methods, though a meaningful implementation for an *array* generator is a stretch. **An array generator is of dubious utility, but it foreshadows the interface of asynchronous generators**, for which meaningful `return`/`throw` implementations are easier to obtain — and that in turn informs a sensible design for asynchronous generator functions. The generator is thus the plural-spatial *setter*, completing the getter/setter dual for the synchronous-plural column.

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc` (§ Iterators / Generator Functions / Generators, lines 254–524).
