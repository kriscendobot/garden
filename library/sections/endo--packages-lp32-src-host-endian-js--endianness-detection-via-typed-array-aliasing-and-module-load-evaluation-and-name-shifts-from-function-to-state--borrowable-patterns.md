---
title: §Borrowable patterns
source-slug: endo--packages-lp32-src-host-endian-js
source-url: https://github.com/endojs/endo/blob/master/packages/lp32/src/host-endian.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/lp32/src/host-endian.js
total-lines: 9
ingest-cycle: 243
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state
---

**Tier-1 (highest borrowing value):**

- §Endianness-detection-via-typed-array-aliasing — `Uint8Array` + `Uint16Array` over the same buffer; the discrepancy IS the evidence.
- §The-test-buffer-is-the-minimum-unit-that-distinguishes-the-orderings.
- §The-bytes-have-a-distinguishing-bit-and-don't-care-padding.
- §Module-load-evaluation-memoizes-the-result — when a host fact is stable, evaluate at module load and export as a constant.
- §The-name-shifts-from-predicate-to-state — `isHostLittleEndian` (function) → `hostIsLittleEndian` (constant).
- §The-named-form-over-the-IIFE-form — the name IS the documentation.

**Tier-2 (file-shape patterns):**

- §Isolate-the-named-decision-in-its-own-file — let the file name state the purpose.
- §The-constant-IS-the-API + §the-API-doesn't-need-a-function-call-to-retrieve-the-fact.
- §Performance-by-construction: §the-detection-runs-once + §every-call-uses-the-cached-result.

**Tier-3 (small-file patterns):**

- §Nine-lines-as-a-complete-platform-detection-artifact + §no-imports + §no-tests-in-the-file.
- §The-file-does-one-thing-exhaustively.
