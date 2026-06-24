---
title: §the-named-Atomics-sync-bridge-implementation
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

The file implements **the canonical JS-runtime pattern for synchronous blocking from one execution context to another** via:

1. **SharedArrayBuffer** as shared memory (line 21, 50, 105)
2. **Int32Array view** for status, *because* `Atomics.notify` requires Int32Array — *with MDN link in the comment* (line 28-31). **§the-named-Int32Array-for-Atomics.notify-with-MDN-link**; **§the-named-language-spec-citation-with-link** (first-explicit-observation as a doc-citation discipline).
3. **`Atomics.notify(statusbuf, 0, +Infinity)`** on host (line 87): wake *all* waiters. **§the-named-wake-all-via-Infinity**.
4. **`Atomics.wait(statusbuf, 0, STATUS_WAITING)`** on guest (line 126): block until the value changes. **§the-named-Atomics.wait-as-named-blocking-primitive**.

This is **the only standard JS mechanism** for sync-from-async; the comment cites MDN to ground the design in the spec. First-explicit-observation as a *named-implementation* of cycle 323's named-mechanism.
