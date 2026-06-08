---
title: "@endo/captp/src/types.js — Trap mechanism typedef contract (49 lines, typedef-only)"
source-slug: endo--packages-captp-src-types-js
url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
status: published
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
---

# @endo/captp/src/types.js

A 49-line typedef-only file that defines the Trap mechanism's TypeScript contract via JSDoc: `CapTPSlot` + `TrapImpl` + `TrapCompletion` + `TrapRequest` + `TrapGuest` + `TrapHost`. Fifth direct ingest from `@endo/captp/src/`.

## Key design moves

- **§`export {};`-typedef-only-file-pattern** — module without runtime exports.
- **§Three-method TrapImpl** (applyFunction + applyMethod + get) — distinct from six-method handler protocols (sync vs async axis).
- **§`applyMethod` is atomic lookup-of-method-and-apply** — security-by-construction against method-detach attacks.
- **§TrapCompletion as discriminator-payload tuple** `[isRejected, CapData]`.
- **§The non-thenable constraint as explicit sync guarantee** — typedef encodes the invariant.
- **§`keyof InterfaceName` as defense-by-construction** against string-union drift.
- **§Out-of-band communications** as named sync-over-async mechanism.
- **§AsyncIterator as async side of sync-over-async bridge**.
- **§`Required<Iterator<void, void, any>>`** — completeness-of-implementation + all three iterator type params named.
- **§Iterator with `void, void, any`** as pure-control-flow-coordination encoding.
- **§`AsyncIterator<...> | undefined`** as optional return encoding.
- **§Branded string typedef** (`CapTPSlot = string`) for domain-specific meaning.

## Section files

- [§typedef-only-file + §three-method-TrapImpl + §TrapCompletion-as-tuple + §out-of-band-sync-over-async](../sections/endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async.md) — full 49-line module ingest.

## Ingest scope

Cycle 249 (chat-lane): full 49-line module ingest. §First-explicit-observation of seven patterns: §`export {};`-typedef-only-file-pattern + §applyMethod-as-atomic-lookup-of-method-and-apply + §discriminator-payload-tuple-as-named-sync-result-encoding + §the-non-thenable-constraint-as-explicit-sync-guarantee + §`keyof InterfaceName`-as-defense-by-construction + §out-of-band-communications-as-named-sync-over-async-mechanism + §the-three-method-vs-six-method-handler-protocol-distinction.
