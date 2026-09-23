---
title: §The postponed-handler pattern
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

§The-postponed-handler-IS-the-not-yet-ready-state-of-a-future-handler. §When-a-HandledPromise-is-constructed-but-its-handler-is-not-yet-known, §the-postponed-handler-stands-in-and-defers-every-operation-until-the-handler-resolves. §The-`donePostponing()`-callback-signals-that-the-real-handler-is-now-available + §forwards-all-postponed-operations.

§Sibling-pattern-to-cycle-238's-pet-name-handle-that-survives-across-CLI-invocations — both designs name §the-stable-handle-on-something-whose-shape-isn't-yet-fully-determined. §Two-different-shapes-of-deferred-resolution-in-library: §cycle-238 (controller's pet name binds before policy is finalized) + §cycle-241 (handler's identity binds before backing handler is determined).
