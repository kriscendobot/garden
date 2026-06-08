---
title: "@endo/eventual-send/src/postponed.js — Postponed handler that defers operations until donePostponing()"
source-slug: endo--packages-eventual-send-src-postponed-js
url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/postponed.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/postponed.js
total-lines: 46
status: published
ingest-cycle: 241
ingest-date: 2026-06-08
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

- [§postponed-handler-pattern + §interlockP-with-resolve-captured-in-executor + §six-method-table-from-keys + §Required<Handler> type](../sections/endo--packages-eventual-send-src-postponed-js--postponed-handler-pattern-and-interlockP-with-resolve-captured-in-executor-and-six-method-table-from-keys-and-Required-Handler-type.md) — full 46-line module ingest.

## Ingest scope

Cycle 241 (chat-lane): full 46-line module ingest. §First-explicit-observation of four patterns: §postponed-handler-pattern + §interlockP-name as named-synchronization-shape + §`Required<>`-wrapper as completeness-of-implementation type discipline + §commented-out-console.log-as-debugging-affordance.
