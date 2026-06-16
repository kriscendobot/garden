---
title: §`Required<Iterator<void, void, any>>` typed iterator usage
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async
---

```js
{() => Required<Iterator<void, void, any>>}
```

§Iterator-with-three-type-params: §`<TYield, TReturn, TNext>`. §All-three-params-are-named:

- **`TYield = void`** — the iterator doesn't yield meaningful values.
- **`TReturn = void`** — the iterator's return value is void.
- **`TNext = any`** — the value passed to `.next()` is any.

§The-`void, void, any` shape encodes §the-iterator-as-a-pure-control-flow-coordination-mechanism-not-a-value-stream. §When-an-iterator-is-used-for-coordination-not-data, §all-three-type-parameters-are-named-explicitly + §`void`-for-yield-and-return-IS-the-no-value-encoding.

§The-`Required<>` wrapper forces every optional Iterator method to be present. §Sibling-pattern-to-cycle-241's-`Required<Handler<any>>` — §two-cycles-with-`Required<>`-wrapper-as-completeness-of-implementation discipline. §When-the-protocol-requires-the-full-Iterator-interface-not-just-the-mandatory-`next`-method, §use-`Required<Iterator<...>>`.
