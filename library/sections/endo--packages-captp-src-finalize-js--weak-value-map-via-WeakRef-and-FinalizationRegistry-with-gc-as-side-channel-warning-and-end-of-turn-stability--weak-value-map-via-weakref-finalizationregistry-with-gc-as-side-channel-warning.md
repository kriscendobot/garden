---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: Weak-Value-Map via `WeakRef` + `FinalizationRegistry` with gc-as-side-channel warning and end-of-turn stability
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

> *Both the ability to create one, as well as each created
> one, must be treated as dangerous capabilities that must be
> closely held. A program with access to these can read side
> channels though gc that do not rely on the ability to
> measure duration. This is a separate, and bad, timing-
> independent side channel.*
>
> — `packages/captp/src/finalize.js` lines 31-34

`finalize.js` (141 lines) is the **Weak-Value-Map primitive**
for `@endo/captp`. Single export `makeFinalizingMap(finalizer,
opts)`. Authored by Mark S. Miller; last-touched 2025-06-23
(commit `5efcf7dd0` — *refactor(pass-style): faster `isObject`
(#2860)*).

This file is the **second @endo/captp source file** ingested
after cycle 154's trap.js. Where trap.js is the *user-facing
synchronous-CapTP proxy*, finalize.js is the *slot-table
substrate* that lets CapTP release export-side entries when
the JS values they point to are garbage-collected.
