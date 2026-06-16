---
title: §makeE(hp) — the factory parameterized by whatever HandledPromise is
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
export const E = makeE(hp);
```

§makeE-IS-the-factory + §hp-IS-the-platform-or-shim-version-of-HandledPromise. §The-factory-doesn't-care-which-version-it-receives + §the-factory's-output-is-the-`E`-API.

§Dependency-injection-of-the-platform-substrate. §When-a-library-can-work-with-either-the-platform-global-or-a-shim, §factor-the-substrate-out-as-a-parameter-to-the-factory + §the-no-shim-and-the-shim-modules-both-call-the-same-factory-with-different-arguments.

§Sibling-pattern-to-cycle-242's-the-elevator-module — §two-cycles-with-dependency-injection-of-platform-substrate. §Cycle-242-injects-the-platform-fs-module-into-the-platform-agnostic-code; §cycle-254-injects-HandledPromise-into-the-platform-agnostic-E-factory.

§Three-cycles-with-platform-power-as-factory-argument (242 + 245 + 254). §Cycle-245's-pony-shim factory takes the pony and installs it; cycle-254's-no-shim factory takes the platform global and uses it.
