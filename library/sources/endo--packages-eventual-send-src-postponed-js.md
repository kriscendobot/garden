---
title: "@endo/eventual-send/src/postponed.js — Postponed handler (cycle 241) + ELEVENTH complementary-lens re-ingest (cycle 354)"
source-slug: endo--packages-eventual-send-src-postponed-js
url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/postponed.js
authors: [Mark S. Miller, Turadg Aleahmad, Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/postponed.js
total-lines: 46
status: published
ingest-cycle: 241
re-ingested: 2026-06-16
ingested_by: scholar (cycle 241) + liaison (cycle 354)
section_count: 2
lane: chat
---

# @endo/eventual-send/src/postponed.js

A §46-line-file that implements a §postponed-handler — a HandledPromise handler that defers every operation until a `donePostponing()` callback is invoked. The function returns a §two-tuple of `[postponedHandler, donePostponing]`. §Sixth-direct-ingest from `@endo/eventual-send/src/`.

## Key design moves

- **§The postponed-handler pattern** — a handler that defers every operation until a callback signals readiness.
- **§The interlockP** — name a pending promise after the synchronization shape, not after the value it carries.
- **§The resolve-callback is captured via closure in Promise executor** — exposes resolve outside the constructor.
- **§`assert(donePostponing)` with `@ts-expect-error 2454`** — runtime check + TypeScript-error suppression to acknowledge the executor's synchronous run.
- **§Six-method handler protocol as 2×3 axis table** — three operations × two send-modes.
- **§postponedOperation as method-name string used as key on HandledPromise** — uniform protocol key.
- **§makePostponedOperation as method-factory** — DRY for the protocol's repeated shape.
- **§The returned function has a debug name** (`function postpone(...)`).
- **§`.then(_ =>` ignored-resolve-value with underscore prefix**.
- **§The commented-out console.log left in the source** as named debugging affordance.
- **§`Required<Handler<any>>` return type** — encodes completeness-of-implementation at the type level.
- **§Forty-six lines as a complete handler-protocol-postponement** — thin wrapper around a Promise, no class machinery.

## Section files

- [§postponed-handler-pattern + §interlockP-with-resolve-captured-in-executor + §six-method-table-from-keys + §Required<Handler> type](../sections/endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type.md) — cycle 241 chat-lane, full 46-line module ingest.
- [§interlockP-as-shared-await-point + §six-handler-traps-via-factory + §async-bootstrap-via-queue + §return-tuple-not-object](../sections/endo--packages-eventual-send-src-postponed-js--interlockP-as-shared-await-point-and-six-handler-traps-via-factory.md) — cycle 354 chat-lane, **ELEVENTH complementary-lens re-ingest** with tier-3 meta-pattern elevations.

## Ingest scope

Cycle 241 (chat-lane): full 46-line module ingest. §First-explicit-observation of four patterns: §postponed-handler-pattern + §interlockP-name as named-synchronization-shape + §`Required<>`-wrapper as completeness-of-implementation type discipline + §commented-out-console.log-as-debugging-affordance.

Cycle 354 (chat-lane): **ELEVENTH complementary-lens re-ingest** — §eleven-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330 + 332 + 336 + 342 + 344 + 348 + 350 + 352 + 354). Elevates cycle 241's observations to tier-3 meta-patterns: §the-named-interlockP-as-shared-await-point + §the-named-async-bootstrap-via-queue + §the-named-six-handler-traps-via-factory + §the-named-return-tuple-not-object + §the-named-Required-handler-type-no-optional-methods. Adds cross-cycle comparisons: §two-cycles-with-named-ts-expect-error-2454 (187 + 354). Closes citation arcs with cycle 187 (167 cycles, shim cluster) + cycle 130 (224, message-breakpoints sibling) + cycle 132 (222, local.js receiver-side) + cycle 146 (208, E.js send-side) + cycle 152 (202, memo-race promise-kit sibling). Second authored-conformant single-body section doc in the post-refactor era (frontmatter + body with no `^#` or `^##` headings).
