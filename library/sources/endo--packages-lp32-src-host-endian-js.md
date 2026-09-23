---
title: "@endo/lp32/src/host-endian.js — Endianness detection via typed-array aliasing"
source-slug: endo--packages-lp32-src-host-endian-js
url: https://github.com/endojs/endo/blob/master/packages/lp32/src/host-endian.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/lp32/src/host-endian.js
total-lines: 9
status: published
ingest-cycle: 243
ingest-date: 2026-06-08
lane: chat
---

# @endo/lp32/src/host-endian.js

A §nine-line-file that detects whether the host platform is little-endian and exposes the result as a module-level constant. The smallest file ingested in the library so far.

## Key design moves

- **§Endianness-detection-via-typed-array-aliasing** — Uint8Array shares buffer with Uint16Array; the discrepancy IS the evidence.
- **§The test buffer is the minimum unit that distinguishes the orderings** — two bytes [1, 0].
- **§The bytes have a distinguishing bit and don't-care padding** — the 1 is load-bearing; the 0 is just padding.
- **§Module-load evaluation memoizes the result** — when a host fact is stable, evaluate at module load and export as a constant.
- **§The name shifts from predicate to state** — `isHostLittleEndian` (function) → `hostIsLittleEndian` (constant).
- **§The named form over the IIFE form** — the name IS the documentation.
- **§Isolate the named decision in its own file** — let the file name state the purpose.
- **§The constant IS the API** + the API doesn't need a function call to retrieve the fact.
- **§Performance by construction** — the detection runs once; every call uses the cached result.

## Section files

- [§endianness-detection-via-typed-array-aliasing + §module-load-evaluation + §the-name-shifts-from-function-to-state](../sections/endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state.md) — full 9-line module ingest.

## Ingest scope

Cycle 243 (chat-lane): full 9-line module ingest. §Smallest-file-ingested-so-far. §First-explicit-observation of four patterns: §endianness-detection-via-typed-array-aliasing + §module-load-evaluation-memoizes-the-result + §the-name-shifts-from-predicate-to-state + §isolate-the-named-decision-in-its-own-file as file-shape discipline.
