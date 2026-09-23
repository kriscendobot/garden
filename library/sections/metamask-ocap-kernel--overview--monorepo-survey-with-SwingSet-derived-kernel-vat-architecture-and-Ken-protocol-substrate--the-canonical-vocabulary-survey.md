---
section: monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
source: metamask-ocap-kernel--overview
topics: [daemon, captp, persistence]
status: current
title: The §canonical-vocabulary survey
parent: metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
---

The glossary defines the canonical SwingSet-derived
vocabulary that the rest of the codebase uses:

| Term | Definition | Endo parallel |
|------|------------|---------------|
| **kernel** | centralized manager of vats and distributed objects | Endo daemon (cycle 119's daemon-capability-bus) |
| **vat** | unit of compute managed by the kernel; isolated process | Endo worker |
| **baggage** | persistent key-value storage for a vat's durable state | Endo pet store + formula graph |
| **bootstrap** | init method on bootstrap vat's root object | Endo daemon's *Familiar* root |
| **distributed object** | persistent object in a vat, async-accessible to other vats | Endo's remotable + formula identifier |
| **exo** | remotable created with `makeDefaultExo()` from `@metamask/kernel-utils/exo` (not `Far` from `@endo/far`) | cycle 108's `defineExoClass` directly |
| **endowment** | initialization-time capability handed to a vat | Endo's *powers* |
| **kernel service** | object registered with kernel; vats call via `E()`; runs in kernel context | Endo's host methods |
| **supervisor** | kernel-space component managing vat lifecycle + messages | Endo's daemon supervisor (cycle 119) |
| **kref** (kernel reference) | string like `ko42` identifying an object kernel-wide | Endo's formula identifier |
| **vref** (vat reference) | identifier of an object within a vat's scope | (no direct Endo parallel — Endo runs without vat-scoping) |
| **rref** (remote reference) | identifier of an object within a remote channel's scope | Endo's CapTP slot index |
| **eref** (endpoint reference) | union of vref and rref | (no parallel) |
| **clist** | bidirectional mapping between channel-specific identifiers and refs | Endo's CapTP slot table (cycle 156's `finalize.js` weak-value-map) |
| **channel** | communication pathway between components | Endo's CapTP connection |
| **stream** | remote async iterator from `BaseDuplexStream` (uses `@endo/stream`'s Reader interface) | cycle 137's daemon-message-streaming |
| **subcluster** | logically-related group of vats launched together | Endo's *bundle* |
| **system subcluster** | privileged subcluster declared at kernel startup | Endo's *host* posture |
| **run queue** | kernel's main execution queue, one item per crank | (no direct Endo parallel — different concurrency model) |
| **crank** | one item dispatched from run queue (one message delivery) | (Ken protocol concept; no Endo parallel yet) |
| **GC** | reference-count-based; kernel/liveslots/JS gc are *mutually independent* | cycle 156's gc-driven finalization + Endo's retention paths (cycle 49) |
| **revocation** | invalidating an object reference | Endo's revoke (cycle 144's dot-membrane.js) |

The §kref-vref-rref-eref four-layer name-space is the most
distinctive divergence from Endo. Endo conflates many of these
into the formula-identifier shape; ocap-kernel separates them
*explicitly* and the doc spells out which scope each ref
operates in.
