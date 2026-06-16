---
title: §Borrowable patterns
source-slug: endo--packages-eventual-send-src-postponed-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/postponed.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/postponed.js
total-lines: 46
ingest-cycle: 241
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type
---

**Tier-1 (highest borrowing value):**

- §The-postponed-handler-pattern — a handler that defers every operation until a callback signals readiness.
- §The-interlockP — name a pending promise after the synchronization shape, not after the value it carries.
- §The-resolve-callback-is-captured-via-closure-in-Promise-executor — `let cb; new Promise(r => { cb = r; })` exposes resolve outside.
- §`assert(callback)`-with-`@ts-expect-error 2454` — runtime check + TypeScript-error suppression to acknowledge the executor's synchronous run.
- §Six-method handler protocol as 2×3 axis table (three operations × two send-modes).
- §postponedOperation-as-method-name-string-used-as-key-on-HandledPromise — uniform protocol key.
- §makePostponedOperation-as-method-factory — DRY for the protocol's repeated shape.
- §The-returned-function-has-a-debug-name (`function postpone(...)`).
- §`.then(_ =>`-ignored-resolve-value-with-underscore-prefix.
- §The-commented-out-console.log-left-in-the-source as named debugging affordance.

**Tier-2 (TypeScript shape patterns):**

- §`Required<Handler<any>>` to encode completeness-of-implementation at the type level.
- §The-`<any>`-parameter as the honest type when the target is genuinely unknown.
- §Defense-by-construction-via-`Required<>`-wrapper.
- §The-tuple-type-encodes-the-two-tuple-shape (`[handler, callback]`).

**Tier-3 (small-file patterns):**

- §Forty-six-lines-as-a-complete-handler-protocol-postponement — thin wrapper around a Promise, no class machinery.
