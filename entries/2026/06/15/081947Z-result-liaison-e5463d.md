---
kind: result
role: liaison
dispatch-root: dispatches/liaison--e5463d
cycle: 324
lane: chat
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 324: @endo/captp src/atomics.js (chat-lane; first five-file pivot cluster; shortest doc→impl arc closes; second complementary-lens re-ingest)

Cycle 324 ingest: **@endo/captp src/atomics.js** (170 lines) — the SharedArrayBuffer + Atomics sync-bridge implementation that cycle 323 README named explicitly. Chat-lane after cycle 323. **Fifteenth consecutive non-garden source after the pivot** (cycles 310-324). **§fifteen-cycles-with-named-pivot-domain-stay**.

## Discovery: file already ingested in cycle 169

The same file (`atomics.js`) was ingested in cycle 169 by a scholar dispatch, paired with cycle 154's trap.js as "abstract interface + SharedArrayBuffer implementation". The cycle 169 section took the **synchronous-RPC-as-meta-capability** lens.

Cycle 324 is the **second** instance of **§the-named-complementary-lens-re-ingest** (the librarian discipline first-explicit-observed in cycle 322 for exo-makers.js). **§two-cycles-with-named-complementary-lens-re-ingest** (322 + 324) — the discipline now applies to two distinct prior ingests. The discipline holds even when overlap between the new lens and the prior lens is significant; what matters is that the new lens *adds* observations the old lens didn't capture.

## Two structural records this cycle

**§the-named-captp-five-file-cluster-now** — cycles 154 (trap.js) + 156 (finalize.js) + 158 (loopback.js) + 323 (README) + 324 (atomics.js) form the **first five-file cluster of the pivot**. The hex cluster is three files; lp32 is three files; captp is five. **§the-named-substrate-package-IS-named-deeper-cluster** — substrate packages accumulate more files because they sit at a foundation. First-explicit-observation.

**§the-named-citation-arc-from-cycle-323-takes-1-cycle-to-close** — cycle 323 README cited *"the one based on SharedArrayBuffers in src/atomics.js"*; cycle 324 IS that file. **Shortest README→source citation arc in the pivot** (1 cycle). **§eight-citation-arc-closures-in-pivot-now**: 1, 2, 4, 165, 169, 175, 214, 255.

## Single most structurally interesting move

**§the-named-yield-as-three-completion-path-rendezvous** — the trapHost async generator's bare `yield;` (line 93) has a comment explicitly naming all three completion paths:

```js
if (!done) {
  // Wait until the next call to `it.next()`.  If the guest calls
  // `it.return()` or `it.throw()`, then this yield will return or throw,
  // terminating the generator function early.
  yield;
}
```

The yield is a **bidirectional rendezvous point**:
1. `it.next()` resumes the generator at the yield, returning normally
2. `it.return()` causes the yield to *return* (the generator exits as if it ran to completion)
3. `it.throw()` causes the yield to *throw* (the generator propagates the thrown error)

**§the-named-iteration-protocol-IS-named-built-in-cleanup-protocol** — the JS iterator protocol provides cleanup-on-cancel and propagation-of-throw "for free" via the three-completion-path semantics. The trapHost relies on this discipline to avoid separate cleanup logic. The comment narrates that this is *deliberate*. First-explicit-observation as a tier-3 meta-pattern.

This concretizes cycle 323's Tier-3 **§the-named-iteration-as-protocol-synchronization-point** at the source level. The pattern was *named* at the README level (323); the *comment that documents the yield's three-path semantics* is at the source level (324). The doc→impl arc closes in one cycle with the source-level comment serving as the *implementation-side rationale* for the README-level concept.

## §the-named-three-views-one-buffer generalized

The `splitTransferBuffer` function creates **three views** over one SharedArrayBuffer:
- `lenbuf` (BigUint64Array; 8 bytes; length signal)
- `statusbuf` (Int32Array; 4 bytes; Atomics-compatible status)
- `databuf` (Uint8Array; variable; payload)

**§the-named-three-views-one-buffer** generalizes cycle 316/320's *two-views-one-buffer* pattern. **§three-cycles-with-named-multi-view-one-buffer**: 316 reader (2 views) + 320 writer (2 views) + 324 atomics (3 views). **§the-named-view-type-determined-by-API-constraint** — view-type is *forced* by what the API requires (Int32Array for Atomics.notify; BigUint64Array for 64-bit lengths; Uint8Array for opaque bytes). First-explicit-observation.

## Other notable first-explicit-observations

- §the-named-Atomics-sync-bridge-implementation (the canonical JS sync-from-async mechanism)
- §the-named-Int32Array-for-Atomics.notify-with-MDN-link + §the-named-language-spec-citation-with-link
- §the-named-bit-flags-for-status with §the-named-orthogonal-flags-via-power-of-two-discipline
- §the-named-Atomics.notify-with-Infinity-wake-all + §the-named-Atomics.wait-as-named-blocking-primitive
- §the-named-MIN_DATA_BUFFER_LENGTH-IS-pathological-minimum with §the-named-pathological-minimum-IS-named-test-discipline
- §the-named-TRANSFER_OVERHEAD_LENGTH-IS-named-computed-constant + §the-named-derive-don't-hardcode-discipline
- §the-named-assert.equal-with-X-tagged-template + §the-named-X-vs-Fail-distinction (X for assertion-detail; Fail for short-circuit-throw)
- §the-named-internal-error-prefix + §the-named-internal-error-IS-named-library-bug
- §the-named-fast-path-for-single-chunk + §the-named-allocate-after-first-chunk-reveals-size
- §the-named-it.throw-null-as-graceful-cleanup + §the-named-cleanup-via-iterator-protocol-termination
- §the-named-TODO-with-blocking-reason-named (cites upstream noise as blocker)
- §the-named-JSON-encode-then-byte-encode-pipeline (two-step serialization)
- §the-named-tagged-tuple-via-position (`[isReject, serialized]`)
- §the-named-line-level-eslint-disable-discipline + §the-named-line-level-vs-file-level-eslint-disable (cycles 314/318 used file-level; cycle 324 uses line-level)

## Multi-cycle patterns extended

- §fifteen-cycles-with-named-pivot-domain-stay (310-324)
- §the-named-captp-five-file-cluster-now (first five-file cluster in pivot)
- §three-cycles-with-named-multi-view-one-buffer (316 + 320 + 324)
- §two-cycles-with-named-async-generator-protocol (316 + 324)
- §two-cycles-with-named-tagged-tuple-via-position (154 + 324)
- §two-cycles-with-named-complementary-lens-re-ingest (322 + 324)
- §eight-citation-arc-closures-in-pivot-now (1, 2, 4, 165, 169, 175, 214, 255)

## Tier-3 meta-patterns

- **§the-named-yield-as-three-completion-path-rendezvous** — async generator's yield is a bidirectional rendezvous with three completion paths; use this instead of separate cleanup logic
- **§the-named-iteration-protocol-IS-named-built-in-cleanup-protocol** — JS iterator protocol provides cleanup-on-cancel and propagation-of-throw for free
- **§the-named-multi-view-one-buffer-pattern** — N views over one ArrayBuffer; view-type determined by API constraint
- **§the-named-Atomics-sync-bridge-implementation** — the canonical JS-runtime pattern for sync-from-async
- **§the-named-language-spec-citation-with-link** — cite MDN/ECMA in comments when a non-obvious type-coupling depends on it
- **§the-named-derive-don't-hardcode-discipline** — compute layout constants from the type system
- **§the-named-pathological-minimum-IS-named-test-discipline** — keep edge-case minimums honest with a test
- **§the-named-line-level-vs-file-level-eslint-disable** — file-level for many-uses; line-level for few-uses; the discipline-variant reveals how often the rule is deliberately broken
- **§the-named-substrate-package-IS-named-deeper-cluster** — substrate packages accumulate more files because they sit at a foundation

## Synthesis-target

Slot machine library **§`@game/comms/src/atomics.js`** — sync-bridge for game-server-to-renderer:

1. **Three views over one SharedArrayBuffer** by API constraint.
2. **Cite MDN** in comments for non-obvious type-couplings.
3. **Bit-flags with power-of-two discipline**.
4. **Computed overhead constant** from the type system.
5. **`Atomics.notify(buf, 0, +Infinity)`** + **`Atomics.wait(buf, 0, STATUS_WAITING)`**.
6. **Async generator** as producer with bare `yield;` and three-completion-path comment.
7. **Pathological minimum buffer length** kept honest by a unit test.
8. **Internal error prefix** for library-bug messages.
9. **`it.throw(null)`** as graceful cleanup.
10. **TODO with blocking reason** named.
11. **Fast path for single-chunk** with rationale.
12. **Line-level eslint-disable** when bitwise ops are few.
13. **Tagged tuple `[isReject, serialized]`** for protocol payloads.

## Library state after cycle 324

- §library-reaches-836-sections from 372 source documents (source count unchanged because atomics.js was already counted from cycle 169)
- §one-hundred-and-fifty-seventh consecutive designs-chat alternation
- §fifteen-cycles-with-named-pivot-domain-stay
- §the-named-captp-five-file-cluster-now (first five-file cluster in pivot)
- §eight-citation-arc-closures-in-pivot-now (1, 2, 4, 165, 169, 175, 214, 255)
- §two-cycles-with-named-complementary-lens-re-ingest (322 + 324) — librarian discipline applied to two distinct prior ingests

## Next cycle pacing

Cycle 325 is designs-lane next. Candidate moves:

- **@endo/patterns README** — designs-lane; would close cross-package citation arc from cycle 321 ("Validation: @endo/patterns"); introduces a ninth package; @endo/patterns is heavily in the library (cycles 102 + 104 + 120 + others).
- **@endo/pass-style README** — designs-lane; would close many citation arcs (cycles 71 + 87 + 134 + 136 + 138 + 140 + 142 + 148 + 150 all are @endo/pass-style files); would NOT add a new package but would extend the most-heavily-ingested cluster.
- **@endo/exo README** — designs-lane; complement to cycle 322's exo-makers.js + cycle 239's get-interface.js + (if exists) the cycle 118 exo-tools.js.

@endo/pass-style README is the most productive choice (closes the largest number of dormant citation arcs — nine arcs to pass-style cycles spanning 71 to 150; would be the largest single-cycle arc-closure count in the pivot). Picking freely but tracking for future work.
