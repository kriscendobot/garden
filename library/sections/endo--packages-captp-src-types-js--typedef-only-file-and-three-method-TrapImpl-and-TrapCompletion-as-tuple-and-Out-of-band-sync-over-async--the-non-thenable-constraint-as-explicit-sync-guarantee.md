---
title: §The non-thenable constraint as explicit sync guarantee
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

§The-fulfillment-value-is-a-non-thenable. §When-a-sync-protocol-supports-fulfillment-values, §exclude-thenables-from-the-fulfillment-shape + §the-exclusion-IS-the-sync-guarantee.

§Why: §a-thenable-fulfillment-would-need-to-be-awaited + §Trap-is-sync + §so-the-fulfillment-must-be-immediately-usable. §The-protocol-makes-this-an-invariant-not-a-runtime-check + §the-typedef-encodes-the-invariant.

§First-explicit-observation in library of §the-non-thenable-constraint-as-explicit-sync-guarantee.
