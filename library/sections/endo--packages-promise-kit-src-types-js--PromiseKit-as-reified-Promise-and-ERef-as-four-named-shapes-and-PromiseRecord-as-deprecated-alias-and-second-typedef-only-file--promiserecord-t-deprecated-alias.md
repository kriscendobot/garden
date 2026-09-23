---
title: §`PromiseRecord<T>` — deprecated alias
source-slug: endo--packages-promise-kit-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/types.js
total-lines: 25
ingest-cycle: 256
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file
---

```js
/**
 * PromiseRecord is deprecated in favor of PromiseKit.
 *
 * @template T
 * @typedef {PromiseKit<T>} PromiseRecord
 */
```

§The-deprecated-alias-is-still-exported — §it-aliases-the-new-name + §the-JSDoc-explicitly-says-`is deprecated in favor of PromiseKit`. §When-a-type-is-renamed-but-the-old-name-must-keep-working, §define-the-old-name-as-an-alias-of-the-new-name + §the-JSDoc-IS-the-deprecation-record.

§Sibling-pattern-to-cycle-251's-MCP-Tasks-graduates-to-an-extension and cycle-251's-three-core-features-deprecated — §two-cycles-with-named-deprecation-with-named-replacement (251 MCP Roots/Sampling/Logging + 256 PromiseRecord). §Cycle-251-deprecation-is-protocol-level; §cycle-256-deprecation-is-type-name-level.

§First-explicit-observation in library of §deprecated-typedef-alias-with-named-replacement-in-JSDoc as named rename-discipline.

§The-alias-is-a-pure-type-alias (`typedef {PromiseKit<T>} PromiseRecord`) — §no-runtime-cost + §the-alias-is-erased-at-build-time + §the-deprecation-IS-the-only-evidence-of-the-rename-at-runtime.
