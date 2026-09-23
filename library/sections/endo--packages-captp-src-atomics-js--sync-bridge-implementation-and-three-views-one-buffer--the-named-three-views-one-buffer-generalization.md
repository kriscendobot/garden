---
title: §the-named-three-views-one-buffer generalization
source: endo--packages-captp-src-atomics-js
url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/captp/src/atomics.js
total-lines: 170
ingest-cycle: 324
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-yield-as-three-completion-path-rendezvous
  - the-named-Atomics-sync-bridge-implementation
  - the-named-three-views-one-buffer
  - the-named-multi-view-one-buffer-pattern
  - the-named-Int32Array-for-Atomics.notify-with-MDN-link
  - the-named-language-spec-citation-with-link
  - the-named-bit-flags-for-status
  - the-named-orthogonal-flags-via-power-of-two-discipline
  - the-named-OR-to-combine-orthogonal-bitfields
  - the-named-AND-to-test-bitfield-flag
  - the-named-Atomics.notify-with-Infinity-wake-all
  - the-named-Atomics.wait-as-named-blocking-primitive
  - the-named-MIN_DATA_BUFFER_LENGTH-IS-pathological-minimum
  - the-named-pathological-minimum-IS-named-test-discipline
  - the-named-TRANSFER_OVERHEAD_LENGTH-IS-named-computed-constant
  - the-named-derive-don't-hardcode-discipline
  - the-named-assert.equal-with-X-tagged-template
  - the-named-X-vs-Fail-distinction
  - the-named-internal-error-prefix
  - the-named-fast-path-for-single-chunk
  - the-named-allocate-after-first-chunk-reveals-size
  - the-named-it.throw-null-as-graceful-cleanup
  - the-named-TODO-with-blocking-reason-named
  - the-named-line-level-eslint-disable-discipline
  - the-named-captp-five-file-cluster-now
  - fifteen-cycles-with-named-pivot-domain-stay
  - eight-citation-arc-closures-in-pivot-now
parent: endo--packages-captp-src-atomics-js--sync-bridge-implementation-and-three-views-one-buffer
---

The `splitTransferBuffer` function (line 23-42) creates **three views** over one SharedArrayBuffer:

- **`lenbuf`** (BigUint64Array, 1 element, 8 bytes): remaining-data-length signal
- **`statusbuf`** (Int32Array, 1 element, 4 bytes): bit-flag status signal *and* Atomics-synchronization slot
- **`databuf`** (Uint8Array, variable length): the actual payload bytes

**§the-named-three-views-one-buffer** generalizes cycle 316/320's *two-views-one-buffer* pattern to N. The library now has:
- 2 views (Uint8Array + DataView) — cycles 316, 320
- 3 views (BigUint64Array + Int32Array + Uint8Array) — cycle 324

**§the-named-multi-view-one-buffer-pattern** — the underlying ArrayBuffer is the substrate; views give *typed* access to different *regions*. **§three-cycles-with-named-multi-view-one-buffer** (316 + 320 + 324). First-explicit-observation as a *parameterized* pattern (N varies by what the protocol needs).

The view-type choice is constrained by the *use*:
- Length needs 64-bit unsigned → BigUint64Array
- Status needs Atomics → Int32Array (per MDN)
- Data is opaque bytes → Uint8Array

§the-named-view-type-determined-by-API-constraint. First-explicit-observation.
