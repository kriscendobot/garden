---
source: packages/{eventual-send,promise-kit,ses-ava}/* (shim + prepare-endo cluster)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages
source_path: packages/eventual-send/{shim,utils}.js, packages/eventual-send/src/postponed.js, packages/promise-kit/{shim,index}.js, packages/promise-kit/src/is-promise.js, packages/ses-ava/{index,prepare-endo,prepare-endo-config}.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - eventual-send
  - getting-started
  - testing
genre: §endo-source-comment-fragment §shim-and-prepare-cluster
cycle: 187
lane: chat
status: current
title: §The-`@ts-expect-error 2454` pattern (revisited)
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

```js
// @ts-expect-error 2454
assert(donePostponing);
```

§TypeScript-error-2454 is "Variable 'X' is used before being
assigned." §The-Promise-executor binds `donePostponing` at
new Promise time, before `assert(donePostponing)` runs at
line 43. §But-TypeScript-doesn't-know-the-executor-runs-
synchronously.

§The-`@ts-expect-error 2454` discipline:

- §Names-the-specific-error-code (2454) rather than a bare
  `@ts-ignore`.
- §`@ts-expect-error` (not `@ts-ignore`) — TypeScript reports
  if the error stops occurring (e.g., after a future TS
  version improves flow analysis).
- §The-comment-acknowledges-the-runtime-invariant rather than
  silently working around the type system.

§Compare-to-cycle-181-base64's `/** @type {any} */ (Uint8Array)
.fromBase64` and cycle 146-E.js' `@ts-expect-error` for
microsoft/TypeScript#50319. §All-three-are-§ts-expect-error-
with-named-issue-number. §The-pattern: §don't-suppress-the-
error-blindly; §name-what-it-is-and-why-it's-acceptable.
