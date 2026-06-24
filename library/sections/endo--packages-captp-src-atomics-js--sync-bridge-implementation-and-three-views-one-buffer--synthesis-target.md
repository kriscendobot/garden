---
title: Synthesis-target
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

Slot machine library **§`@game/comms/src/atomics.js`** — sync-bridge for game-server-to-renderer if the renderer needs synchronous reads from async server state:

1. **Three (or N) views over one SharedArrayBuffer** — pick view-type per region by API constraint (Int32Array for Atomics; BigUint64Array for 64-bit lengths; Uint8Array for opaque bytes).
2. **Cite MDN** in a comment whenever a non-obvious type-coupling exists (e.g., Atomics.notify requires Int32Array).
3. **Bit-flags with power-of-two discipline** for orthogonal status flags; OR to combine, AND to test.
4. **Computed overhead constant** from the type system, not from hand-counted bytes.
5. **`Atomics.notify(buf, 0, +Infinity)`** on producer side (wake all waiters); **`Atomics.wait(buf, 0, STATUS_WAITING)`** on consumer side (block until value changes).
6. **Async generator as trapHost** with bare `yield;` inside the loop; rely on the iterator protocol's three-completion-path semantics for cleanup.
7. **Comment narrates the three completion paths** at the yield site.
8. **Pathological minimum buffer length** kept honest by a unit test.
9. **Internal error prefix** for library-bug error messages.
10. **`it.throw(null)`** as graceful cleanup of the producer iterator.
11. **TODO with blocking reason** — cite the upstream noise that blocks the better approach.
12. **Fast path for single-chunk** transfers with rationale commented.
13. **Line-level eslint-disable** when bitwise ops are used in only a few sites; file-level when they're pervasive.
14. **Tagged tuple `[isReject, serialized]`** for protocol payloads.
