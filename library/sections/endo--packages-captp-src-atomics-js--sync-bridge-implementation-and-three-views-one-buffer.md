---
title: "@endo/captp src/atomics.js — SharedArrayBuffer + Atomics sync-bridge implementation; three-views-one-buffer (BigUint64+Int32+Uint8); yield as three-completion-path rendezvous; closes cycle 323 doc-to-impl arc"
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
---

# `@endo/captp src/atomics.js` — sync-bridge implementation; three-views-one-buffer; yield as three-completion-path rendezvous

The 170-line atomics.js implements the SharedArrayBuffer + Atomics sync-bridge mechanism that cycle 323's README named explicitly. Cycle 324 is **chat-lane after cycle 323's designs-lane @endo/captp README**. **Fifteenth consecutive non-garden source after the pivot** (cycles 310-324). **§fifteen-cycles-with-named-pivot-domain-stay**. **Eighth package extends** (captp's fifth file in the cluster; the README at cycle 323 was the fourth).

**Note on prior ingest**: This file was previously ingested in **cycle 169** by a scholar dispatch (paired with cycle 154's trap.js as "abstract interface + concrete implementation"). The cycle 169 section took the *synchronous-RPC-as-meta-capability* lens: three-buffer-split + Atomics-wait-notify-for-blocking-RPC + async-generator-as-resumable-state-machine + iterator-protocol-as-bidirectional-channel.

Cycle 324 is a **§the-named-complementary-lens-re-ingest** (the librarian discipline named in cycle 322 for exo-makers.js): a different lens on the same file. This cycle's framing emphasizes:
- **Pivot-cluster context**: how atomics.js relates to cycle 316 reader / cycle 320 writer (multi-view-one-buffer generalization to N views) and cycles 314/318 hex (line-level vs file-level eslint-disable variants)
- **Doc-to-impl citation-arc closure** with cycle 323 (1-cycle arc; shortest in the pivot)
- **Tier-3 discipline-variants** named for the first time (derive-don't-hardcode + X-vs-Fail distinction + internal-error-prefix + view-type-determined-by-API-constraint + language-spec-citation-with-link)
- **Yield-as-three-completion-path-rendezvous**: more specific than cycle 169's iterator-protocol-as-bidirectional-channel — the source comment explicitly narrates all three completion paths (`next()` / `return()` / `throw()`)

**§two-cycles-with-named-complementary-lens-re-ingest** (322 exo-makers.js + 324 atomics.js) — the librarian discipline is now applied to two distinct prior ingests. First-explicit-observation as a Tier-2 pattern. The cycle 169 section file lives at `endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator.md`.

**§the-named-captp-five-file-cluster-now** — cycles 154 (trap.js) + 156 (finalize.js) + 158 (loopback.js) + 323 (README) + 324 (atomics.js) = **first five-file cluster of the pivot**. The hex cluster is three files (314 + 317 + 318); the lp32 cluster is three files (315 + 316 + 320); captp is now five. **§the-named-substrate-package-IS-named-deeper-cluster** — substrate packages accumulate more files because they sit at a foundation. First-explicit-observation.

**§the-named-citation-arc-from-cycle-323-takes-1-cycle-to-close** — cycle 323 README cited *"the one based on SharedArrayBuffers in src/atomics.js"*; cycle 324 is that file. **Shortest README→source citation arc in the pivot** (1 cycle). The §the-named-cross-package-citation-arc-closes-with-cycle-315 (cycle 319) had 4 cycles; the §the-named-citation-arc-from-cycle-321-takes-2-cycles-to-close (cycle 323) had 2 cycles. Cycle 324 sets a new minimum at 1.

**§eight-citation-arc-closures-in-pivot-now** — adding cycle 323 → 324 (1 cycle) to the prior seven.

## The single most structurally interesting move

**§the-named-yield-as-three-completion-path-rendezvous** — the `trapHost` async generator's bare `yield;` (line 93) sits inside a `while (!done)` loop, with a comment (line 89-93) that *explicitly names three completion paths*:

```js
if (!done) {
  // Wait until the next call to `it.next()`.  If the guest calls
  // `it.return()` or `it.throw()`, then this yield will return or throw,
  // terminating the generator function early.
  yield;
}
```

The yield is **not** just data-output. It's a **bidirectional rendezvous point** that propagates the caller's completion semantics back into the producer:

1. **`it.next()`** resumes the generator at the yield, returning normally
2. **`it.return()`** causes the yield to return (the generator function exits as if it ran to completion)
3. **`it.throw()`** causes the yield to *throw* (the generator function propagates the thrown error)

§the-named-yield-IS-named-rendezvous-with-caller — the producer doesn't have to handle cleanup-on-cancel separately because the iterator protocol *already* provides cleanup-on-cancel via the `return()` and `throw()` methods. The comment narrates that this is *deliberate* — the trapHost relies on the iterator protocol's three-path completion semantics. **§the-named-iteration-protocol-IS-named-built-in-cleanup-protocol**. First-explicit-observation in library.

This concretizes cycle 323's Tier-3 **§the-named-iteration-as-protocol-synchronization-point** at the source level. The pattern was *named* at the README level (323); the *comment that documents the yield's three-path semantics* is at the source level (324). The doc→impl arc closes in one cycle with the source-level comment serving as the *implementation-side rationale* for the README-level concept.

## §the-named-Atomics-sync-bridge-implementation

The file implements **the canonical JS-runtime pattern for synchronous blocking from one execution context to another** via:

1. **SharedArrayBuffer** as shared memory (line 21, 50, 105)
2. **Int32Array view** for status, *because* `Atomics.notify` requires Int32Array — *with MDN link in the comment* (line 28-31). **§the-named-Int32Array-for-Atomics.notify-with-MDN-link**; **§the-named-language-spec-citation-with-link** (first-explicit-observation as a doc-citation discipline).
3. **`Atomics.notify(statusbuf, 0, +Infinity)`** on host (line 87): wake *all* waiters. **§the-named-wake-all-via-Infinity**.
4. **`Atomics.wait(statusbuf, 0, STATUS_WAITING)`** on guest (line 126): block until the value changes. **§the-named-Atomics.wait-as-named-blocking-primitive**.

This is **the only standard JS mechanism** for sync-from-async; the comment cites MDN to ground the design in the spec. First-explicit-observation as a *named-implementation* of cycle 323's named-mechanism.

## §the-named-three-views-one-buffer generalization

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

## Other key moves

- **§the-named-bit-flags-for-status** (line 13-16) — `STATUS_WAITING = 1`, `STATUS_FLAG_DONE = 2`, `STATUS_FLAG_REJECT = 4`. Powers of 2 → bitwise-combinable. **§the-named-orthogonal-flags-via-power-of-two-discipline**; **§the-named-OR-to-combine-orthogonal-bitfields** (line 86: `rejectFlag | doneFlag`); **§the-named-AND-to-test-bitfield-flag** (line 130: `statusbuf[0] & STATUS_FLAG_DONE`). First-explicit-observation as a *bitfield discipline*.

- **§the-named-MIN_DATA_BUFFER_LENGTH-IS-pathological-minimum** (line 4-5) — *"This is a pathological minimum, but exercised by the unit test."* Names the minimum-of-one-byte as a deliberate edge case kept alive by a test. **§the-named-pathological-minimum-IS-named-test-discipline**; the test is what keeps the minimum honest. First-explicit-observation.

- **§the-named-TRANSFER_OVERHEAD_LENGTH-IS-named-computed-constant** (line 7-11) — overhead derived from `BigUint64Array.BYTES_PER_ELEMENT + Int32Array.BYTES_PER_ELEMENT`; not hardcoded. **§the-named-derive-don't-hardcode-discipline**; §the-named-constant-IS-named-derived-from-type-system-not-fixed-value. First-explicit-observation.

- **§the-named-assert.equal-with-X-tagged-template** (line 33-37) — `assert.equal(overheadLength, TRANSFER_OVERHEAD_LENGTH, X\`Internal error; ...\`)`. The **X** tagged template is the @endo/errors sibling of **Fail** (cycle 316/320). §the-named-X-vs-Fail-distinction: X is for *assertion-detail*; Fail is for *short-circuit-throw*. The two are paired imports `import { X, Fail } from '@endo/errors'`. First-explicit-observation.

- **§the-named-internal-error-prefix** (line 34, 123) — error messages prefixed with *"Internal error;"* to mark them as library-bug indicators (not user errors). **§the-named-internal-error-IS-named-library-bug**; §the-named-error-prefix-discriminates-error-class. First-explicit-observation.

- **§the-named-async-generator-as-trapHost** (line 58) — `async function* trapHost([isReject, serialized])`. **§two-cycles-with-named-async-generator-protocol** (316 reader + 324 trapHost).

- **§the-named-while-not-done-with-chunked-encoding** (line 64-95) — outer loop chunks the encoded JSON; each iteration: copy slice → set remaining length → calculate next-slice + done-flag → notify guest → maybe yield. **§the-named-chunked-iteration-with-explicit-loop-state**.

- **§the-named-fast-path-for-single-chunk** (line 135-141) — *"Special case: we are done on first try, so we don't need to copy anything."* Optimizes the common case of fits-in-one-buffer payloads by avoiding allocation. §the-named-common-case-optimization-named-in-comment. First-explicit-observation.

- **§the-named-allocate-after-first-chunk-reveals-size** (line 142-144) — *"Allocate our buffer for the remaining data."* The total size is unknown until the first chunk arrives carrying `remaining`. Allocate the accumulator *once* after seeing the size. **§the-named-size-revealed-by-protocol-not-known-up-front**; §the-named-allocate-once-after-size-reveal. First-explicit-observation.

- **§the-named-it.throw-null-as-graceful-cleanup** (line 156-157) — *"This throw is harmless if the host iterator has already finished, and if not finished, captp will correctly raise an error."* Uses `it.throw(null)` to terminate the host generator. **§the-named-cleanup-via-iterator-protocol-termination**; the trapGuest *relies on* the trapHost's yield-three-completion-path discipline to clean up via `it.throw`. First-explicit-observation.

- **§the-named-TODO-with-blocking-reason-named** (line 153-155) — *"TODO: It would be nice to use an error type, but captp is just too noisy with spurious 'Temporary logging of sent error' messages."* Names the *upstream noise* that blocks the better approach. **§the-named-honest-about-temporary-workaround**; §the-named-TODO-cites-the-blocker. First-explicit-observation.

- **§the-named-TextEncoder-and-TextDecoder-as-named-pair** (line 56, 163) — host has `new TextEncoder()`, guest has `new TextDecoder('utf-8')`. **§the-named-encoder-decoder-symmetric-pair**.

- **§the-named-JSON-encode-then-byte-encode-pipeline** (line 60-61) — `const json = JSON.stringify(serialized); const encoded = te.encode(json);` — two-step serialization (object → JSON string → UTF-8 bytes). **§the-named-two-step-serialization**; §the-named-JSON-first-bytes-second-discipline. First-explicit-observation.

- **§the-named-tuple-as-protocol-payload** (line 58, 168) — `[isReject, serialized]` — 2-tuple where first is boolean-status-flag, second is the actual data. **§the-named-tagged-tuple-via-position**. Sibling to cycle 154 trap.js's §isException-tagged-tuple-result; **§two-cycles-with-named-tagged-tuple-via-position** (154 + 324).

- **§the-named-line-level-eslint-disable-discipline** (line 85, 129, 159) — three uses of `// eslint-disable-next-line no-bitwise` rather than file-level disable. Compare to cycle 314 hex encode and cycle 318 hex decode which used *file-level* `/* eslint no-bitwise: ["off"] */`. **§the-named-line-level-vs-file-level-eslint-disable**; the line-level form *marks each individual deliberate use*, while the file-level form *grants blanket permission*. §the-named-eslint-disable-discipline-variants (file-level for many-uses + line-level for few-uses). First-explicit-observation as a *discipline-variant*.

- **§the-named-startTrap-IS-named-guest-side-driver** (line 113) — `const it = startTrap()` — guest gets the iterator and drives it. Names the *role* of startTrap from the protocol description in cycle 323's README.

## Patterns the cycle extends

- §fifteen-cycles-with-named-pivot-domain-stay (310-324)
- §eight-citation-arc-closures-in-pivot-now (cycle 323 → 324 closes in 1 cycle; the shortest in the pivot)
- §three-cycles-with-named-multi-view-one-buffer (316 + 320 + 324; 2 + 2 + 3 views)
- §two-cycles-with-named-async-generator-protocol (316 reader + 324 trapHost)
- §two-cycles-with-named-tagged-tuple-via-position (154 + 324)
- §the-named-captp-five-file-cluster-now — first five-file cluster of the pivot

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability observations:

- **yield-as-three-completion-path-rendezvous** — the JS iterator protocol's built-in cleanup semantics via `return()` and `throw()`
- **Atomics-sync-bridge-implementation** — SharedArrayBuffer + Int32Array + Atomics.notify(buf, 0, +Infinity) + Atomics.wait
- **three-views-one-buffer** generalized to N views by API constraint
- **language-spec-citation-with-link** — cite MDN/specs in comments for any non-obvious type-coupling
- **bit-flags-with-power-of-two-discipline** — orthogonal flags combinable via OR, testable via AND
- **TRANSFER_OVERHEAD_LENGTH-IS-named-computed-constant** — derive constants from the type system; don't hardcode
- **internal-error-prefix** for library-bug error messages
- **it.throw-null-as-graceful-cleanup** via iterator protocol termination
- **TODO-with-blocking-reason-named** — TODOs cite the upstream blocker

## Tier-2 borrowing (multi-cycle patterns extended)

- §fifteen-cycles-with-named-pivot-domain-stay
- §eight-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-multi-view-one-buffer (316 + 320 + 324)
- §two-cycles-with-named-async-generator-protocol (316 + 324)
- §two-cycles-with-named-tagged-tuple-via-position (154 + 324)
- §the-named-captp-five-file-cluster-now (first five-file cluster of pivot)

## Tier-3 borrowing (meta-patterns)

- **§the-named-yield-as-three-completion-path-rendezvous** — the yield in async generators is a bidirectional rendezvous point with three completion paths (next/return/throw); use this instead of separate cleanup logic
- **§the-named-iteration-protocol-IS-named-built-in-cleanup-protocol** — the JS iterator protocol provides cleanup-on-cancel and propagation-of-throw "for free"
- **§the-named-multi-view-one-buffer-pattern** — N views over one ArrayBuffer; view-type is determined by API constraint
- **§the-named-Atomics-sync-bridge-implementation** — the canonical JS-runtime pattern for sync-from-async
- **§the-named-language-spec-citation-with-link** — cite MDN/ECMA in comments when a non-obvious type-coupling depends on it
- **§the-named-derive-don't-hardcode-discipline** — compute layout constants from the type system, not from hand-counted bytes
- **§the-named-pathological-minimum-IS-named-test-discipline** — keep edge-case minimums honest by having a test exercise them
- **§the-named-fast-path-for-single-chunk** — the common case of a single-chunk transfer gets a special-case optimization with the rationale commented
- **§the-named-line-level-vs-file-level-eslint-disable** — file-level for many-uses (cycles 314, 318); line-level for few-uses (cycle 324); the discipline reveals how often the rule is deliberately broken

## Synthesis-target

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
