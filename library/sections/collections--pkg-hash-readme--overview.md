---
title: hash operator
source: packages/hash/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/hash` exports a `hash` function that consistently returns the same, almost-unique value for any given value (particularly objects), suitable for grouping objects into buckets with a low probability of collision. A hash method may return a string or a number, since either works as a plain-object key; non-object values pass through unchanged. Objects can supply their own `hash` method per the [[polymorphic-operator]] pattern. Implementation: a `WeakMap` (or shim) assigns and recalls a randomly generated number per object encountered (an earlier Node.js build used Aleksey Smolenchuk's `objhash` over V8's internal hash, dropped because the binary dependency was a maintenance burden).

Hash is a function that will consistently return the same, almost unique value for any given value, particularly objects. Hashing is suitable for grouping objects into buckets with a low probability of multiple non-identical values sharing the same bucket.

```js
var hash = require("@collections/hash");
hash([])
hash({})
hash(1)
```

## Polymorphic operator

A hash method may be supplied by the value itself, and `hash` will defer to it. See [[polymorphic-operator]] for the shared dispatch discipline.

```js
hash({
    hash: function () {
        return JSON.stringify(this);
    }
})
```

## Implementation

The implementation uses a `WeakMap` or a `WeakMap` shim to assign and recall a randomly generated number to every object it encounters. Hash methods in general may return either strings or numbers, since either is suitable for use as a key in a plain object. Non object values pass through hash. The Node.js implementation once took advantage of Aleksey Smolenchuk's `objhash` module, which uses V8's own internal object hash function, but the binary dependency proved a burden to maintain.

(Copyright 2015 Kristopher Michael Kowal and contributors, MIT License.)

Source: [packages/hash/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/hash/README.md) at commit `4688abad`.
