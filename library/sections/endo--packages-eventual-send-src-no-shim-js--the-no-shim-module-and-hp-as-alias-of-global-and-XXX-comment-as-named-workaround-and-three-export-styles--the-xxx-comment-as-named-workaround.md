---
title: §The XXX comment as named workaround
source-slug: endo--packages-eventual-send-src-no-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/no-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/no-shim.js
total-lines: 23
ingest-cycle: 254
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles
---

```js
// XXX module exports for HandledPromise fail if these aren't in scope
/** @import {Handler, HandledExecutor} from './handled-promise.js' */
/** @import {ECallableOrMethods, EGetters, ERef, ESendOnlyCallableOrMethods, LocalRecord, RemoteFunctions} from './E.js' */
```

§The-XXX-comment names a workaround that's there for a specific reason — *module exports for HandledPromise fail if these aren't in scope*. §The-`@import`-tags-are-typedef-only-imports + §they-exist-only-because-TypeScript-checks-them-for-the-exports-below.

§XXX-as-named-workaround-prefix vs TODO: §XXX-marks-something-that-is-known-to-be-suboptimal-but-functional + §TODO-marks-something-that-is-incomplete-or-broken. §The-distinction-is-thin-but-the-Endo-codebase-honors-it.

§First-explicit-observation in library of §XXX-comment-as-named-workaround-prefix-as-distinct-from-TODO.

§Sibling-pattern-to-cycle-241's-`@ts-expect-error 2454` and cycle-245's-TS-flow-inference-workaround-via-local-rebinding and cycle-245's-`// TODO`-with-named-confusing-case — §four-cycles-with-named-TypeScript-or-tooling-workaround (241 + 245 + 245 + 254). §Each-cycle-has-a-different-shape-of-workaround-comment; §the-XXX-marker-names-the-functional-imperfection-distinct-from-broken-incomplete.
