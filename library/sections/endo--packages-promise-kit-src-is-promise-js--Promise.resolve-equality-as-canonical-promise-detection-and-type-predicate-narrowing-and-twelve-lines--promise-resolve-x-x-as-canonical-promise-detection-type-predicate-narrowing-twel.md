---
title: Promise.resolve(x) === x as canonical promise detection + type-predicate narrowing + twelve lines
source-slug: endo--packages-promise-kit-src-is-promise-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/is-promise.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/is-promise.js
total-lines: 12
ingest-cycle: 252
ingest-date: 2026-06-09
lane: chat
parent: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines
---

[`@endo/promise-kit/src/is-promise.js`](../sources/endo--packages-promise-kit-src-is-promise-js.md) is a §twelve-line-file containing one function: `isPromise(maybePromise)`. The function returns `Promise.resolve(maybePromise) === maybePromise`. This is the canonical way to detect whether a value is a genuine Promise (not just a thenable) in JavaScript.
